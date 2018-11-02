#!/bin/bash 
echo "This script will install some masternodes..."


read -r -p "Install smartcash? [y/n] " smart
read -r -p "Install anonymousbitcoin? [y/n] " anon
read -r -p "Install magnacoin? [y/n] " mgn
read -r -p "Install socialsend? [y/n] " send
read -r -p "Install hempcoin? [y/n] " thc
read -r -p "Install travelpay? [y/n] " trp
read -r -p "Install syndicate? [y/n] " synx
read -r -p "Install pure? [y/n] " pure
read -r -p "Install digiwage? [y/n] " wage


if [ "$smart" = "y" ]; then
  wget https://rawgit.com/smartcash/smartnode/master/install.sh
  bash ./install.sh
fi

if [ "$anon" = "y" ]; then
  wget https://raw.githubusercontent.com/alttankcanada/ANONMasternodeScript/master/anon_mnsetup_install.sh
  bash ./anon_mnsetup_install.sh
fi
