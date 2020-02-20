#!/bin/bash

# Set up initial data

DEMON_BIN=cnd
CLI_BIN=cncli
GO_HOME="$HOME/go"
GO_BIN="$GO_HOME/bin"

DEMON_BIN_PATH=$GO_BIN/$DEMON_BIN
CLI_BIN_PATH=$GO_BIN/$CLI_BIN

# Control system and install all needed packages
printf "Control system and install all needed packages\n"

EXISTS_CND_SERVICE=$(systemctl list-units --full -all | fgrep cnd.service)
EXISTS_CNCLI_SERVICE=$(systemctl list-units --full -all | fgrep cncli.service)

apt install -y git gcc make unzip
snap install --classic go
printf "Dowload repo of chains\n"

PROCESS_TIME=$(date "+%Y%m%d%H%M%S")

cd

if [ -d commercio-chains ]; then
    mv commercio-chains commercio-chains.$PROCESS_TIME
fi
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .

LIST_OF_CHAINS=($(ls -d commercio-testnet*))
NUMBER_OF_CHAINS=${#LIST_OF_CHAINS[*]}

#

printf "Please select chain that you need\n"

for ((i = 0; i <= $(($NUMBER_OF_CHAINS - 1)); i++)); do
    printf "[$i] ${LIST_OF_CHAINS[$i]}\n"
done

printf "Use number and press \"Enter\": "
read CHAIN_ID_SELECTED

if [ ! "$(echo $CHAIN_ID_SELECTED | egrep [0-9]+)" ] || [ ! "$CHAIN_ID_SELECTED" ] || [ ! "${LIST_OF_CHAINS[$CHAIN_ID_SELECTED]}" ]; then
    printf "[ERR] You need selected a valid chain\n"
    exit
else
    TARGET_CHAIN="${LIST_OF_CHAINS[$CHAIN_ID_SELECTED]}"
fi

printf "Proceded to install $TARGET_CHAIN\n"

TARGET_FOLDER="$HOME/commercio-chains/$TARGET_CHAIN"
cd $TARGET_FOLDER

CHAIN_NAME=$(cat .data | grep -oP 'Name\s+\K\S+')
BIN_VERSION=$(cat .data | grep -oP 'Release\s+\K\S+')
PERSISTENT_PEERS=$(cat .data | grep -oP 'Persistent peers\s+\K\S+')
SEEDS=$(cat .data | grep -oP 'Seeds\s+\K\S+')
GENESIS_CHECKSUM=$(cat .data | grep -oP 'Seeds\s+\K\S+')

printf "Proceded to stop all services\n"

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

printf "Proceded to install binaries\n"

cd $GO_BIN
wget "https://github.com/commercionetwork/commercionetwork/releases/download/$BIN_VERSION/Linux-AMD64.zip"
unzip -o Linux-AMD64.zip
rm -rf Linux-AMD64.zip

printf "Control version of software\n"

BIN_VERSION_INSTALLED=v$($DEMON_BIN version)

if [ ! $BIN_VERSION_INSTALLED = $BIN_VERSION ]; then
    printf "[ERR] Version of installed binaries is incorrect: $BIN_VERSION_INSTALLED =\= $BIN_VERSION\n"
    exit
else
    printf "Ok"
fi

cd $TARGET_FOLDER
printf "Save your config folder, reset chain and install configurations\n"

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
    printf "Service cnd seems not present in you system. Do you want install it [y/n] and press \"Enter\"? "
    read INSTALL_CND_SERVICE
    while [ ! $INSTALL_CND_SERVICE = "y" ] && [ ! $INSTALL_CND_SERVICE = "n" ]; do
        printf "Choose [y/n]"
        read INSTALL_CND_SERVICE
    done
    if [ ! $INSTALL_CND_SERVICE = "y" ]; then
        printf "Exit from program. Please complete manually the installation of services"
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
    printf "Service $CLI_BIN seems not present in you system. Do you want install it [y/n] and press \"Enter\"? "
    read INSTALL_CNCLI_SERVICE
    while [ ! $INSTALL_CNCLI_SERVICE = "y" ] && [ ! $INSTALL_CNCLI_SERVICE = "n" ]; do
        printf "Choose [y/n]"
        read INSTALL_CNCLI_SERVICE
    done
    if [ ! $INSTALL_CNCLI_SERVICE = "y" ]; then
        printf "If you need complete manually the installation of service"
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

printf "Test if chain correctly starts"
sleep 10


#cnd[7825]: I[2020-02-20|12:04:10.340] starting ABCI with Tendermint 
#nd.service                                                                     loaded    active   running   Commercio Node 
CONTROL_RUNNING=$(systemctl list-units --full -all | fgrep cncli.service | fgrep running)

CONTROL_START=$(egrep "cnd\[[0-9]+\].+I\[$START_TIME.+\] starting ABCI with Tendermint" /var/log/syslog)

#cnd[7983]: E[2020-02-20|12:23:52.911] dialing failed
CONTROL_ERROR=$(egrep "cnd\[[0-9]+\].+E\[$START_TIME.+\]" /var/log/syslog)

if [ ! "$CONTROL_RUNNING" ]; then
    printf "Service not running: verify your configurations and proced manually"
    exit
fi 

if [ ! "$CONTROL_START" ]; then
    printf "Service not start correctly: verify your configurations and proced manually"
    exit
fi 

printf "Your service start and running.\n"


if [ "$CONTROL_ERROR" ]; then
    printf "Some errors with your service. Please control your logs with command 'tail -100 /var/log/syslog' "
    exit
fi 

printf "Great you joined chain $CHAINID. HAVE FUN\n"
