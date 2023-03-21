
### Sprint 2

**Objetivos:** El objetivo de este sprint es poder armar un pipeline CI/CD en donde se clone el proyecto, se haga un build de la imagen, se hagan los testeos y luego se haga un push al registry de dockerhub.

Tareas:

- Crear dockerfile
- Crear Jenkinsfile
- Configurar instancia ec2 para que tenga instalado Jenkins mediante docker.
- Verificar funcionamiento 
- Armar presentacion PPT con screens


#### Estructura del proyecto app-devops-bootcamp

```bash
app-devops-bootcamp/
|-- Jenkinsfile
|-- api-store
  |-- dockerfile
  |-- package.json
  |-- package-lock.json
  |-- src/
  |   |-- ...archivos de código fuente...
  |-- test/
  |   |-- ...archivos de prueba ...
```


<br>

>Siempre es recomendable realizar pruebas en local de todo el proyecto para evitar incurrir en gastos en ambientes en la nube, es por ello que a continuacion se detallan como realizar pruebas.


#### Pruebas en local: 

Se debe tener instalado mongodb una vez instalado se debe setear un usuario y una clave, en este caso nuestra app se loguea con root y password root_password

1- Iniciamos el shell de mongodb

```bash
mongo
```

2- Nos conectamos a la base de datos de administración

```bash
use admin
```

3- Creamos el usuario solicitado 

```bash
db.createUser({
  user: "<nombre_de_usuario>",
  pwd: "<contraseña>",
  roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
})
```

4- Salimos

```bash
exit
```

5- Reiniciamos el servicio de mongo de nuestro ubuntu.

```bash
systemctl restart mongodb
```

<br>

Antes de compilar nuestro proyecto debemos probar que nuestro codigo funcione y tal como lo indica en la documentacion podemos hacer lo siguiente para verificar.


#### Instalacion

```bash
$ npm install
```

<br>

Los siguientes comandos requieren tener mongodb corriendo ya que crea una base de datos con una tabla 

#### Running app

#### development

```bash
npm run start
```

#### watch mode

```bash
npm run start:dev
```

#### production mode

```bash
npm run start:prod
```

<br>

>Si hacemos un curl al localhost:3000 nos deberia devolver DevOps Bootcamp!


<br>

Luego para hacer los testeos no es necesario que nuestra base de datos este corriendo , ya que las pruebas que se realizan son de los metodos.

<br>

#### Test

```bash
# unit tests
npm run test
```
```bash
# e2e tests
npm run test:e2e -->no funciona
```

```bash
# test coverage
npm run test:cov
```

<br>

Una vez que verificamos que nuestro codigo funciona correctamente estamos en condiciones de hacer un build de la imagen.

<br>

#### Crear Dockerfile con proyecto:

```bash
docker build -t backend-devops:v3 .
```

#### Correr el contenedor

```bash
docker run -p 3000:3000 backend-devops:v3
```
<br>

#### Testeos

El objetivo de este sprint es poder armar un dockerfile, ejecutar los testeos y luego hacer un push de la imagen al registry de dockerhub

Para probar que desde dentro del contenedor los testeos funcionan primero debemos conectarnos al contenedor de la siguiente manera

```bash
docker exec -it <id-contenedor> sh 
```

Una vez dentro ejecutar el testeo 

```bash
npm run test
``` 

Si da ok podemos decir que nuestra imagen esta lista para hacer pusheada al registry y luego ser consumida dentro de un deployment en eks.




