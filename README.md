# :whale::cloud:Proyecto de Nube Privada con OwnCloud y Docker:cloud::whale:
Este proyecto utiliza OwnCloud para crear una nube privada personalizable. Se configura con Docker utilizando PostgreSQL como base de datos y Redis como sistema de caché.
## Requisitos

Antes de comenzar, asegúrate de tener instalado:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)

## Estructura del Proyecto

Este proyecto utiliza *Docker Compose* para gestionar múltiples contenedores, incluyendo:

- *OwnCloud*: Aplicación de nube privada.
- *PostgreSQL*: Base de datos relacional para almacenar los datos de OwnCloud.
- *Redis*: Caché en memoria para mejorar el rendimiento de OwnCloud (Caché, gestión de sesiones y sincronización de archivos).

### Opcional

Además, el proyecto incluye un *script* en *Bash* que permite generar un archivo de *Docker Compose* con múltiples usuarios, cada uno con su propia base de datos. Para ejecutar este *script*, es necesario contar con un sistema operativo *Linux* que utilice *Bash* como *shell*.

> [!NOTE]
> Si no se utiliza el *Script*, el archivo de *Docker Compose del proyecto está configurado para dos usuarios.
  
A continuación se hará una breve descripció de los bloques de código:

## Servicio de OwnCloud

```yaml
owncloud_user1:
    image: owncloud/server:latest
    container_name: owncloud_user1
    ports:
      - "8081:8080"
    depends_on:
      - postgres_user1
      - redis_user1
    environment:
      - OWNCLOUD_DB_TYPE=pgsql
      - OWNCLOUD_DB_NAME=owncloud_user1
      - OWNCLOUD_DB_USERNAME=user1
      - OWNCLOUD_DB_PASSWORD=password1
      - OWNCLOUD_DB_HOST=postgres_user1
      - OWNCLOUD_REDIS_HOST=redis_user1
      - OWNCLOUD_ADMIN_USER=admin_user1
      - OWNCLOUD_ADMIN_PASSWORD=adminpassword1
    volumes:
      - owncloud_data_user1:/mnt/data
    restart: always
```


 ### Image 
 Este comando trae la imagen deseada (*owncloud/server) junto a la versión (latest*)

### Ports 
En este primer caso se utiliza *8001:8000*

8001 Representa el puerto local a abrir mientras que el puerto 8000 es el que se abre en el container. 

### Depends_on: 

En este apartado mencionas al servicio de Owncloud no comenzar hasta que *Postgres* y *Redis* del user1 hayan inicializado correctamente.

### Environment

En este apartado se definen variables como las de la Base de datos de Postgres (*OWNCLOUD_DB_TYPE*, *OWNCLOUD_DB_NAME* *OWNCLOUD_DB_USERNAME* y *OWNCLOUD_DB_PASSWORD*). Tambien para Redis, con la variable *OWNCLOUD_REDIS_HOST*, la cual le define a Owncloud donde encontrar Redis. En este caso, se está usando *redis_user1* como el nombre del contenedor que ejecuta Redis.
Por ultimo, se definen las variables de Admin (*OWNCLOUD_ADMIN_USER* y *OWNCLOUD_ADMIN_PASSWORD*)

### Volumes
Acá vas a apartar un volume persistente para Owncloud ubicado en este *path* (owncloud_data_user1:*/mnt/data*)

Lo interesante de este apartado es que en caso de que el contenedor fuese removido, la información contenida en el volumen continuará sin cambios. 
### Restart
Esta variable esta configurada como *always* y define que el contenedor se reinicie de forma automática siempre que se detecte un comportamiento extraño. 

## Servicio Postgres 

Si pudiste entender el servicio de OwnCloud, vas a lograr interpretar esta configuración sin inconvenientes. 
```yaml
{
 postgres_user1:
    image: postgres:15
    container_name: postgres_user1
    environment:
      POSTGRES_USER: user1
      POSTGRES_PASSWORD: password1
      POSTGRES_DB: owncloud_user1
    volumes:
      - postgres_data_user1:/var/lib/postgresql/data
    restart: always
}
```

Lo definido para Postgres no presenta cambios respecto a lo mencionado en Owncloud. Verificar que se repiten los apartados *Image, **Container_name, **environment* y *volumes*.


## Servicio Redis
```yaml
{
  redis_user1:
    image: redis:7
    container_name: redis_user1
    command: ["redis-server", "--requirepass", "redispassword1"]
    environment:
      - REDIS_PASSWORD=redispassword1
    volumes:
      - redis_data_user1:/data
    restart: always
    }
```

En este apartado lo unico que destaca frente a los demas es *command*
En el mismo se define:
"--requirepass", "redispassword1" ya que el comando por default es levantar el servidor de redis (*"redis-server").
Debe observarse que a su vez la clave "redispassword1" se define en **environment* del servicio Redis.

### USER 2
A continuación podrá observarse que el código se repite pero mencionando un user 2. Esto fue parte de las pruebas donde se levanto un servicio de OwnCloud en paralelo (Verificar que tambien se abre otro puerto a nivel local). con esto podemos apreciar que es replicable infinidad de veces (Siempre evaluando si lo vale previamente)

### Volumes
Por ultimo se ve que se declara una seccion de volumes: 

```yaml
{
volumes:
  owncloud_data_user1:
  postgres_data_user1:
  redis_data_user1:
  owncloud_data_user2:
  postgres_data_user2:
  redis_data_user2:
  }
```
En este apartado final se *declaran* los volumenes que se utilizarán y dentro de los servicios se explica *dónde se deben montar esos volúmenes en los contenedores*
