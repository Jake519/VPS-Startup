#!/bin/sh
echo "Starting setup for WebServer"
echo "For: Debian Linux"

# Add backports to sources.list
sudo apt update
sudo apt -y upgrade

sudo sh -c "echo 'deb http://archive.debian.org/debian buster-backports main contrib non-free' > /etc/apt/sources.list.d/buster-backports.list"
sudo apt update

# Install WireGuard
sudo apt -y install wireguard

# Inatall Git
sudo apt -y install git

# Install UFW
sudo apt -y install ufw

# Install MariaDB
sudo apt -y install mariadb-server

# Create WebServer Directory
sudo mkdir /WebServer

# Set up UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow ssh
sudo ufw allow 22
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 51194/udp

echo "y" | sudo ufw enable

# Set up WireGuard
sudo -i
cd /etc/wireguard

umask 077; wg genkey | tee privatekey | wg pubkey > publickey
PRIVATE_KEY=$(sudo cat /etc/wireguard/privatekey)
printf "## Set Up WireGuard VPN on Debian By Editing/Creating wg0.conf File ##\n[Interface]\n## My VPN server private IP address ##\nAddress = 192.168.10.1/24\n\n## My VPN server port ##\nListenPort = 51194\n\n## VPN server's private key i.e. /etc/wireguard/privatekey ##\nPrivateKey = $PRIVATE_KEY\n\n## Save and update this config file when a new peer (vpn client) added ##\nSaveConfig = true\n" >> /etc/wireguard/wg0.conf

sudo systemctl enable wg-quick@wg0
sudo systemctl start wg-quick@wg0


