#!/bin/bash

# Set up initial data
BLUE='\033[0;34m'
BLUE_BOLD='\033[1;34m'
RED='\033[0;31m'
RED_BOLD='\033[1;31m'
GREEN='\033[0;32m'
GREEN_BOLD='\033[1;32m'
ORANGE='\033[0;33m'
ORANGE_BOLD='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'

NC='\033[0m' # No Color

DEMON_BIN=cnd
CLI_BIN=cncli
GO_HOME="$HOME/go"
GO_BIN="$GO_HOME/bin"

DEMON_BIN_PATH=$GO_BIN/$DEMON_BIN
CLI_BIN_PATH=$GO_BIN/$CLI_BIN
INSTALLATION_FOLDER=commercio-chains
EXISTS_CND_SERVICE=$(systemctl list-units --full -all | fgrep cnd.service)
EXISTS_CNCLI_SERVICE=$(systemctl list-units --full -all | fgrep cncli.service)

printf "${RED}This is a beta script to easy update commercio testnet chain. \n"
printf "${GREEN}You can interrupt the process in any moment by \"Ctrl + c\" buttons\n${NC}"
# Control system and install all needed packages
printf "${GREEN}[OK]${NC} Control system and install all needed packages\n"

printf "${GRAY}"

printf "\n======================================================\n"
apt install -y git gcc make unzip 2>/dev/null
snap install --classic go 2>/dev/null
printf "======================================================\n\n"
printf "${NC}"

printf "${GREEN}[OK]${NC} Dowload chains repo\n"

PROCESS_TIME=$(date "+%Y%m%d%H%M%S")

cd $HOME

if [ -d $INSTALLATION_FOLDER ]; then
    mv $INSTALLATION_FOLDER $INSTALLATION_FOLDER.$PROCESS_TIME
fi
mkdir $INSTALLATION_FOLDER && cd $INSTALLATION_FOLDER
printf "${GRAY}\n======================================================\n"
git clone https://github.com/commercionetwork/chains.git .
printf "======================================================\n\n${NC}"

