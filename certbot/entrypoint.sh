#!/bin/sh

self_signed(){
	mkdir -p /etc/letsencrypt/live/$NGINX_HOST
	openssl req -x509 -newkey -nodes rsa:4096 -keyout /etc/letsencrypt/live/$NGINX_HOST/privkey.pem -out /etc/letsencrypt/live/$NGINX_HOST/cert.pem -days 365 -subj '/CN=${NGINX_HOST}'
	ln -s /etc/letsencrypt/live/$NGINX_HOST/cert.pem /etc/letsencrypt/live/$NGINX_HOST/fullchain.pem 
}


if [ ${CERT_TYPE} != "selfsigned" ]; then
	certbot certonly --webroot --agree-tos --register-unsafely-without-email --keep-until-expiring -d $NGINX_HOST -w /usr/share/nginx/html
else
	echo "Generating self-signed certificate and key for $NGINX_HOST"
	self_signed	
fi

