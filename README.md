# sf4-mongo-php-fpm

Base docker image for symfony 4 & mongo projects


## Example docker-compose file

```yaml
version: '3.2'

services:
    fpm:
        image: madcoders/sf4-mongo-php-fpm:latest
        environment:
            MONGODB_URL: "mongodb://mongo:27017"
            MONGODB_DB: "db_name"
            APP_ENV: dev
        volumes:
            - ./:/srv/www:delegated
            - ~/.composer:/home/docker/.composer
        working_dir: /srv/www
        depends_on:
            - mongo
    mongo:
        image: mongo:3.4.19
        restart: always
        command: --smallfiles
        ports:
            - '27117:27017'

    mongo_expres:
        image: mongo-express
        restart: always
        ports:
            - '3010:8081'
        depends_on:
            - mongo

    httpd:
        image: httpd:2.4
        depends_on:
            - fpm
        environment:
            PHP_IDE_CONFIG: 'serverName=vhost.local'
        ports:
            - '8888:80'
        volumes:
            - ./:/srv/www:delegated
            - ./docker/httpd.conf:/usr/local/apache2/conf/httpd.conf:ro
            - ./docker/vhost.conf:/usr/local/apache2/conf/vhost.conf:ro
        working_dir: /srv/www
```
