
# Pasos para sincronización de datos desde una DB Informix hacia una dn PostgreSQL
### compilamos y lanzamos el docker
docker-compose up -d --b

### Si no funciona la conexión con Postgres, busco el host y lo edito en el .env
docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' postgres


# Genero las estructuras (esquemas, tablas, trigger y stored procedure)
## Informix
docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/esquema.sh'
### Verifico
docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/select.sh'

## PostgreSQL
docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/schema'
### Verifico
docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'

## Insertamos los registros en Informix
docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/insert.sh'

### Verifico en PostgreSQSL
docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'

## Actualizo un registro en Informix
docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/update.sh'

### Verifico en PostgreSQSL
docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'

## Elimino un registro en Informix
docker-compose exec informix bash -c '/docker-entrypoint-initdb.d/delete.sh'

### Verifico en PostgreSQSL
docker-compose exec postgres bash -c '/docker-entrypoint-initdb.d/select'

