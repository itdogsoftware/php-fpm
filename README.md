# Php Fpm

php-fpm with necessary docker-php-ext enabled & composer. This can be used with kubernetes with FCGI mode.

## start minikube
```
minikube start
```

## setup docker-env with posershell
```
powershell
minikube docker-env | Invoke-Expression
```
## Build

```bash
$ docker build -t local/php-fpm .
```

## Run

```bash
$ docker run --name test -d -p 8080:80 --rm -it local/php-fpm
```

## Login to bash
```bash
docker exec -it test /bin/bash
```

## Steps to push image to docker
``` 
docker login
```

# Find the image id
```
docker image
```

# Tag the id with docker's registry name
```
docker tag xxxxx itdogsoftware/php-fpm:v1.0.0
```

# Push to docker
```
docker push itdogsoftware/php-fpm:v1.0.0
```

# add the latest tag repeat the above steps.