LIST_OF_CHAINS=($(ls -d commercio-testnet*))
NUMBER_OF_CHAINS=${#LIST_OF_CHAINS[*]}

printf "${GREEN}[OK]${NC} Please select chain that you need\n"

for ((i = 0; i <= $(($NUMBER_OF_CHAINS - 1)); i++)); do
    printf " ${GREEN_BOLD}[$i]${NC} ${LIST_OF_CHAINS[$i]}\n"
done

printf "Use number and press \"Enter\": "
read CHAIN_ID_SELECTED

if [ ! "$(echo $CHAIN_ID_SELECTED | egrep [0-9]+)" ] || [ ! "$CHAIN_ID_SELECTED" ] || [ ! "${LIST_OF_CHAINS[$CHAIN_ID_SELECTED]}" ]; then
    printf "[ERR] You need selected a valid chain\n"
    exit
else
    TARGET_CHAIN="${LIST_OF_CHAINS[$CHAIN_ID_SELECTED]}"
fi

printf "${GREEN}[OK]${NC} Install chain $TARGET_CHAIN\n"

TARGET_FOLDER="$HOME/commercio-chains/$TARGET_CHAIN"
cd $TARGET_FOLDER

CHAIN_NAME=$(cat .data | grep -oP 'Name\s+\K\S+')
BIN_VERSION=$(cat .data | grep -oP 'Release\s+\K\S+')
PERSISTENT_PEERS=$(cat .data | grep -oP 'Persistent peers\s+\K\S+')
SEEDS=$(cat .data | grep -oP 'Seeds\s+\K\S+')
GENESIS_CHECKSUM=$(cat .data | grep -oP 'Seeds\s+\K\S+')

printf "${GREEN}[OK]${NC} Stop all services\n"

if [ "$EXISTS_CND_SERVICE" ]; then
    systemctl stop $DEMON_BIN
fi

if [ "$EXISTS_CNCLI_SERVICE" ]; then
    systemctl stop $CLI_BIN
fi
pkill $CLI_BIN
pkill $DEMON_BIN

export CHAINID=commercio-$CHAIN_NAME
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile

printf "${GREEN}[OK]${NC} Install all binaries\n"

cd $GO_BIN

printf "${GRAY}\n======================================================\n"

wget "https://github.com/commercionetwork/commercionetwork/releases/download/$BIN_VERSION/Linux-AMD64.zip" >/dev/null 2>&1 &
PID=$!
i=1
sp="/-\|"
echo -n ' '
printf "Downloading binaries  "
while [ -d /proc/$PID ]; do
    printf "\b${sp:i++%${#sp}:1}"
done

unzip -o Linux-AMD64.zip
rm -rf Linux-AMD64.zip
printf "======================================================\n\n${NC}"

printf "${GREEN}[OK]${NC} Control version of software\n"

BIN_VERSION_INSTALLED=v$($DEMON_BIN version)

if [ ! $BIN_VERSION_INSTALLED = $BIN_VERSION ]; then
    printf "${RED_BOLD}[ERR]${NC} Version of installed binaries is incorrect: $BIN_VERSION_INSTALLED =\= $BIN_VERSION\n"
    exit
else
    printf "${GREEN}[OK]${NC} Versions matched\n"
fi

cd $TARGET_FOLDER
printf "${GREEN}[OK]${NC} Save your config folder, reset chain and install configurations\n"

mkdir -p $HOME/.cnd.$PROCESS_TIME/config
cp -r $HOME/.cnd/config/* $HOME/.cnd.$PROCESS_TIME/config/.
$DEMON_BIN unsafe-reset-all
cp genesis.json ~/.cnd/config

sed -e "s|persistent_peers = \".*\"|persistent_peers = \"$PERSISTENT_PEERS\"|g" ~/.cnd/config/config.toml >~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp ~/.cnd/config/config.toml

sed -e "s|seeds = \".*\"|seeds = \"$SEEDS\"|g" ~/.cnd/config/config.toml >~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp ~/.cnd/config/config.toml

printf "Restart services\n"

if [ ! "$EXISTS_CND_SERVICE" ]; then
    printf "${ORANGE_BOLD}[WARN]${NC} Service $CLI_BIN seems not present in you system. Do you want install it? Type \"y\" or \"n\" and press \"Enter\" [Default n] ? "
    read INSTALL_CND_SERVICE
    while [ ! $INSTALL_CND_SERVICE = "y" ] && [ ! $INSTALL_CND_SERVICE = "n" ]; do
        printf "${ORANGE_BOLD}[WARN]${NC} Choose [y/n] "
        read INSTALL_CND_SERVICE
    done

    if [ ! "$INSTALL_CNCLI_SERVICE" ]; then
        INSTALL_CND_SERVICE="n"
    fi

    if [ ! $INSTALL_CND_SERVICE = "y" ]; then
        printf "${RED_BOLD}[ERR]${NC} Exit from program. Please complete manually the installation of services\n"
        exit
    else
        tee /etc/systemd/system/$DEMON_BIN.service >/dev/null <<EOF
[Unit]
Description=Commercio Node
After=network-online.target

[Service]
User=root
ExecStart=$DEMON_BIN_PATH start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
        START_TIME=$(date "+%Y-%m-%d|%H")
        systemctl enable $DEMON_BIN
        systemctl start $DEMON_BIN

    fi

fi

if [ ! "$EXISTS_CND_SERVICE" ]; then
    printf "${ORANGE_BOLD}[WARN]${NC} Service $CLI_BIN seems not present in you system. Do you want install it? Type \"y\" or \"n\" and press \"Enter\" [Default n] ? "
    read INSTALL_CNCLI_SERVICE
    while [ ! $INSTALL_CNCLI_SERVICE = "y" ] && [ ! $INSTALL_CNCLI_SERVICE = "n" ]; do
        printf "${ORANGE_BOLD}[WARN]${NC} Choose [y/n] "
        read INSTALL_CNCLI_SERVICE
    done
    
    if [ ! "$INSTALL_CNCLI_SERVICE" ]; then
        INSTALL_CNCLI_SERVICE="n"
    fi
    
    if [ ! $INSTALL_CNCLI_SERVICE = "y" ]; then
        printf "${GREEN}[OK]${NC} Complete manually the installation of service if you need\n"
    else
        tee /etc/systemd/system/$CLI_BIN.service >/dev/null <<EOF
[Unit]
Description=Commercio Rest Service
After=network-online.target

[Service]
User=root
ExecStart=$CLI_BIN_PATH rest-server  --chain-id $CHAINID --trust-node  --laddr=tcp://0.0.0.0:1317
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
        systemctl enable $CLI_BIN
        systemctl start $CLI_BIN
    fi
fi

printf "${GREEN}[OK]${NC} Test if chain correctly started\n"
sleep 10

#cnd[7825]: I[2020-02-20|12:04:10.340] starting ABCI with Tendermint
#nd.service                                                                     loaded    active   running   Commercio Node
CONTROL_RUNNING=$(systemctl list-units --full -all | fgrep cncli.service | fgrep running)

CONTROL_START=$(egrep "cnd\[[0-9]+\].+I\[$START_TIME.+\] starting ABCI with Tendermint" /var/log/syslog)

#cnd[7983]: E[2020-02-20|12:23:52.911] dialing failed
CONTROL_ERROR=$(egrep "cnd\[[0-9]+\].+E\[$START_TIME.+\]" /var/log/syslog)

if [ ! "$CONTROL_RUNNING" ]; then
    printf "${GREEN}[OK]${NC} Service not running: verify your configurations and proced manually\n"
    exit
fi

if [ ! "$CONTROL_START" ]; then
    printf "${RED_BOLD}[ERR]${NC} Service not start correctly: verify your configurations and proced manually\n"
    exit
fi

printf "Your service start and running.\n"

if [ "$CONTROL_ERROR" ]; then
    printf "${RED_BOLD}[ERR]${NC} Some errors with your service. Please control your logs with command 'tail -100 /var/log/syslog' \n"
    exit
fi

printf "${GREEN}[OK]${NC} Great you joined chain $CHAINID. HAVE FUN 🚀 🚀 🚀 🚀 🚀  \n"
