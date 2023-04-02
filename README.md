# Tools installation on a linux machine
Minikube, jenkins, argoCD, docker, eksctl, kubectl, aws-cli, curl, git, docker-compose.


Levantar Jenkins con docker-compose.
```
cd webdemo/terraform/yaml
docker-compose up -d
```

Levantar Minikube
```
minikube start
```

# Instalar ArgoCD in k8s
```
minikube kubectl -- create namespace argocd
minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
# acceder ArgoCD UI
```
minikube -- kubectl get svc -n argocd
minikube -- kubectl port-forward svc/argocd-server 8080:443 -n argocd
```
# login with admin user and below token (as in documentation):
```
minikube kubectl -- -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
```












## To deploy the infrastructure
First clone the repository and move into de repository
```
git clone https://github.com/Jiolloker/webdemo.git
```
You can also clone a specific branch
```
git clone -b terraform_test https://github.com/Jiolloker/webdemo.git
```
Move into folder, download resources with init and plan to check if everything is okey
```
cd webdemo
cd into the workspace folder of your choice
terraform init
terraform plan
```
add --auto-approve to ignore the confirmation prompt or simply leave it out and when prompted for confirmation answer yes
```
get into the different workspaces with ..
terraform workspace new dev  #change into dev, prod or staging and then
terraform apply --auto-approve
```
With this you may have deployed the infrastructure. You can check the status of the infrastructure with...
```
terraform show
rm ~/.kube/config
aws eks update-kubeconfig --name prod-eks-webdemo --alias prod-eks-webdemo --region us-east-1 --profile profilename
kubectl get nodes
```
After that, we can deploy a testing nginx server to check if we can get something from the cluster
```
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml -n nginx
kubectl apply -f service.yaml -n nginx
```
Check if everything is running
```
kubectl get pods -n nginx
kubectl get svc -n nginx
```
Copy the External_ip displayed in the service to try a curl, you should see nginx welcome page.
```
curl http://<nginx-service-ip>

```
##Destroy the infrastructure
```
kubectl delete namespace nginx
terraform destroy --auto-approve
```
## Link a la presentacion en proceso.
https://docs.google.com/presentation/d/1eE2JTty0yak0BQDvE48MWC0hFd_LResiptOVYJAdJck/edit#slide=id.g21a97ba0fc6_0_130
