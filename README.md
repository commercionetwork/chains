# Commercio.network Chains
This repository contains all the data related to the different chains that a Commercio.network validator can connect to.

## Getting Started
First off, you’ll need to setup a server. This guide is written for Digital Ocean, but it is applicable to any other
cloud provider like Amazon AWS, Google Cloud, Microsoft Azure, Alibaba Cloud or Scaleway.

Here's a friendly Digital Ocean $50 credit Coupon link: https://m.do.co/c/132ef6958ef7.

## 1. Setup
For the sake of simplicity, we will assume you have selected the following DigitalOcean configuration.  
Please not that this is just an example, but any configuration similar to this one will work perfectly fine.      

| Characteristic | Specification |
| :------------: | :-----------: |
| Operative System | Ubuntu 18.04 |
| Number of CPUs | 2 |
| RAM | 4GB |
| SSD | 80GB | 

Also, we need to make sure the following requirements are met: 
* Allow incoming connections on port `26656`
* Have a static IP address
* Have access to the root user

## 2. Installing requirements
In order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && sudo apt upgrade -y
apt install unzip
apt install -y git gcc make
snap install --classic go

GOPATH=$HOME/go
PATH=$GOPATH/bin:$PATH
```

## 3. Chain selection
Before installing the node, please select which chain you would like to connect to 

```shell
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-<chain-version> # eg. cd commercio-testnet1001 
```

## 4. Install binaries, genesis file and setup configuration

Download binaries 

```shell
git init . 
git remote add origin https://github.com/commercionetwork/commercionetwork.git
git pull
git checkout tags/$(cat .data | grep -oP 'Release\s+\K\S+')
make install
```

Test if you have the correct binaries version:

```shell
cnd version
# Should output the same version written inside the .data file
```

Setup the validator node name. We will use the same name for node as well as the wallet key:

```shell
export NODENAME="<your-moniker>"
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
cat <<EOF >> ~/.profile
export NODENAME="$NODENAME"
export CHAINID="$CHAINID"
EOF
```

Init the `.cnd` folder with the basic configuration

```shell
pkill cnd
cnd unsafe-reset-all

# If you get a error because .cnd folder is not present don't worry 
cnd init $NODENAME
```

Install `genesis.json` file

```shell
pkill cnd
rm -rf ~/.cnd/config/genesis.json
cp genesis.json ~/.cnd/config
```

Change the persistent peers inside `config.toml` file

```shell
sed -e "s|persistent_peers = \".*\"|persistent_peers = \"$(cat .data | grep -oP 'Persistent peers\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

Change the seeds inside the `config.toml` file
```shell
sed -e "s|seeds = \".*\"|seeds = \"$(cat .data | grep -oP 'Seeds\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

## 5. Configure the service

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
systemctl enable cnd  
systemctl start cnd
```

**Optional**. You can quick sync with the follow procedure:
```shell
wget "https://quicksync.commercio.network/$CHAINID.latest.tgz" -P ~/.cnd/
# Check if the checksum matches the one present inside https://quicksync.commercio.network
cd ~/.cnd/
tar -zxf commercio-$(echo $CHAINID).latest.tgz
```


Control if the sync was started. Use `ctrl+c` to interrupt `tail` command

```shell
tail -100f /var/log/syslog
# OUTPUT SHOULD BE LIKE BELOW
#
# Aug 13 16:30:20 commerciotestnet-node4 cnd[351]: I[2019-08-13|16:30:20.722] Executed block                               module=state height=1 validTxs=0 invalidTxs=0
# Aug 13 16:30:20 commerciotestnet-node4 cnd[351]: I[2019-08-13|16:30:20.728] Committed state                              module=state height=1 txs=0 appHash=9815044185EB222CE9084AA467A156DFE6B4A0B1BAAC6751DE86BB31C83C4B08
# Aug 13 16:30:20 commerciotestnet-node4 cnd[351]: I[2019-08-13|16:30:20.745] Executed block                               module=state height=2 validTxs=0 invalidTxs=0
# Aug 13 16:30:20 commerciotestnet-node4 cnd[351]: I[2019-08-13|16:30:20.751] Committed state                              module=state height=2 txs=0 appHash=96BFD9C8714A79193A7913E5F091470691B195E1E6F028BC46D6B1423F7508A5
# Aug 13 16:30:20 commerciotestnet-node4 cnd[351]: I[2019-08-13|16:30:20.771] Executed block                               module=state height=3 validTxs=0 invalidTxs=0
```

## 6. Add wallet key, get tokens and create a validator
Inside the testnet we don't use the Ledger. 
However, if you wish to do so, please add the `--ledger` flat to any command.
    
**ATTENTION**  
Please remember to copy the 24 words seed phrase in a secure place.  
They are your memonic and if you loose them you lose all your tokens and the whole access to your validator.  

```shell
cncli keys add $NODENAME
# Enter a password that you can remember
```

Copy your public address. It should have the format `did:com:<data>`.

```shell
cncli keys show $NODENAME --address
```
    
From now on we will refer to the value of your public address using the `<your pub addr>` notation.

In order to receive your tokens, please send your `<your pub addr>` inside our 
[Telegram group](https://t.me/commercionetworkvipsTelegram) requesting them. 
We will make sure to send them to you as soon as possible.

Once you've been confirmed the successful transaction, please check using the following command:
```shell
cncli query account <your pub addr> --chain-id $CHAINID
# Output should like this
# ...
#   - denom: ucommercio
#    amount: "52000000000"
# ...
```

Now you can create validator. If you want you can fill follow parameters
* `--details`: add a brief description about your node or your company
* `--identity`: your [Keybase](https://keybase.io) identity
* `--website`: a public site of your node or your company


```shell
cncli tx staking create-validator \
  --amount=50000000000ucommercio \
  --pubkey=$(cnd tendermint show-validator) \
  --moniker="$NODENAME" \
  --chain-id="$CHAINID" \
  --identity="" --website="" --details="" \
  --commission-rate="0.10" --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" --min-self-delegation="1" \
  --from=<your pub addr> \
  -y
# Output should like this
# ...
# rawlog: '[{"msg_index":0,"success":true,"log":""}]'
# ...
```

### 7. Confirm your validator is active
Your validator is active if the following command returns anything:

```shell
cncli query staking validators --chain-id $CHAINID | fgrep $(cnd tendermint show-validator)
```
You should now see your validator inside the [Commercio.network explorer](https://test.explorer.commercio.network)

## Congratulations, you are now a Commercio.network validator 🎉
