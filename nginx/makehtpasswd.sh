#!/bin/bash
set -e

touch ${PASSWD_FILE}
echo > ${PASSWD_FILE}

if [ -r ${USERS_FILE} ]; then
        while read username userpass 
	do
                echo "Adding user ${username}"
                htpasswd -b ${PASSWD_FILE} ${username} ${userpass}
               
        done < ${USERS_FILE}
fi
