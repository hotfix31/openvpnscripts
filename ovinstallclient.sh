#!/bin/bash
#
# Script d'installation d'un nouveau client
#
# Frédéric Le Barzic- 08/2012
# GPL
#
# Syntaxe: # ./ovinstallclient.sh <clienname>
VERSION="0.1"
SERVER="94.23.10.52"

# Test que le script est lance en root
if [ $EUID -ne 0 ]; then
  echo "Le script doit être lancé en root: # sudo $0 <nomduclient>" 1>&2
  exit 1
fi

# Test parametre
if [ $# -ne 1 ]; then
  echo "Il faut saisir le nom du client: # sudo $0 <nomduclient>" 1>&2
  exit 1
fi

echo "---"
echo "Installation de OpenVpn"
yum -y install openvpn

echo "---"
echo "Installation de OpenVpn"
sftp root@${SERVER}:/etc/openvpn/clientconf/$1/$1.zip /etc/openvpn
unzip /etc/openvpn/$1.zip

echo "---"
echo "Lancemlent de OpenVpn"
/etc/init.d/openvpn start
sleep 3

echo "---"
echo "Test de la connexion"
ping -q -c5 10.8.0.1 > /dev/null
if [ $? -eq 0 ]; then
   echo "Le serveur VPN ping correctement"
   exit 0
fi

echo "Erreur le serveur VPN est injoiniable"
exit 1
