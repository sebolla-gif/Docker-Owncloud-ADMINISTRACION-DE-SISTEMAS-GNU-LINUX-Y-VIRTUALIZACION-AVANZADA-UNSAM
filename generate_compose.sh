#!/bin/bash

# Solicita la cantidad de usuarios
read -p "Ingrese la cantidad de usuarios: " user_count

# Nombre del archivo docker-compose
compose_file="docker-compose.yml"

# Inicia el archivo docker-compose
cat > "$compose_file" <<EOL
version: '3.9'

services:
EOL

# Genera servicios para cada usuario
for i in $(seq 1 "$user_count"); do
    cat >> "$compose_file" <<EOL

  owncloud_user$i:
    image: owncloud/server:latest
    container_name: owncloud_user$i
    ports:
      - "808$i:8080"
    depends_on:
      - postgres_user$i
      - redis_user$i
    environment:
      - OWNCLOUD_DB_TYPE=pgsql
      - OWNCLOUD_DB_NAME=owncloud_user$i
      - OWNCLOUD_DB_USERNAME=user$i
      - OWNCLOUD_DB_PASSWORD=password$i
      - OWNCLOUD_DB_HOST=postgres_user$i
      - OWNCLOUD_REDIS_HOST=redis_user$i
      - OWNCLOUD_ADMIN_USERNAME=admin_user$i
      - OWNCLOUD_ADMIN_PASSWORD=adminpassword$i
    volumes:
      - owncloud_data_user$i:/mnt/data
    restart: always

  postgres_user$i:
    image: postgres:15
    container_name: postgres_user$i
    environment:
      POSTGRES_USER: user$i
      POSTGRES_PASSWORD: password$i
      POSTGRES_DB: owncloud_user$i
    volumes:
      - postgres_data_user$i:/var/lib/postgresql/data
    restart: always

  redis_user$i:
    image: redis:7
    container_name: redis_user$i
    command: ["redis-server", "--requirepass", "redispassword$i"]
    environment:
      - REDIS_PASSWORD=redispassword$i
    volumes:
      - redis_data_user$i:/data
    restart: always
EOL
done

# Agrega las definiciones de volúmenes
cat >> "$compose_file" <<EOL

volumes:
EOL

for i in $(seq 1 "$user_count"); do
    cat >> "$compose_file" <<EOL
  owncloud_data_user$i:
  postgres_data_user$i:
  redis_data_user$i:
EOL
done

# Mensaje de éxito
echo "Archivo docker-compose.yml generado exitosamente con $user_count usuarios."
