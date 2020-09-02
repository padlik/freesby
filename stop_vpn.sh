#!/bin/bash

echo "Stopping VPN services"
docker-compose down
docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
docker volume prune -f 2>/dev/null
exit 0
