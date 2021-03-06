#!/bin/bash
#
# Script de creation d'un nouveau client sur un serveur OpenVPN
# http://blog.nicolargo.com/2010/10/installation-dun-serveur-openvpn-sous-debianubuntu.html
#
# Nicolargo - 10/2010
# Frederic Le Barzic - 08/2012
# GPL
#
# Syntaxe: # ./ovcreateclient.sh <nomduclient>
VERSION="0.1b"

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit etre lance en root: # $0 <nomduclient>" 1>&2
  exit 1
fi

# Test parametre	
if [ $# -ne 1 ]; then
  echo "Il faut saisir le nom du client: # $0 <nomduclient>" 1>&2
  exit 1
fi

echo "---"
echo "Creation du client OpenVPN: $1"

cd /etc/openvpn/easy-rsa
source vars
./build-key $1
sudo mkdir /etc/openvpn/clientconf/$1
sudo cp /etc/openvpn/keys/ca.crt /etc/openvpn/keys/ta.key keys/$1.crt keys/$1.key /etc/openvpn/clientconf/$1/

cd /etc/openvpn/clientconf/$1
cat >> $1.conf << EOF
# Client
client
dev tun
proto tcp-client
remote 00.00.00.00 443
resolv-retry infinite
cipher AES-256-CBC

# Cles
ca ca.crt
cert $1.crt
key $1.key
tls-auth ta.key 1

# Securite
nobind
persist-key
persist-tun
comp-lzo
verb 3
EOF
sudo cp $1.conf $1.ovpn

sudo zip $1.zip *.*

echo "Creation du client OpenVPN $1 termine"
echo "/etc/openvpn/clientconf/$1/$1.zip" 
echo "---"
