# Step by Step guide 
This guide is based on Ubuntu 18.04.5 LTS droplet.

## Base image
```shell
root@ubuntu:~# cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.5 LTS"
```
### Prerequisites
Enabling ports:
```shell
root@ubuntu:~# ufw status
Status: inactive
root@ubuntu:~# ufw allow 80/tcp
root@ubuntu:~# ufw allow 443/tcp
root@ubuntu:~# ufw allow 22/tcp

root@ubuntu:~# ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
```
Checking firewall status.
```shell
root@ubuntu:~# ufw status
Status: active

To                         Action      From
--                         ------      ----
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere
22/tcp                     ALLOW       Anywhere
80/tcp (v6)                ALLOW       Anywhere (v6)
443/tcp (v6)               ALLOW       Anywhere (v6)
22/tcp (v6)                ALLOW       Anywhere (v6)
```
Installing docker using [official](https://docs.docker.com/engine/install/ubuntu/) guide:
```shell
root@ubuntu:~# apt-get remove docker docker-engine docker.io containerd runc
Reading package lists... Done
Building dependency tree
Reading state information... Done

No apt package "docker", but there is a snap with that name.
Try "snap install docker"

E: Unable to locate package docker
E: Unable to locate package docker-engine
E: Unable to locate package docker.io
E: Couldn't find any package by glob 'docker.io'
E: Couldn't find any package by regex 'docker.io'
E: Unable to locate package containerd
E: Unable to locate package runc
```
Installing from repository:
```shell
root@ubuntu:~#  apt-get update && apt-get install -y apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
Adding repository key:
```shell
root@ubuntu:~#  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
And repository:
```shell
root@ubuntu:~#  add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
And finally installing docker:
```shell
root@ubuntu:~# apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io
```
Checking that docker engine is up and running:
```shell
root@ubuntu:~# docker run --rm hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
0e03bdcc26d7: Pull complete
Digest: sha256:7f0a9f93b4aa3022c3a4c147a449bf11e0941a1fd0bf4a8e6c9408b2600777c5
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID: im
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
Installing docker-compose as per [instruction](https://docs.docker.com/compose/install/)
```shell
root@ubuntu:~# sudo curl -L --fail https://github.com/docker/compose/releases/download/1.26.2/run.sh -o /usr/local/bin/docker-compose
root@ubuntu:~# sudo chmod +x /usr/local/bin/docker-compose
```

## Freesby installation
Once docker is installed, freesby installation can be started:
```shell 
root@ubuntu:~# git clone --depth=1 https://github.com/padlik/freesby.git
Cloning into 'freesby'...
remote: Enumerating objects: 38, done.
remote: Counting objects: 100% (38/38), done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 38 (delta 3), reused 16 (delta 1), pack-reused 0
Unpacking objects: 100% (38/38), done
```
__It is very important to set proper hostname and DNS records before generating certificates.__ 

Setting site __hostname__:
```shell
root@ubuntu:~# cd freesby && nano shared.env
```
In addition __index.html__ stub can be replaced with some dummy web site content in ```nginx\html``` folder

## Running freesby 
Staring Freesby:
```shell
root@ubuntu:~# ./start_vpn 
```
Please allow several minutes for images for build. 
