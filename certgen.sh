#!/bin/bash
echo "About to generate certificates"
pushd ./certbot
echo "Starting acme challenge server"
docker build -t freesby_certbot $(pwd)
docker volume create html
docker run --env-file ../shared.env  --privileged=true -v $(pwd)/templates:/etc/nginx/templates -v html:/usr/share/nginx/html -p 80:80 --name freesby_acme -d nginx:stable-alpine
sleep 3s
docker run -it --env-file ../shared.env -v $(pwd)/etc/letsencrypt:/etc/letsencrypt --volumes-from freesby_acme --name freesby_certbot  freesby_certbot 
docker stop freesby_acme
docker rm freesby_acme
docker rm freesby_certbot
docker volume rm html
popd
echo "All done"
