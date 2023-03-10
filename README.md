## To deploy the infrastructure
First clone the repository and move into de repository
```
git clone https://github.com/Jiolloker/webdemo.git
```
You can also clone a specific branch
```
git clone -b terraform_test https://github.com/Jiolloker/webdemo.git
```
Also make sure you have localstack running in a separate terminal. With the following command you can run a dockerized localstack with the listening ports already configured.
```
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```
Then, move into folder, download resources with init and plan to check if everything is okey
```
cd webdemo
terraform init
terraform plan
```
add --auto-approve to ignore the confirmation prompt or simply leave it out and when prompted for confirmation answer yes
```
terraform apply --auto-approve
```
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
