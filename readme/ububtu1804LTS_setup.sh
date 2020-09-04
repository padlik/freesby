#!/bin/bash

echo "About to check and install packages required"
sudo apt-get update
sudo ufw --version || sudo apt install ufw
sudo iptables --version || sudo apt install iptables
sudo git --version || sudo apt install git
sudo apt-get install -y apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
     "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
docker run --rm hello-world
sudo curl -L --fail https://github.com/docker/compose/releases/download/1.26.2/run.sh -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
git clone --depth=1 https://github.com/padlik/freesby.git
echo "=================================================="
echo "Freesby is installed in $(pwd)/freesby"
echo "PLEASE REGISTER HOSTNAME YOUR INSTALLATION" 
echo "AND EDIT $(pwd)/freesby/shared.env PRIOR TO START"
echo "All done"

