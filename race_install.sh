#/bin/bash

export TERM=xterm

RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
BLUE='\033[34m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
NONE='\033[00m'
UNDERLINE='\033[4m'
MAX=11

#variables
COINNAME=RACECRYPTO
COINSHORT=RACE
COINSHORT_LOWER=race
COINTAR_LINK=https://github.com/racecrypto/racecoin/releases/download/v0.12.2.3/racecore-0.12.2-linux64.tar.bz2
COINTAR=`basename $COINTAR_LINK`
COINGITHUB=https://github.com/racecrypto/racecoin
COINGITHUB_LOCAL=racecoin
SENTINELGITHUB=https://github.com/racecrypto/sentinel
COINPORT=8800
COINRPCPORT=8801
COINDAEMON=raced
COINCLI=race-cli
COINTX=race-tx
COINCORE=.racecore
COINCONFIG=race.conf

# ip
IP=`LANG=C ifconfig | grep "inet " | grep -v "127\.[0-9]\+\.[0-9]\+\.[0-9]\+" | sed 's/^[ \t]*//;s/[ \t]*$//' | cut -d" " -f2 | cut -d":" -f2 | head -n1`

# check ubuntu
checkForUbuntuVersion() {

	echo -e "${YELLOW}*** [STEP 1/${MAX}] *** Checking your OS (Ubuntu 16.04.xx) ...${NONE}"

	if [[ `cat /etc/issue.net`  == *16.04* ]]
	then
        echo -e "${GREEN}* Your version is `cat /etc/issue.net` ... OK! ${NONE} \n"
    else
        echo -e "${RED}* Your version ... `cat /etc/issue.net` ... necessary version Ubuntu 16.04.xx ... NOT OK!"
        echo -e "Installation will stop ... please use Ubuntu 16.04.xx or compile a version for yourselve from github!${NONE}\n"
        exit 1
    fi
}

# vps update
updateAndUpgrade() {

    echo -e "${YELLOW}*** [STEP 2/${MAX}] *** Updating and upgrading your system. This can take a while ... please be patient and wait ...\n${NONE}"
    sudo apt-get update -y && sudo apt-get upgrade -y > /dev/null 2>&1
    echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# swap
setupSwap() {
	echo -e "${YELLOW}*** [STEP 3/${MAX}] *** Swapfile ... It is recommended to have 2GB RAM or RAM + Swapfile (minimum 2GB)!"
	echo -e "${CYAN}*** Current:\n `swapon -s`\n${NONE}"

	echo -e "${YELLOW}Please select size of swapfile\n(2)  2GB\t(4)  4GB\tor\t(n)  NO swapfile?${NONE}"
    read add_swap

	case $add_swap in
		2|4) 	sudo fallocate -l ${add_swap}G /swapfile
				sudo chmod 600 /swapfile
				sudo mkswap /swapfile
				sudo swapon /swapfile
				echo "/swapfile none swap sw 0 0" >> /etc/fstab
				;;
		*)		echo -e "No swap created\n"
    esac
	echo -e "${GREEN}* ... OK, done. ${NONE} \n"
	sleep 5
}

# requirements
installRequirements() {

    echo -e "${YELLOW}*** [STEP 4/${MAX}] *** Install requirements. This can take a while ... please be patient and wait ...${NONE}"

	sudo apt-get install git wget rpl htop -y > /dev/null 2>&1

	sudo apt-get install build-essential libtool autotools-dev automake autoconf libgmp3-dev pkg-config libssl-dev libevent-dev bsdmainutils software-properties-common -y > /dev/null 2>&1
	sudo apt-get install libboost-all-dev -y > /dev/null 2>&1

	sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
	sudo apt-get update -y && sudo apt-get upgrade -y > /dev/null 2>&1
	sudo apt-get install libdb4.8-dev libdb4.8++-dev -y > /dev/null 2>&1
	sudo apt-get install libminiupnpc-dev -y > /dev/null 2>&1

	sudo apt-get install libzmq3-dev libminiupnpc-dev libssl-dev libevent-dev -y > /dev/null 2>&1

	sudo apt-get install python-virtualenv virtualenv -y > /dev/null 2>&1

	echo -e "${GREEN}* ... OK, done. ${NONE} \n"

}

