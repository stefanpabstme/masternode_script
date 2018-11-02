#!/bin/bash
function installUsingFiles() {
  :
}

function installUsingRepo() {
  :
}

#updateCronjobs "@reboot $path"
function addCronjob() {
  cmd=$1
  crontab -l > allcronjobs
  echo "$cmd" >> allcronjobs
  crontab allcronjobs
  rm allcronjobs
  echo "Cronjob added"
}


clear
echo "This script will install some useful dependencies and"
read -p "the masternodes of your choice. You've to run this as root! [ENTER]"
echo ""

#Dependencies
apt-get install -y nano htop git realpath

echo ""
echo ""
read -r -p "Install smartcash? [y/N] " smart
echo ""
read -r -p "Install anonymousbitcoin? [y/N] " anon
echo ""
read -r -p "Install socialsend? [y/N] " send
echo ""
read -r -p "Install hempcoin? [y/N] " thc
echo ""
read -r -p "Install magnacoin? [y/N] " mgn
echo ""
read -r -p "Install syndicate? [y/N] " synx
echo ""
read -r -p "Install pure? [y/N] " pure
echo ""
read -r -p "Install digiwage? [y/N] " wage
echo ""
read -r -p "Install rupaya? [y/N] " rupx
echo ""
read -r -p "Install travelpay? [y/N] " trp
echo ""
read -r -p "Install veruscoin cpu miner? [y/N] " vrsc
echo ""
#read -r -p "Install komodo cpu miner? [y/N] " kmd
#echo ""
#read -r -p "Install monero cpu miner? [y/N] " xmr
echo ""
echo ""

if [ "$smart" = "y" ]; then
  label="Smartcash"
  read -p "Installing $label.. [ENTER]"
  echo ""
  cd
  wget https://rawgit.com/smartcash/smartnode/master/install.sh
  bash ./install.sh
  rm -f install.sh
fi

if [ "$anon" = "y" ]; then
  label="Anonymous Bitcoin"
  read -p "Installing $label.. [ENTER]"
  echo ""
  cd
  wget https://raw.githubusercontent.com/alttankcanada/ANONMasternodeScript/master/anon_mnsetup_install.sh
  bash ./anon_mnsetup_install.sh
  rm -f anon_mnsetup_install.sh
fi

if [ "$send" = "y" ]; then
  label="SocialSend"
  read -p "Installing $label.. [ENTER]"
  echo ""
  cd
  git clone https://github.com/SocialSend/easy_masternode.git
  cd easy_masternode
  bash ./mn_install.sh
  rm -f ./mn_install.sh
  rpath=`realpath sendd`
  addCronjob "@reboot $rpath"
fi

if [ "$thc" = "y" ]; then
  label="Hempcoin"
  read -p "Installing $label.. [ENTER]"
  echo ""
  cd
  wget https://raw.githubusercontent.com/hempcoin-project/mnscript/master/hempcoin_install.sh
  bash hempcoin_install.sh
  rm -f hempcoin_install.sh
  #rpath=`realpath hempcoind`
  #addCronjob "@reboot $rpath"
fi

