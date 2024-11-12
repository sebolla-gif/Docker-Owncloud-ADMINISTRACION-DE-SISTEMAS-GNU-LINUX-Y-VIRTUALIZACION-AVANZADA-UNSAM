# Proyecto de Nube Privada con OwnCloud y Docker
Este proyecto utiliza OwnCloud para crear una nube privada personalizable. Se configura con Docker utilizando PostgreSQL como base de datos y Redis como sistema de caché.
## Requisitos

Antes de comenzar, asegúrate de tener instalado:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/)

## Estructura del Proyecto

Este proyecto utiliza **Docker Compose** para gestionar múltiples contenedores, incluyendo:

- **OwnCloud**: Aplicación de nube privada.
- **PostgreSQL**: Base de datos relacional para almacenar los datos de OwnCloud.
- **Redis**: Caché en memoria para mejorar el rendimiento de OwnCloud.

