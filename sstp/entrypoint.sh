#!/bin/bash
set -e

stop_ok() {
	echo "Gracefully stopping"
	/usr/local/vpnserver/vpnserver stop
	exit 0
}

/usr/local/vpnserver/vpnserver start

sleep 3s

/usr/local/vpnserver/vpncmd /SERVER localhost /CMD HubCreate $HUBNAME /PASSWORD:$HUBPASS

if [ -r ${USERS_LIST} ] then
	for read username userpass do
		echo "Adding user ${username}"
		/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD UserCreate $username /GROUP:none /REALNAME:none /NOTE:none
		/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD UserPasswordSet $username /PASSWORD:$userpass
	done < ${USERS_LIST}
fi


/usr/local/vpnserver/vpncmd /SERVER localhost /HUB:$HUBNAME /PASSWORD:$HUBPASS /CMD SecureNatEnable
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD IPsecEnable /L2TP:no /L2TPRAW:no /ETHERIP:no /PSK:DUMMYPSK /DEFAULTHUB:$HUBNAME
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD OpenVpnEnable no /PORTS:1194
/usr/local/vpnserver/vpncmd /SERVER localhost /CMD ServerPasswordSet $SERVERPASS

while [ "$END" == '' ]; do
	sleep 1
	trap "stop_ok" INT TERM
done

