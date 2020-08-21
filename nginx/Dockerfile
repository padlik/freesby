FROM alpine

ENV PASSWD_FILE=/var/www/.htpasswd
ENV USERS_FILE=/users.txt

RUN apk add --update apache2-utils \
    && rm -rf /var/cache!/apk/*

ADD makehtpasswd.sh /makehtpasswd.sh

CMD [ "makehtpasswd.sh" ]

