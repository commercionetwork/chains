# Getting Started

First off, you’ll need to setup a server! This guide is writing over Digital ocean VM provider, but is applicable in any other provider.     

We selected this type of server:   

* Ubuntu 18.04 OS
* 2 CPUs
* 4GB RAM
* 80GB SSD
* Allow incoming connections on ports 26656
* Static IP address

We assuming that you are using root user to execute commands. 
Update setup and install minimum requirements

```shell
# Update Ubuntu  
apt update && sudo apt upgrade -y
apt install unzip
```

# Install binaries, genesis file and setup configuration

Download binaries 

```shell
wget https://github.com/commercionetwork/chains/raw/master/commercio-testnet2000/linux.zip

unzip linux.zip
mv cn* /usr/bin/.

#Clean up after installation
rm linux.zip
```


Test if you have correct binaries

```shell
cnd version
#1.0.2
```

Setup validator node name: we use the same for node's name and wallet key
```shell
export NODENAME="<your-moniker>"
cat <<EOF >> ~/.profile
export NODENAME="$NODENAME"
EOF
```

Init `.cnd` folder with basic configuration

```shell
cnd unsafe-reset-all
# If you get a error because .cnd folder is not present don't worry 
cnd init $NODENAME
```

Install `genesis.json` file

```shell
pkill cnd
rm -rf ~/.cnd/config/genesis.json
wget https://github.com/commercionetwork/chains/raw/master/commercio-testnet2000/genesis.json -P ~/.cnd/config
```

Change persistent peers in `config.toml` file
```
sed -e "s|persistent_peers = \"\"|persistent_peers = \"3a71a89d7b808a5a940fea4d5ec063416d017e3f@167.71.39.115:26656,8b062a296a4dede07333dc32ee105dd1677dc3cd@167.71.62.24:26656,ad067538c5994093f80712130ecba1fa651286b2@167.71.49.105:26656,9cc2d5ca3262f9a99965c963a2cebe420931148a@167.71.56.41:26656\"|g" ~/.cnd/config/config.toml
```

# Configure service


```shell
tee /etc/systemd/system/cnd.service > /dev/null <<EOF  
[Unit]
Description=Commercio Node
After=network-online.target

[Service]
User=root
ExecStart=/usr/bin/cnd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

Now you can start full node. Enable and try to start service

```shell
# Start the node  
sudo systemctl enable cnd  
sudo systemctl start cnd
```

Control if the sync was started. Use `ctrl+c` to interrupt `tail` command

```shell
tail -100f /var/log/syslog
# ##
```

# Add wallet key, get tokens and create validator


Add your key to the wallet. In testnet we don't use the ledger support. With ledger add `--ledger` option to command.    
**ATTENTION**: copy 24 words seed in secure place. They are your memonic and if you loose them you lose all  

```shell
cncli keys add $NODENAME
# Enter a password that you can remember
```

Copy your public address. It should have the format "did:com:1xng98xng4l7hpzh4l72z4xcl02k4f8x3tjvk4f".    
Below we use `<your pub addr>` for your public address
You can retrieve your data key using
```shell
cncli keys list
```

Send your `<your pub addr>` in telegram group `Commercio testnet support` requesting tokens to create validator transaction

After you have the confirm about transaction, control if you have tokens in your wallet

```shell
cncli query account <your pub addr> --chain-id commercio-testnet2000
# Output should show like this
# ...
#   - denom: ucommercio
#    amount: "52000000000"
# ...
```

Now you can create validator. If you want you can fill follow parameters
* `--details`: add a brief description about your node or your company
* `--identity`: add **Keybase** identity
* `--website`: add public site of your node or your company


```shell
cncli tx staking create-validator \
  --amount=50000000000ucommercio \
  --pubkey=$(cnd tendermint show-validator) \
  --moniker="$NODENAME" \
  --chain-id=commercio-testnet2000 \
  --identity="" --website="" --details="" \
  --commission-rate="0.10" --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" --min-self-delegation="1" \
  --from=<your pub addr> \
  -y
  ```

