#!/bin/bash

echo "Starting vpn services"
echo "Checking certificates..."
./certgen.sh && docker-compose up -d 
echo "=============================="
echo "Please visit https://${NGINX_HOST}/${FREESBY_PREFIX}/vpn for enabling OpenConnect VPN endpoint"
echo "Please visit https://${NGINX_HOST}/${FREESBY_PREFIX}/sstp for enabling SSTP VPN endpoint"

