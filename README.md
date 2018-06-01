# docker-laravel
Laravel dockerized with: ambientum/php:7.2-nginx, ambientum/npm, postgres:10.4-alpine, mariadb:10.3, redis:4.0.9-alpine and others.

## How to use

- You need to have docker installed
- Put docker-compose.yml file on the root of your laravel project
- Run ```docker-compose up -d```
- Run ```docker-compose run app composer-update```
- Run ```docker-compose run npm npm run dev```
- Thats all folks :)

- Of course, remember to bind your .env variables and hosts with your docker-compose.yml file.
