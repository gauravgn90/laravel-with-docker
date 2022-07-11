#!/bin/bash
docker-compose down -v && docker-compose build --no-cache && docker-compose up -d
sleep 15
docker exec app php api/artisan
docker exec app php api/artisan key:generate
docker exec app php api/artisan migrate
docker exec app bash -c "chmod -R 777 api/storage"
docker exec app php api/vendor/bin/phpunit tests/Unit/
docker exec app php api/vendor/bin/phpunit tests/Feature/
docker exec app bash -c "chmod -R 777 api/storage/"