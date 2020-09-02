#!/bin/sh
echo "About to generate certificates"
pushd ./certbot
echo "Starting acme challenge server"
docker-compose run acme -d
sleep 3s
echo "Genrating certificates"
docker-compose run certbot
docker-compose down
popd
echo "All done"
