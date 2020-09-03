FROM alpine

ENV PASSWD_FILE=/var/www/.htpasswd
ENV USERS_FILE=/users.txt

RUN apk add --update apache2-utils bash \
    && rm -rf /var/cache!/apk/*

ADD makehtpasswd.sh /usr/local/bin/makehtpasswd.sh

CMD [ "/usr/local/bin/makehtpasswd.sh" ]

