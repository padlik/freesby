#!/bin/bash
set -e

touch ${PASSWD_FILE}

if [ -r ${USERS_LIST} ] then
        for read username userpass do
                echo "Adding user ${username}"
                htpasswd -b ${PASSWD_FILE} ${username} ${userpass}
               
        done < ${USERS_LIST}
fi
