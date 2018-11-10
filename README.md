# docker-laravel
Laravel dockerized with: gcr.io/google-appengine/php72:latest, postgres:10.4-alpine, redis:4.0.11-alpine and others.

## How to use locally

- You need to have docker installed
- Put docker-compose.yml file on the root of your laravel project
- Run ```docker-compose up -d```
- Run ```docker-compose run app composer update```
- Thats all folks :) Now you have locally exactly the same image that you run on GAE flexible php environment.

- Of course, remember to bind your .env variables and hosts with your docker-compose.yml file.

## How to use in Google App Engine (GAE)

Just put the files on the root of your laravel project, then change your [app.yaml](https://cloud.google.com/appengine/docs/flexible/php/configuring-your-app-with-app-yaml) section: `runtime: php` to `runtime: custom`. Thats it 🎉

## Extra files

You can edit php.ini, nginx.conf and php-fpm.conf files, just add then to the root folder and make your changes, they will be enabled on the next `docker-compose up --build`

## Swoole

I did some edits in the Dockerfile, extending the official image (gcr.io/google-appengine/php72:latest) to enable swoole extension to get better performance. If you want use it, you can install this package: https://github.com/swooletw/laravel-swoole. If you don't wanna to use swoole extension, then remove it from php.ini and Dockerfile or call the gcr.io/google-appengine/php72:latest directly from the docker-compose.yml file.