if [ "$mgn" = "y" ]; then
  label="MagnaCoin"
  read -p "Installing $label.. [ENTER]"
  echo ""
  echo "Type the rpcuser that you want to use, followed by [ENTER]:"
  read rpcuser
  echo "Type the rpcpassword that you want to use, followed by [ENTER]:"
  read rpcpassword
  echo ""

  cd
  wget https://github.com/MagnaCoinProject/MagnaCoin/releases/download/v1.0.0/mgn-1.0.0-x86_64-linux-gnu.tar.gz
  tar -xzf mgn-1.0.0-x86_64-linux-gnu.tar.gz
  rm -f mgn-1.0.0-x86_64-linux-gnu.tar.gz

  #Creating the config
  mkdir .MagnaCoin/
  echo "rpcuser=$rpcuser" > ".MagnaCoin/mgn.conf"
  echo "rpcpassword=$rpcpassword" >> ".MagnaCoin/mgn.conf"
  ./mgn-1.0.0/bin/mgnd -daemon
  sleep 30
  str="masternodeprivkey="
  genkey=`./mgn-1.0.0/bin/mgn-cli masternode genkey`
  str="$str$genkey"
  ./mgn-1.0.0/bin/mgn-cli stop
  sleep 30
  echo "$coin stopped"
  echo "rpcallowip=127.0.0.1" >> ".MagnaCoin/mgn.conf"
  echo "listen=1" >> ".MagnaCoin/mgn.conf"
  echo "daemon=1" >> ".MagnaCoin/mgn.conf"
  echo "logtimestamps=1" >> ".MagnaCoin/mgn.conf"
  echo "maxconnections=256" >> ".MagnaCoin/mgn.conf"
  echo "masternode=1" >> ".MagnaCoin/mgn.conf"
  echo "$str" >> ".MagnaCoin/mgn.conf"
  echo "mgn.conf created"
  sleep 10

  #Start node after reboot
  rpath=`realpath ./mgn-1.0.0/bin/mgnd`
  addCronjob "@reboot $rpath"

  #comfigure firewall
  ufw allow 57821
  echo "Port added to firewall"
  echo ""

  #finish
  ./mgn-1.0.0/bin/mgnd -daemon
  sleep 30
  ./mgn-1.0.0/bin/mgn-cli getinfo
  echo ""
  echo "$coin installation completed"
  echo ""
  echo ""
  echo "$str"
  echo ""
  read -p "Copy this and create your masternode.conf file. [ENTER]"
  echo ""
  echo ""
fi

if [ "$synx" = "y" ]; then
  label="Syndicate"
  read -p "Installing $label.. [ENTER]"
  echo ""
  echo "Type the rpcuser that you want to use, followed by [ENTER]:"
  read rpcuser
  echo "Type the rpcpassword that you want to use, followed by [ENTER]:"
  read rpcpassword
  echo ""

  cd
  mkdir syndicate
  cd syndicate
  wget https://github.com/SyndicateLtd/SyndicateQT/releases/download/v2.0.0/Syndicate-2.0.0-x86_64-linux-gnu.zip
  unzip Syndicate-2.0.0-x86_64-linux-gnu.zip
  rm -f Syndicate-2.0.0-x86_64-linux-gnu.zip
  chmod +x syndicated syndicate-cli syndicate-tx
  cd

  #Creating the config
  mkdir .syndicate/
  echo "rpcuser=$rpcuser" > ".syndicate/syndicate.conf"
  echo "rpcpassword=$rpcpassword" >> ".syndicate/syndicate.conf"
  ./syndicate/syndicated -daemon
  sleep 30
  str="masternodeprivkey="
  genkey=`syndicate/syndicate-cli masternode genkey`
  str="$str$genkey"
  ./syndicate/syndicate-cli stop
  sleep 30
  echo "$coin stopped"
  echo "rpcallowip=127.0.0.1" >> ".syndicate/syndicate.conf"
  echo "listen=1" >> ".syndicate/syndicate.conf"
  echo "daemon=1" >> ".syndicate/syndicate.conf"
  echo "logtimestamps=1" >> ".syndicate/syndicate.conf"
  echo "maxconnections=256" >> ".syndicate/syndicate.conf"
  echo "masternode=1" >> ".syndicate/syndicate.conf"
  echo "$str" >> ".syndicate/syndicate.conf"
  echo "syndicate.conf created"
  sleep 10

  #Start node after reboot
  rpath=`realpath ./syndicate/syndicated`
  addCronjob "@reboot $rpath"

  #finish
  ./syndicate/syndicated -daemon
  sleep 30
  ./syndicate/syndicate-cli getinfo
  echo ""
  echo "$coin installation completed"
  echo ""
  echo ""
  echo "$str"
  echo ""
  read -p "Copy this and create your masternode.conf file. [ENTER]"
  echo ""
  echo ""
fi

