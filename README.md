# Laravel dockerized with official Google App Engine flexible php environment + swoole

Laravel dockerized with: gcr.io/google-appengine/php72 + swoole, postgres:10.4-alpine, redis:4.0.11-alpine and others 
(ready for production).

You can build this image for production on GAE flexible using auto managed redis (Memory Store service) and database 
(SQL service) by Google Cloud Plataform building from Dockerfile, or run all locally using the docker-compose file.

## How to use locally

- You need to have docker installed.
- Put docker-compose.yml file on the root of your laravel project.
- Run ```docker-compose run app bash -c "composer install"```
- Run ```docker-compose run app bash -c "php artisan migrate:fresh --seed"```
- Run ```docker-compose up```
- That's all folks :) Now you have locally exactly the same image that you run on GAE flexible php environment.
- Of course, remember to bind your .env variables and hosts with your docker-compose.yml file.

## How to use in Google App Engine (GAE)

Just put the files on the root of your laravel project, then change your [app.yaml](https://cloud.google.com/appengine/docs/flexible/php/configuring-your-app-with-app-yaml) section: `runtime: php` to `runtime: custom`. That's it 🎉. You can learn more about GAE here: https://cloud.google.com/appengine/docs/flexible/

## Tips to customization

You can edit `php.ini`, `php-cli.ini`, `nginx.conf`, `nginx-http.conf`, `nginx-app.conf`, `fastcgi_params`, 
`gzip_params`, `supervisord.conf` and `php-fpm.conf` files, just add them to the root folder and make your changes, 
they will be used on the next `docker-compose up --build` or on your next deploy to GAE using `gcloud app deploy`

The `suppervisord.conf` file is ready to run the swoole server and horizon at the start, and 
the `php artisan schedule:run` command each minute.

## Swoole

I did some edits in Dockerfile, extending the official image (gcr.io/google-appengine/php72:latest) to enable 
swoole extension to get better performance (almost 400 reqs/sec on a real world application with database/redis, etc). 
If you want use it with laravel, you can install this package: https://github.com/swooletw/laravel-swoole and config 
the port on `swoole_http.php` file to match with the port that you are listen on your upstream of `nginx.conf` file, 
the current port is `9000`. 

If you wanna to use php-fpm instead of swoole extension, then remove it from `php.ini` and `supervisord.conf`, 
uncomment the program of `supervisord.conf` file and remove the related lines of swoole from `Dockerfile`
or call the gcr.io/google-appengine/php72:latest directly from the docker-compose.yml file.

## Donations

**BTC:** 3FBtaV7ekmKMxq9pDPUqnxwLB5V48DayVx

**NANO:** xrb_3d68nt9yttgok7a54n8pakyz7jkp65dgzhcycjz1397kno1iog493bxsmxa9
