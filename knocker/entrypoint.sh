#!/bin/bash

bash -c "syslogd"
bash -c "labean ${LABEAN_CONF} &"
tail -f /var/log/messages