if [ "$pure" = "y" ]; then
  label="PURE"
  read -p "Installing $label.. [ENTER]"
  echo ""
  echo "Type the rpcuser that you want to use, followed by [ENTER]:"
  read rpcuser
  echo "Type the rpcpassword that you want to use, followed by [ENTER]:"
  read rpcpassword
  echo ""

  cd
  mkdir pure
  cd pure
  wget wget https://github.com/puredev321/pure-v2/releases/download/v2.0.0.0/pure-v2-v2.0.0.0-linux64.tar.gz
  tar -xzf pure-v2-v2.0.0.0-linux64.tar.gz
  rm -f mgn-1.0.0-x86_64-linux-gnu.tar.gz
  cd

  #Creating the config
  mkdir .MagnaCoin/
  echo "rpcuser=$rpcuser" > ".pure-n/pure.conf"
  echo "rpcpassword=$rpcpassword" >> ".pure-n/pure.conf"
  ./pure/bin/pured -daemon
  sleep 30
  str="masternodeprivkey="
  genkey=`./pure/bin/pure-cli masternode genkey`
  str="$str$genkey"
  ./pure/bin/pure-cli stop
  sleep 30
  echo "$coin stopped"
  echo "rpcallowip=127.0.0.1" >> ".pure-n/pure.conf"
  echo "listen=1" >> ".pure-n/pure.conf"
  echo "daemon=1" >> ".pure-n/pure.conf"
  echo "logtimestamps=1" >> ".pure-n/pure.conf"
  echo "maxconnections=256" >> ".pure-n/pure.conf"
  echo "masternode=1" >> ".pure-n/pure.conf"
  echo "$str" >> ".pure-n/pure.conf"
  echo "pure.conf created"
  sleep 10

  #Start node after reboot
  rpath=`realpath ./pure/bin/pured`
  addCronjob "@reboot $rpath"

  #finish
  ./pure/bin/pured -daemon
  sleep 30
  ./pure/bin/pure-cli getinfo
  echo ""
  echo "$coin installation completed"
  echo ""
  echo ""
  echo "$str"
  echo ""
  read -p "Copy this and create your masternode.conf file. [ENTER]"
  echo ""
  echo ""
fi

if [ "$wage" = "y" ]; then
  label="Digiwage"
  read -p "Installing $label.. [ENTER]"
  echo ""
  wget https://raw.githubusercontent.com/digiwage/digiwage_install/master/digiwage_install.sh
  bash digiwage_install.sh
  rm -f digiwage_install.sh
  rpath=`realpath digiwaged`
  addCronjob "@reboot $rpath"
fi

if [ "$rupx" = "y" ]; then
  label="Rupaya"
  read -p "Installing $label.. [ENTER]"
  echo ""
  wget -q https://raw.githubusercontent.com/rupaya-project/mnscript/master/rupaya_install.sh
  bash rupaya_install.sh
  rm -f rupaya_install.sh
  #rpath=`realpath digiwaged`
  #addCronjob "@reboot $rpath"
fi

if [ "$trp" = "y" ]; then
  echo "Sry.. Installing travelpay.. Damn scam.. Doesn't work atm..."
fi

if [ "$vrsc" = "y" ]; then
  label="ccminer to mine veruscoin vrsc on cpu via veruspool.xyz"
  read -p "Installing $label.. [ENTER]"
  echo ""
  echo "Submit the veruscoin address that you want to mine to, followed by [ENTER]:"
  read address
  echo "If wanted, type in a workerid, followed by [ENTER]:"
  read workerid
  read -r -p "Should the miner start after reboot? [y/N]" reboot
  read -r -p "How many threads? Leave blank to use default value" threads
  address="$address.$workerid"
  procs=$(nproc)
  echo $procs
  if [ "$threads" = "" ]; then
    threads=$((procs-1))
  fi
  echo "CPU Threads: $threads"
  if [ "$threads" = "0" ]; then
    threads=1
  fi
  echo ""
  sudo apt update
  sudo apt -y upgrade
  sudo apt -y install git libcurl4-openssl-dev libssl-dev libjansson-dev automake autotools-dev build-essential
  git clone -b cpuonlyverus https://github.com/monkins1010/ccminer ccminer-veruscoin
  cd ccminer-veruscoin
  ./build.sh
  rpath=`realpath ./ccminer`
  clear
  if [ "$reboot" = "y" ]; then
    #Start miner after reboot
    cmd="$rpath -a verus -o stratum+tcp://stratum.veruspool.xyz:9999 -u $address -t $threads -B"
    crontab -l > allcronjobs
    echo "@reboot $cmd" >> allcronjobs
    crontab allcronjobs
    rm allcronjobs
    echo "$label added to cronjobs"
  fi
  echo ""
  echo "Start miner manually with the command:"
  read -p "$rpath -a verus -o stratum+tcp://stratum.veruspool.xyz:9999 -u $address -t $threads"
fi
