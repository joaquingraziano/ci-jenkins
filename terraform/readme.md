##Despliegue de terraform
```
terraform init
terraform plan
terraform apply
```
##Cambiar de entorno
```
terraform workspace new entornoAcambiar
```
##Conectarse al Cluster via kubectl
```
rm ~/.kube/config
aws eks update-kubeconfig --name entorno-eks-webdemo --alias entorno-eks-webdemo --region us-east-1 --profile profilename
kubectl get all
```
##Probar cluster
```
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml -n nginx
kubectl apply -f service.yaml -n nginx
kubectl get pods -n nginx
kubectl get svc -n nginx
curl http://<nginx-service-ip>
```
Y destruir el test nginx
```
kubectl delete namespace nginx
```
Destruir infrastructura
```
helm uninstall aws-load-balancer-controller
terraform destroy --auto-approve
```

##Conectarse a ec2 jenkins instance

```
terraform init
terraform plan
terraform apply
```
Esperar el output del ec2 instance, necesitamos el public dns para hacer ssh y obtener la pwd de jenkins y la misma public dns nos sirve para conectarnos via navegador web.
```
ssh -i "key_pair.pem" ubuntu@public_dns
sudo cat /var/lib/jenkins/secrets/initialAdminPassword #Guardar la pwd para jenkins
```
Luego en un navegador web ingresar
```
PUBLIC_DNS:8080
Ingresar el pwd de jenkins
```
