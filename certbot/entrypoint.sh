#!/bin/sh

certbot certonly --webroot --agree-tos --register-unsafely-without-email -d $NGINX_HOST -w /usr/share/nginx/html

