### Testear funcionamiento de cluster de EKS

#### Objetivo: Crear un pod con nginx y hacerle un curl.


#### Definiciones: 

<br>

**deployment.yml:**

<br>

El deployment se llama "nginx-deployment" y utiliza la imagen "nginx:alpine". Específicamente, se define una réplica del contenedor nginx, un puerto que expone el contenedor (puerto 80) y un punto de montaje del volumen para un archivo de configuración. La configuración del archivo de configuración se define en un ConfigMap llamado "nginx-config". El archivo de configuración establece un servidor que escucha en el puerto 80 y dirige el tráfico al archivo index.html. El pod creado por este deployment es seleccionado por el service "nginx-service" que expone el puerto 80 de ese pod como un NodePort en el puerto 30001.

<br>

**service.yml:**

<br>

Este Service es un objeto de Kubernetes que expone el Deployment anteriormente descrito (que tiene el nombre "nginx-deployment") como un servicio accesible a través de la red. El Service tiene el nombre "nginx-service" y utiliza un tipo de servicio de NodePort, lo que significa que se asignará un puerto en cada nodo del clúster de Kubernetes para acceder al servicio.

El Service se asocia con los pods que tienen la etiqueta "app: nginx" a través del selector. Además, expone el puerto 80 del pod como el puerto 80 del Service, lo que significa que los clientes pueden acceder al Service en el puerto 80. También se especifica un nodePort para exponer el Service en un puerto específico del nodo.

<br>

**configmap.yml:**

<br>

Este ConfigMap se utiliza para almacenar la configuración de Nginx, que se utiliza para configurar el servidor web Nginx en el pod de Kubernetes. Contiene un archivo de configuración "default.conf" que se monta en el contenedor de Nginx en el directorio "/etc/nginx/conf.d". El archivo de configuración define la configuración del servidor Nginx para escuchar en el puerto 80, servir el archivo index.html como página de inicio y definir la ubicación de la raíz del servidor.

<br>

#### Crear manifiestos

1 - Creamos un namespace

2 - Crear archivo deployment.yml

3 - Crear archivo service.yml

4 - Crear archivo configmap.yml

<br>

#### Aplicar manifiestos: 

```bash
kubectl create namespace curlnginx
kubectl apply -f nginx-deployment.yml -n curlnginx
kubectl apply -f nginx-service.yml -n curlnginx
kubectl apply -f nginx-config.yml -n curlnginx
```

#### Verificar funcionamiento

Obtenemos la ip de los nodos: 

```bash
kubectl get nodes -o wide
```

Obtener puerto asignado con el nodeport:

```bash
kubectl get svc nginx-service
```

Hacemos un curl: 

```bash
curl <direccion-ip-nodo-worker>:<puerto>
```

<br>
