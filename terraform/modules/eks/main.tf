module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 19.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                          = var.vpc_id
  subnet_ids                      = var.subnet_id
  control_plane_subnet_ids        = var.subnet_id
  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access
  tags = {
    Terraform = "true"
  "Environment" = var.environment }
}

resource "aws_security_group_rule" "eks_ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_security_group_id
}

# Create IAM role for EKS node group
resource "aws_iam_role" "eks_node_group" {
  name = "eks-node-group-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach IAM policy to the EKS node group role
resource "aws_iam_role_policy_attachment" "eks_node_group" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

# Create the EKS managed node group
resource "aws_eks_node_group" "eks_workers" {
  depends_on = [
    module.eks, aws_iam_role.eks_node_group, aws_iam_role_policy_attachment.eks_node_group
  ]
  cluster_name    = var.cluster_name
  node_group_name = "eks-workers"
  node_role_arn   = aws_iam_role.eks_node_group.arn
  subnet_ids      = var.subnet_id

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 30

  tags = {
    Terraform     = "true"
    "Environment" = var.environment
  }
}

resource "aws_eks_addon" "coredns" {
  depends_on = [
    module.eks, aws_eks_node_group.eks_workers
  ]
  cluster_name      = var.cluster_name
  addon_name        = "coredns"
  addon_version     = "v1.8.7-eksbuild.4" #e.g., previous version v1.8.7-eksbuild.2 and the new version is v1.8.7-eksbuild.3
  resolve_conflicts = "OVERWRITE"
}

## Load Balancer Controller
locals {
  cluster_name = var.cluster_name
}

module "eks-kubeconfig" {
  depends_on = [
    module.eks
  ]
  source  = "hyperbadger/eks-kubeconfig/aws"
  version = "1.0.0"

  #No se porque esto no funciona, luego en despliegue tengo que cambiarlo a mano a cluster_name
  cluster_id = module.eks.cluster_name
}

resource "local_file" "kubeconfig" {
  content  = module.eks-kubeconfig.kubeconfig
  filename = "kubeconfig_${local.cluster_name}"
}

resource "aws_iam_policy" "worker_policy" {

  name        = "worker-policy-dev"
  description = "Worker policy for the ALB Ingress"

  policy = file("iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "additional" {
  for_each = module.eks.eks_managed_node_groups

  policy_arn = aws_iam_policy.worker_policy.arn
  role       = each.value.iam_role_name
}

resource "helm_release" "ingress" {
  depends_on = [
    module.eks, aws_eks_node_group.eks_workers
  ]
  name       = "ingress"
  chart      = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  version    = "1.4.6"

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }
  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }
}

## ArgoCD

resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}


resource "null_resource" "cluster_config" {
  depends_on = [
    aws_eks_node_group.eks_workers
  ]
  provisioner "local-exec" {
    command = "rm -rf ~/.kube/config && aws eks update-kubeconfig --name ${var.environment}-eks-webdemo --alias ${var.environment}-eks-webdemo --region ${var.aws_region} --profile ${var.aws_profile}"
  }
}

resource "null_resource" "argocd" {
  depends_on = [
    null_resource.cluster_config, kubernetes_namespace.argocd
  ]
  provisioner "local-exec" {
    command = "kubectl apply -n argocd -f ${path.module}/install.yaml"
  }
}


/*
By default ArgoCD is not publicly assessable so we will make some changed to the argo-server in order to access the ArgoCD user 
interface via Load Balancer.  kubectl edit svc argocd-server -n argocd
Since we have the aws-load-balancer-controller installer we can simply change the spec.type to LoadBalancer.
After your classic load balancer is provisioned you can access the argocd ui via the load balancer dns name which can be
seen from the following command.

Try getting the port open kubectl port-forward svc/argocd-server 8080:443 -n argocd for local access
or kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}' to get a load balancer
3c06303fdc15:~ ujoshuab$ kubectl get svc argocd-server -n argocd
NAME            TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)                      AGE
argocd-server   LoadBalancer   10.100.22.181   a7387400f42114d9b849e3f2ec543ae8-795478302.us-east-2.elb.amazonaws.com   80:31241/TCP,443:31671/TCP   61m
external-ip:80, takes a few mins to initialize
Get password kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
This secret where the argocd server password is stored is not secure and should be deleted after updating the password with the command below.
argocd account update-password
*/