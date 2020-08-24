FROM golang:1.15.0-buster as gobuilder
WORKDIR $GOPATH/src/github.com/uprt/
RUN git clone --depth=1 https://github.com/uprt/labean 
RUN go install github.com/uprt/labean

FROM debian:buster


ENV LABEAN_CONF=/etc/labean.conf
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y locales iptables busybox-syslogd dumb-init --no-install-recommends \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false -o APT::AutoRemove::SuggestsImportant=false
COPY --from=gobuilder /go/bin/labean /usr/sbin/labean
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 8080
CMD [ "/usr/local/bin/entrypoint.sh" ]

