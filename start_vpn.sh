#!/bin/bash

echo "Freesby (Free Society in Belarus) v 0.5"
echo "======================================="
echo "Starting vpn services"
echo "Checking certificates..."
./certgen.sh && docker-compose up -d 
echo "=============================="
source ./shared.env
echo "Please visit https://${NGINX_HOST}/${FREESBY_PREFIX}/vpn for enabling OpenConnect VPN endpoint"
echo "Please visit https://${NGINX_HOST}/${FREESBY_PREFIX}/sstp for enabling SSTP VPN endpoint"

