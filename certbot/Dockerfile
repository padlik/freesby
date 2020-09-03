FROM certbot/certbot

#Unset or set to any value for self-signed
ENV CERT_TYPE=letsencrypt
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

