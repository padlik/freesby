# SSL VPN servers for docker-compose 
SSL-based VPN servers: [ocserv](https://ocserv.gitlab.io/www/index.html) and [softether](https://www.softether.org/) combined into composer package. Ready-to-use solution for quick VPN setup using DigitalOcean droplet or any other hosted environment.

Unlike any other VPNs, SSL-based VPN can mask their traffic to ordinary HTTPS(TLS) communication and thus pass DPI firewalls.

In addition, HTTPS port knocking allows to hide VPN endpoints under any ordinary web site, which can prevent blocking of VPN endpoint by checking endpoint content first and blocking it in case if site is not "real".   

## Usage

Setup "freesby" using any hosting provider abroad. Visit special URL (e.g. https://[sitename]/freesby/vpn) to "unlock" VPN endpoint for 30 seconds. Start your VPN client (SSTP or AnyConnect). Once 30 seconds passed, VPN connection will remain active, but VPN endpoint will be "hidden" exposing the ordinary web site to the web.     

VPN connection traffic will look the same as an ordinary TLS communication and any additional web site checks will show nothing, but a web page(s). 

Additional setup can be made for any other services like SSH, to hide it from being discovered.  

## Setup

This example is based on Ubuntu 16.04 and DigitalOcean droplet but can be extended to any other setup.

### Prerequisites 
- Shell root access
- Ports 22 (optional), 443 and 80 should be enabled by a firewall
- iptables and git are installed 
- docker and docker-compose are available
- DNS name registered for the installation public IP (recommended)  

DigitalOcean droplets are usually equipped with the shell access enabled using key-based or password-based logins so nothing should be done in that matter. 

UFW (and iptables) can be installed using APT. Please allow ports required using
```shell
$ sudo ufw allow 22/tcp
$ sudo ufw allow 443/tcp
$ sudo ufw allow 80/tcp
```
Please note, that no UDP ports are required to be opened (UDP traffic is typically blocked first to prevent VPN access). 

Docker and docker-compose can be installed either by choosing droplets with docker pre-installed either following the instructions for [docker](https://docs.docker.com/engine/install/ubuntu/) and [docker-composer](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-16-04).

Primary or additional DNS name for the installation can be registered with any free DDNS provider (dynu, noip and etc). 

### Preparing   
Clone github repository:
```shell
~ $ git clone --depth=1 https://github.com/padlik/freesby.git
```

Edit __shared.env__ file and replace variables:
Variable  | Value | Note 
------------- | ------------- | ------------ |
NGINX_HOST  | [installation dns hostname] | required
FREESBY_PREFIX  | freesby | prefix for knocking service
CERT_TYPE  | letsencrypt |  "selfsigned" to generate self-signed certificate (not recommended, optional)


### Certificates generation
Certificates can be either obtained from Letsencrypt service (recommended) or self-generated.
```shell
~$ cd freesby
~/freesby $ sudo ./certgen.sh
```
Please note that in case of self-signed certificate option script will generates new certificate even script run. For Letsencrypt certificates script will NOT re-generate certificates if they are not expired.

### VPN Accounts
VPN services will use own set of accounts different from the system ones. Default accounts and passwords can be found in __users.txt__ file. At least one account should be preset in this file for normal operations.    

### Running VPN services
Once certificates are obtained (or generated) and VPN accounts are available, VPN services can be started:

```shell
$ sudo ./start_vpn.sh
```
Please note that first start might take some time to build docker images. Depending on connection speed it will take up to 10 minutes. 

To stop VPN services simply run:
```shell
$ sudo ./stop_vpn.sh
```
All Letsencrypt certificates will remain in place and won't be removed. 

## Connecting clients
As soon as solution provides two types of VPN services it can be connected from any device supporting SSTP or "Cisco Any Connect" protocols. Please refer summary table below:
OS System  | Open Connect | SSTP 
------------- | ------------- | ------------ |
Linux  | yes | yes
Windows  | yes | yes (build in)
macOS  | yes |  yes 
iOS | yes | no 
Android| yes | yes

### MacOS
#### Openconnect:
__Installation__
```shell
$ brew install openconnect 
```
and optional GUI client
```shell
$ brew install openconnect_gui
```
__Connection__:
1. Visit [https://"vpnsite"/freesby/vpn]() to enable Openconnect VPN endpoint for 30 seconds.
2. From terminal run:
```shell
sudo openconnect -u [user_name_from_users.txt] --pfs "vpnsite"
```
#### SSTP:
__Installation__
```shell
$ brew install sstp-client
```
__Connection__:
1. Visit [https://"vpnsite"/freesby/sstp]() to enable SSTP VPN endpoint for 30 seconds.
2. From terminal run:

```shell
$ sudo /usr/local/sbin/sstpc  --log-stderr --cert-warn --user [usernsame]  --password [password] [vpnhostname] usepeerdns require-mschap-v2 noauth noipdefault defaultroute refuse-eap noccp
```




