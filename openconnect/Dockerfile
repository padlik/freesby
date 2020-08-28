FROM debian:buster

ENV USERS_FILE=/etc/ocserv/users.txt
ENV DEBIAN_FRONTEND noninteractive


#allow to work from console normally
RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8 \
    && apt-get update && apt-get install -y ocserv gettext-base iptables procps \
    && update-alternatives --set iptables /usr/sbin/iptables-legacy \
    && update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=f:alse -o APT::AutoRemove::SuggestsImportant=false
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

COPY docker-entrypoint.sh /entrypoint.sh
COPY ocserv.conf.template /etc/ocserv/ocserv.conf.template

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 443
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
