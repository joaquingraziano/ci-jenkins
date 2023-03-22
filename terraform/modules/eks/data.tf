data "aws_eks_cluster" "default" {
  depends_on = [
    time_sleep.wait_14min
  ]
  #No se porque esto no funciona, luego en despliegue tengo que cambiarlo a mano a cluster_name
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "default" {
  depends_on = [
    time_sleep.wait_14min
  ]
  #No se porque esto no funciona, luego en despliegue tengo que cambiarlo a mano a cluster_name
  name = module.eks.cluster_name
}

resource "time_sleep" "wait_14min" {

  // Wait for 14 minutes
  create_duration = "14m"
}