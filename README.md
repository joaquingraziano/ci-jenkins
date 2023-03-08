## To deploy the infrastructure
First clone the repository and move into de repository
```
git clone https://github.com/Jiolloker/webdemo.git
```
You can also clone a specific branch
```
git clone -b terraform https://github.com/Jiolloker/webdemo.git
```
Also make sure you have localstack running in a separate terminal. With the following command you can run a dockerized localstack with the listening ports already configured.
```
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```
Then
```
cd webdemo
terraform init
terraform plan
```
terraform plan to check if everything is okey
```
terraform apply --auto-approve
```
add --auto-approve to ignore the confirmation prompt or simply leave it out and when prompted for confirmation answer yes
With this you may have deployed the infrastructure. You can check the status of the infrastructure with...
```
terraform show
```
## main.tf 


## providers.tf 
Se utiliza aws con localstack, configurados los endpoint al puerto 4566. para correr localstack con docker: 
```
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```

## Variables.tf
se crean las vpc con las subnet
