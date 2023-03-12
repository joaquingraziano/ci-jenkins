
### Representación gráfica de una arquitectura de clúster de Kubernetes que se ejecuta en Amazon Elastic Kubernetes Service (EKS).


#### La imagen presenta un esquema de una arquitectura típica de Kubernetes, donde se pueden ver los siguientes componentes:

<br>

**Control Plane:** que es la parte central de la arquitectura y contiene los componentes que manejan la gestión del clúster, como el API Server, etcd, el Control Manager y el Scheduler.

**Workers Nodes:** son las máquinas virtuales que conforman el clúster, y en donde se ejecutan los contenedores que representan las aplicaciones y servicios que se desean desplegar.

**Network Load Balancer:** es el componente encargado de distribuir el tráfico entre los diferentes Workers Nodes del clúster, garantizando así la alta disponibilidad y escalabilidad de las aplicaciones.


**Jenkins:** Se recomienda tener al menos dos instancias de Jenkins para lograr alta disponibilidad y redundancia. De esta manera, si una instancia de Jenkins falla, la otra instancia puede continuar con el trabajo. Además, también se puede utilizar un balanceador de carga para distribuir la carga de trabajo entre las dos instancias de Jenkins.  Para jenkins se utiliza ALB , que es capaz de distrubuir el trafico entre varias instancias EC2 en diferentes AZ. 


**BD:** Se crean 2 instancias de RDS en diferentes AZ, una para escritura y otra para lectura,lo que permitiría que los datos se repliquen automáticamente de la instancia de escritura a la instancia de lectura. De esta manera, si una de las zonas de disponibilidad falla, la base de datos seguirá estando disponible en la otra zona. Para la BD se utiliza NLB  este funciona a nivel de conexion TCP/IP lo que permite manejar grandes cantidades de trafico y proporcionar baja latencia. , tambien con NLB se puede equilibrar carga entre varias instancias de RDS en distintas AZ.


**Workers nodes:** Utilizan el mismo NLB que la base de datos.




> En la imagen se pueden identificar dos subredes, una pública y otra privada.

>La subred pública se representa con la dirección IP 10.0.1.0/24  y 10.0.2.0/24 y se encuentra ubicada en la parte superior de la imagen. Esta subred está conectada a un balanceador de carga (Load Balancer) que se encarga de enrutar el tráfico entrante a los nodos (Workers Nodes) del clúster que se encuentran en la subred privada.

>Por otro lado, la subred privada se representa con la dirección IP 10.0.4.0/24 y 10.0.5.0/24 y se encuentra ubicada en la parte inferior de la imagen. Esta subred es donde se encuentran los nodos del clúster (Workers Nodes) que ejecutan los contenedores de las aplicaciones y servicios desplegados en el clúster. La subred privada está aislada del tráfico público de internet y solo es accesible a través del Load Balancer que se encuentra en la subred pública.

<br>

#### Diagrama

![DiagramaEKS](/img/diagramaEks.png)