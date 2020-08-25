#!/bin/bash

touch /var/log/messages
bash -c "syslogd"
bash -c "labean ${LABEAN_CONF} &"
tail -f /var/log/messages