# download
downloadWallet() {
	echo -e "${YELLOW}*** [STEP 5/${MAX}] *** Downloading and unpacking wallet. This can take a while ... please be patient and wait ...\n${NONE}"

	# temporäres Verzeichnis (anlegen, bereinigen, wechsel dortin)
	mkdir -p $HOMEDIR/$COINGITHUB_LOCAL/src
	rm -rf $HOMEDIR/$COINGITHUB_LOCAL/src/*
	cd $HOMEDIR/$COINGITHUB_LOCAL/src

	# Download & Entpacken
	wget $COINTAR_LINK
	tar -xvf $COINTAR > /dev/null

	echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# install
installWallet() {

	echo -e "${YELLOW}*** [STEP 6/${MAX}] *** Installing wallet ...\n${NONE}"

	mkdir $HOMEDIR/$COINCORE

	cd $HOMEDIR/$COINGITHUB_LOCAL/src

	daemon=`find . -name $COINDAEMON`
	cd `dirname $daemon`

	sudo strip $COINDAEMON
    sudo strip $COINCLI
    sudo strip $COINTX

	sudo mv $COINDAEMON $HOMEDIR/$COINCORE
    sudo mv $COINCLI $HOMEDIR/$COINCORE
    sudo mv $COINTX $HOMEDIR/$COINCORE

	chmod u+x $HOMEDIR/$COINCORE/$COINSHORT_LOWER[d-]*

	echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# configure
configureWallet() {

	echo -e "${YELLOW}*** [STEP 7/${MAX}] *** Configure wallet ... This can take a while ... please be patient\n${NONE}"

	$HOMEDIR/$COINCORE/$COINCLI stop > /dev/null 2>&1
	sleep 10

	rpcuser=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`
    rpcpass=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1`

	echo -e "rpcuser=${rpcuser}\nrpcpassword=${rpcpass}\nrpcport=${COINRPCPORT}\nrpcconnect=127.0.0.1\nlisten=1\nserver=1\ndaemon=1" > $HOMEDIR/$COINCORE/$COINCONFIG

	$HOMEDIR/$COINCORE/$COINDAEMON -daemon > /dev/null 2>&1
    sleep 10

    mnkey=""

    while [ ${#mnkey} != 51 ]
    do
		mnkey=$($HOMEDIR/$COINCORE/$COINCLI masternode genkey)
		sleep 5
    done

    $HOMEDIR/$COINCORE/$COINCLI stop > /dev/null 2>&1
    sleep 20

    echo -e "masternode=1\nmasternodeaddr=${IP}:${COINPORT}\nmasternodeprivkey=${mnkey}\n" >> $HOMEDIR/$COINCORE/$COINCONFIG
#	echo -e "addnode=18.219.145.208:8800\naddnode=209.250.227.254:8800\naddnode=54.37.104.87:8800\naddnode=54.37.217.93:8800\naddnode=45.77.227.167:8800" >> $HOMEDIR/$COINCORE/$COINCONFIG

	crontab -l > ~/tempcron

	if ! grep -q "@reboot $HOMEDIR/$COINCORE/$COINDAEMON -daemon" $HOMEDIR/tempcron
	then
		echo "@reboot $HOMEDIR/$COINCORE/$COINDAEMON -daemon" >> $HOMEDIR/tempcron
	fi

	crontab $HOMEDIR/tempcron

	echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# sentinel
installSentinel() {

	echo -e "${YELLOW}*** [STEP 8/${MAX}] *** Install sentinel ...\n${NONE}"

    cd $HOMEDIR/$COINCORE
    git clone $SENTINELGITHUB sentinel > /dev/null 2>&1
    cd sentinel

	export LC_ALL=C > /dev/null 2>&1
    virtualenv ./venv > /dev/null 2>&1
    ./venv/bin/pip install -r requirements.txt > /dev/null 2>&1

	sleep 20
	crontab -l > ~/tempcron

	if ! grep -q "* * * * * cd $HOMEDIR/${COINCORE}/sentinel && ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1" $HOMEDIR/tempcron
	then
		echo "* * * * * cd $HOMEDIR/${COINCORE}/sentinel && ./venv/bin/python bin/sentinel.py >> sentinel.log 2>&1" >> $HOMEDIR/tempcron
	fi

	crontab $HOMEDIR/tempcron

	echo "${COINSHORT_LOWER}_conf=$HOMEDIR/$COINCORE/$COINCONFIG" >> $HOMEDIR/$COINCORE/sentinel/sentinel.conf

	cd ~

	echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# start wallet
startWallet() {

	echo -e "${YELLOW}*** [STEP 9/${MAX}] *** Starting wallet ...\n${NONE}"

	cd $HOMEDIR/$COINCORE

	sudo rm -rf blocks chainstate banlist.dat fee_estimates.dat governance.dat mncache.dat mnpayments.dat netfulfilled.dat peers.dat > /dev/null 2>&1
	sleep 20
    $HOMEDIR/$COINCORE/$COINDAEMON -daemon > /dev/null 2>&1

    echo -e "${GREEN}* ... OK, done. ${NONE} \n"
}

# sync wallet
syncWallet() {

	echo -e "${YELLOW}*** [STEP 10/${MAX}] *** Syncing wallet ... this can take a long time ... please be patient!\n${NONE}"

    until $HOMEDIR/$COINCORE/$COINCLI mnsync status | grep -m 1 '"IsBlockchainSynced": true'; do print "`$HOMEDIR/$COINCORE/$COINCLI getblockcount` ... "; sleep 5 ; done  2> /dev/null
    echo -e "${GREEN}* ... Blockchain synced ... ${NONE}"
    until $HOMEDIR/$COINCORE/$COINCLI mnsync status | grep -m 1 '"IsMasternodeListSynced": true'; do sleep 5 ; done > /dev/null 2>&1
	echo -e "${GREEN}* ... Masternodelist synced ... ${NONE}"
    until $HOMEDIR/$COINCORE/$COINCLI mnsync status | grep -m 1 '"IsWinnersListSynced": true'; do sleep 5 ; done > /dev/null 2>&1
    echo -e "${GREEN}* ... Winnerslist synced ... ${NONE}"
    until $HOMEDIR/$COINCORE/$COINCLI mnsync status | grep -m 1 '"IsSynced": true'; do sleep 5 ; done > /dev/null 2>&1
    echo -e "${GREEN}* ... OK, done. ${NONE} \n"

}

# cleanup
cleanUp() {

	echo -e "${YELLOW}*** [STEP 11/${MAX}] *** Cleaning up\n${NONE}"
	rm -rf $HOMEDIR/$COINGITHUB_LOCAL $HOMEDIR/tempcron
	echo -e "${GREEN}* ... OK, done. ${NONE} \n"

}

# main

clear
cd ~
HOMEDIR=`pwd`

echo
echo -e "##########################################################################################"
echo -e "#"
echo -e "#			${BOLD}------ $COINSHORT  Masternode-Installer ------${NONE}"
echo -e "#"
echo -e "##########################################################################################"
echo

echo -e "${BOLD}This script will setup your $COINSHORT Masternode under the directory $HOMEDIR.\nDo you wish to continue? (y/n)? ${NONE}"
read answer

# call the functions
case $answer in
	y|Y)	checkForUbuntuVersion
			updateAndUpgrade
			setupSwap
			installRequirements
			downloadWallet
			installWallet
			configureWallet
			installSentinel
			startWallet
			syncWallet
			cleanUp

			masternodegenkey=`grep masternodeprivkey $HOMEDIR/$COINCORE/$COINCONFIG | cut -d"=" -f2`
			echo -e "${BOLD}\nCongratulations!!!\nYour VPS has been installed sucessfully.${NONE}"
			echo -e "Please insert the following line to the file ${YELLOW}masternode.conf${NONE} on your cold wallet and replace xx, tx and id."
			echo -e "${CYAN}${COINSHORT}MNxx ${IP}:${COINPORT} ${masternodegenkey} tx id${NONE}"
			echo -e "${BOLD}Now continue with the cold wallet part of the Masternode-Guide${NONE}"
			;;

    *)		echo -e "${YELLOW}* ... Installation cancelled. ${NONE} \n"
			;;

esac


