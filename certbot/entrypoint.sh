#!/bin/sh

self_signed(){
	mkdir -p /etc/letsencrypt/live/$NGINX_HOST
	openssl req -x509 -newkey rsa:4096 -nodes  -keyout /etc/letsencrypt/live/$NGINX_HOST/privkey.pem -out /etc/letsencrypt/live/$NGINX_HOST/cert.pem -days 365 -subj '/CN=${NGINX_HOST}'
	cd /etc/letsencrypt/live/$NGINX_HOST/
	ln -s cert.pem fullchain.pem 
	ln -s cert.pem chain.pem
}


if [ ${CERT_TYPE} != "selfsigned" ]; then
	certbot certonly --webroot --agree-tos --register-unsafely-without-email --keep-until-expiring -d $NGINX_HOST -w /usr/share/nginx/html
else
	echo "Generating self-signed certificate and key for $NGINX_HOST"
	self_signed	
fi

