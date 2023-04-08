# Tools installation on a linux machine

<br>

- Minikube
- jenkins
- argoCD
- docker
- eksctl
- kubectl
- aws-cli
- curl
- git
- docker-compose

<br>
<br>

## Levantar Jenkins con docker-compose.
---

<br>

```bash
cd webdemo/terraform/yaml
```
```bash
docker-compose up -d
```

## Plugins y herramientas a instalar en jenkins

- configurar credenciales github_id dockerhub_id
- instalar plugins nodejs , docker , gitpush 
- en la configuracion de node js en el name ponerle nodejs_for_test
- en la configuracion de docker (configure clouds)  tcp://docker:2376
- se debe generar una credencial del tipo secret text con el nombre snyktoken y el token correspondiente de la cuenta de snyk (esto esta declarado en el stage snyk scan )
- lo mismo para el stage de issue se debe generar un secret text con el nombre token-github y el token correspondiente de github (esto se declarar en el stage issues)
- otro tema:  no pude hacer andar el plugin de snyk entonces  hice lo siguiente conectado dentro del contenedor de jenkins : 

```bash
wget https://github.com/snyk/snyk/releases/download/v1.667.0/snyk-linux
chmod +x snyk-linux
sudo mv snyk-linux /usr/local/bin/snyk
```
- el plugin se snyk en si lo tengo instalado pero en un momento no me funciono y fui por esto que les comente mas arriba , despues toque una configuracion mas pero para ese entonces ya lo habia instalado a mano

<br>


## Levantar Minikube
---
<br>

```
minikube start
```

<br>

## Instalar ArgoCD in k8s
---
<br>

```
minikube kubectl -- create namespace argocd
```
```bash
minikube kubectl -- apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```
<br>

## Acceder ArgoCD UI
---
<br>

```bash
minikube -- kubectl get svc -n argocd
```
```bash
minikube -- kubectl port-forward svc/argocd-server 8080:443 -n argocd
```
<br>

## Login with admin user and below token (as in documentation):
---

<br>

```
minikube kubectl -- -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
```
<br>












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
