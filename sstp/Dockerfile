FROM debian:buster

ENV VERSION v4.34-9745-rtm-2020.04.05
ENV USER_LIST=/usr/local/vpnserver/users.txt

WORKDIR /usr/local/vpnserver

RUN apt-get update && \
    apt-get -y install wget gcc make

RUN wget http://jp.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-${VERSION}-linux-x64-64bit.tar.gz -O /tmp/softether-vpnserver.tar.gz && \
  tar xvf /tmp/softether-vpnserver.tar.gz -C /usr/local/ && \
  rm /tmp/softether-vpnserver.tar.gz && \
  make i_read_and_agree_the_license_agreement && \
  apt-get purge -y -q --auto-remove gcc make wget

ENV SERVERPASS FreeProxy4All
ENV HUBNAME basehub
ENV HUBPASS pass4hub


ADD entrypoint.sh /usr/local/bin/entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
