#!/bin/bash
set -e

stop_ok() {
	echo "Gracefully stopping"
	/usr/local/vpnserver/vpnserver stop
	exit 0
}

/usr/local/vpnserver/vpnserver start && sleep 3s
/usr/local/vpnserver/vpnserver stop && sleep 3s
#disable DOS protection which is useless
sed -i 's/\(\s*bool\s*DisableDos\s\).*$/\1true/' /usr/local/vpnserver/vpn_server.config
sed -i 's/\(\s*bool\s*DisableDosProction\s\).*$/\1true/' /usr/local/vpnserver/vpn_server.config
/usr/local/vpnserver/vpnserver start && sleep 3s


#importing cetrificated if exists
if [ -r /etc/letsencrypt/live/${NGINX_HOST}/cert.pem ]; then
	openssl x509 -outform der -in /etc/letsencrypt/live/${NGINX_HOST}/fullchain.pem -out /usr/local/vpnserver/server_cert.crt
	cp /etc/letsencrypt/live/${NGINX_HOST}/privkey.pem /usr/local/vpnserver/server_key.pem
	/usr/local/vpnserver/vpncmd /SERVER localhost /CMD ServerCertSet /LOADCERT:/usr/local/vpnserver/server_cert.crt /LOADKEY:/usr/local/vpnserver/server_key.pem
fi


/usr/local/vpnserver/vpncmd /SERVER localhost /CMD HubCreate $HUBNAME /PASSWORD:$HUBPASS

if [ -r ${USERS_LIST} ]; then
	while read username userpass 
	do
		echo "Adding user ${username}"
		/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD UserCreate $username /GROUP:none /REALNAME:none /NOTE:none
		/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD UserPasswordSet $username /PASSWORD:$userpass
	done < ${USERS_LIST}
fi


/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD SecureNatEnable
/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD ExtOptionSet DisableIpRawModeSecureNAT /VALUE:true
/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD ExtOptionSet DisableKernelModeSecureNAT /VALUE:true
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD IPsecEnable /L2TP:no /L2TPRAW:no /ETHERIP:no /PSK:DUMMYPSK /DEFAULTHUB:$HUBNAME
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD OpenVpnEnable no /PORTS:1194
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD ServerPasswordSet $SERVERPASS

while [ "$END" == '' ]; do
	sleep 1
	trap "stop_ok" INT TERM
done

