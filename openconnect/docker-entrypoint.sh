#!/bin/bash
set -e


NGINX_HOST=${NGINX_HOST:-example.com}

if [ ! -d  /etc/letsencrypt/live/${NGINX_HOST} ]; then
        mkdir -p /etc/letsencrypt/live/${NGINX_HOST}
        cp /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/letsencrypt/live/${NGINX_HOST}
        cp /etc/ssl/certs/ssl-cert-snakeoil.key /etc/letsencrypt/live/${NGINX_HOST}
fi


# Create users if required
if [ -r ${USERS_FILE} ] && [ ! -f /etc/ocserv/ocpasswd ]; then
        while read username userpass
        do
                echo "Adding user ${username}"
                echo "$userpass" | ocpasswd -c /etc/ocserv/ocpasswd ${username}
        done < ${USERS_FILE}
fi

echo "Creating configuration file"
envsubst < /etc/ocserv/ocserv.conf.template > /etc/ocserv/ocserv.conf

# Open ipv4 ip forward
sysctl -w net.ipv4.ip_forward=1

# Enable NAT forwarding
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# Run OpennConnect Server
exec "$@"
