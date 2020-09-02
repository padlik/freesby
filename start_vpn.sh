#!/bin/bash

echo "Starting vpn services"
echo "Checking certificates..."
./certgen.sh && docker-compose up -d 



