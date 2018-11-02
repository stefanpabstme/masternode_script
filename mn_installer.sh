#!/bin/bash 
clear
read -p "This script will install some useful dependencies and the masternodes of your choice. You've to run this as root! [ENTER]"


apt-get install nano htop git 


read -r -p "Install smartcash? [y/n] " smart
read -r -p "Install anonymousbitcoin? [y/n] " anon
read -r -p "Install socialsend? [y/n] " send
read -r -p "Install hempcoin? [y/n] " thc
read -r -p "Install magnacoin? [y/n] " mgn
read -r -p "Install pure? [y/n] " pure
read -r -p "Install digiwage? [y/n] " wage
read -r -p "Install rupaya? [y/n] " rupx
read -r -p "Install syndicate? [y/n] " synx
read -r -p "Install travelpay? [y/n] " trp
#read -r -p "Install veruscoin cpu miner? [y/n] " vrsc
#read -r -p "Install komodo cpu miner? [y/n] " kmd
#read -r -p "Install monero miner? [y/n] " vrsc


if [ "$smart" = "y" ]; then
  coin="Smartcash"
  read -p "Installing $coin.."
  cd
  wget https://rawgit.com/smartcash/smartnode/master/install.sh
  bash ./install.sh
  rm -f install.sh
fi

if [ "$anon" = "y" ]; then
  coin="Anonymous Bitcoin"
  read -p "Installing $coin.."
  cd
  wget https://raw.githubusercontent.com/alttankcanada/ANONMasternodeScript/master/anon_mnsetup_install.sh
  bash ./anon_mnsetup_install.sh
  rm -f anon_mnsetup_install.sh
fi

if [ "$send" = "y" ]; then
  coin="SocialSend"
  read -p "Installing $coin.."
  cd
  git clone https://github.com/SocialSend/easy_masternode.git
  cd easy_masternode
  bash ./mn_install.sh
  rm -f ./mn_install.sh
fi

if [ "$thc" = "y" ]; then
  coin="Hempcoin"
  read -p "Installing $coin.."
  cd
  wget https://raw.githubusercontent.com/hempcoin-project/mnscript/master/hempcoin_install.sh
  bash hempcoin_install.sh
  rm -f hempcoin_install.sh
fi

if [ "$mgn" = "y" ]; then
  coin="MagnaCoin"
  read -p "Installing $coin.."
  cd
  wget https://github.com/MagnaCoinProject/MagnaCoin/releases/download/v1.0.0/mgn-1.0.0-x86_64-linux-gnu.tar.gz
  tar -xzf mgn-1.0.0-x86_64-linux-gnu.tar.gz
  mkdir .MagnaCoin/
  echo "rpcuser=mgnrpc" > ".MagnaCoin/mgn.conf"
  echo "rpcpassword=2wvcWw7pw47gmP9XNTraKtoysCQbLCWDEKBvwPyupGxq" >> ".MagnaCoin/mgn.conf"
  ./mgn-1.0.0/bin/mgnd -daemon
  str="masternodeprivkey="
  genkey=`mgn-cli masternode genkey`
  str="$str$genkey"
  echo "rpcallowip=127.0.0.1" >> ".MagnaCoin/mgn.conf"
  echo "listen=1" >> ".MagnaCoin/mgn.conf"
  echo "daemon=1" >> ".MagnaCoin/mgn.conf"
  echo "logtimestamps=1" >> ".MagnaCoin/mgn.conf"
  echo "maxconnections=256" >> ".MagnaCoin/mgn.conf"
  echo "masternode=1" >> ".MagnaCoin/mgn.conf"
  echo "$str" >> ".MagnaCoin/mgn.conf"
  ./mgn-1.0.0/bin/mgnd -daemon
  
  
  
fi

if [ "$synx" = "y" ]; then
  coin="Syndicate"
  read -p "Installing $coin.."
  https://github.com/SyndicateLtd/SyndicateQT/releases/download/v2.0.0/Syndicate-2.0.0-aarch64-linux-gnu.tar
  
fi

if [ "$pure" = "y" ]; then
  coin="PURE"
  echo "Installing $coin.."
  wget https://github.com/puredev321/pure-v2/releases/download/v2.0.0.0/pure-v2-v2.0.0.0-linux64.tar.gz
  
fi

if [ "$wage" = "y" ]; then
  coin="Digiwage"
  echo "Installing $coin.."
  wget https://raw.githubusercontent.com/digiwage/digiwage_install/master/digiwage_install.sh
  bash digiwage_install.sh
  rm -f digiwage_install.sh
fi

if [ "$rupx" = "y" ]; then
  coin="Rupaya"
  read -p "Installing $coin.."
  wget -q https://raw.githubusercontent.com/rupaya-project/mnscript/master/rupaya_install.sh
  bash rupaya_install.sh
  rm -f rupaya_install.sh
fi

if [ "$trp" = "y" ]; then
  echo "Sry.. Installing travelpay.. Damn scam.. Doesn't work atm..."
fi
