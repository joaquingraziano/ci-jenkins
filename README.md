## main.tf 


## providers.tf 
Se utiliza aws con localstack, configurados los endpoint al puerto 4566. para correr localstack con docker: 
```
docker run --rm -it -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack
```

## Variables.tf
se crean las vpc con las subnet
