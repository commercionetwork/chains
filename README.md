# Commercio.network Chains
This repository contains all the data related to the different chains that a Commercio.network validator can connect to.

# Current Chains

## Mainnet: `commercio-3`

## Warning

Use https://quicksync.commercio.network with the dump to start a new node.    
**Don't start from genesis**
### Seeds list

8d3ac30a774245019f7b94d7a0713fd8caccaa03@seed-01.commercio.network:26656
68ccfc9a1574923e344993d49253d8169f592f9e@seed-02.commercio.network:26656

### Persistent Peers list

3f26a7d3269e352574e760d4b08d045aa40ebbf2@persistent-01.commercio.network:26656
e84b1b8cdb6563170466912f082829c2e4d28ab1@209.250.247.45:26656
542a55fff599ea07e2b4841febff4a78cf8db2aa@persistent-05.commercio.network:26656
01f615a56a7ba14d39e4eaf2bfd00a885cc4e629@persistent-03.commercio.network:26656
15767f4961b501eb67e740aa60c1608bf65679f3@persistent-02.commercio.network:26656
d6e07b5f0a69bd4d6f4e6e931f00fbcb992a8654@persistent-04.commercio.network:26656
e2bd5ac83f0d2fde72571568b9a4203f7e76067d@64.225.95.231:26656

------------------

### Seeds 

seeds = "8d3ac30a774245019f7b94d7a0713fd8caccaa03@seed-01.commercio.network:26656,68ccfc9a1574923e344993d49253d8169f592f9e@seed-02.commercio.network:26656"
### Persistent Peers

persistent_peers = "3f26a7d3269e352574e760d4b08d045aa40ebbf2@persistent-01.commercio.network:26656,e84b1b8cdb6563170466912f082829c2e4d28ab1@209.250.247.45:26656,542a55fff599ea07e2b4841febff4a78cf8db2aa@persistent-05.commercio.network:26656,01f615a56a7ba14d39e4eaf2bfd00a885cc4e629@persistent-03.commercio.network:26656,15767f4961b501eb67e740aa60c1608bf65679f3@persistent-02.commercio.network:26656,d6e07b5f0a69bd4d6f4e6e931f00fbcb992a8654@persistent-04.commercio.network:26656,e2bd5ac83f0d2fde72571568b9a4203f7e76067d@64.225.95.231:26656"


## Testnet: `commercio-testnet11k`

Use https://quicksync.commercio.network with the dump to start a new node.    
**Don't start from genesis**
### Seeds list

a750af543e9e475c17af98cf3166f2a9f260c318@64.225.66.179:26656

### Persistent Peers list

263855c2a4f599633a5a86c79823365616a3f5cd@46.101.146.48:26656
5662530384f67f5b6317a48ec339cbf543a975fb@134.209.88.227:26656
f64d897a4d73f0324495eee811d4b1d137afef37@165.22.192.68:26656
c2af8cd06485a550ea86cbe5774f397bdffa3046@157.230.105.237:26656

------------------

### Seeds 

seeds = "a750af543e9e475c17af98cf3166f2a9f260c318@64.225.66.179:26656"
### Persistent Peers

persistent_peers = "263855c2a4f599633a5a86c79823365616a3f5cd@46.101.146.48:26656,5662530384f67f5b6317a48ec339cbf543a975fb@134.209.88.227:26656,f64d897a4d73f0324495eee811d4b1d137afef37@165.22.192.68:26656,c2af8cd06485a550ea86cbe5774f397bdffa3046@157.230.105.237:26656"


----

## Devnet: `commercio-devnet09`
**Attention**: Devnet chain is only for internal develop


## Getting Started
**IMPORTANT BEFORE YOU START**: If you are already a validator you need see section [Update chain](#update-chain) procedure.    
If you are thinking of creating a new server instance, use the following procedure.      
      
First off, you’ll need to setup a server. This guide is written for Digital Ocean, but it is applicable to any other
cloud provider like Amazon AWS, Google Cloud, Microsoft Azure, Alibaba Cloud or Scaleway.

Here's a friendly Digital Ocean $50 credit Coupon link: https://m.do.co/c/132ef6958ef7.

## 1. Setup chain version 2.2.0
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
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-<chain-version> # eg. cd commercio-testnet1001 
```

## 4. Install binaries, genesis file and setup configuration

Compile binaries 

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
export GOPATH="\$HOME/go"
export PATH="\$GOPATH/bin:\$PATH"
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
ExecStart=/root/go/bin/cnd start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

**Optional**. You can quick sync with the follow procedure:
```shell
wget "https://quicksync.commercio.network/$CHAINID.latest.tgz" -P ~/.cnd/
# Check if the checksum matches the one present inside https://quicksync.commercio.network
cd ~/.cnd/
tar -zxf $(echo $CHAINID).latest.tgz
```


Now you can start full node. Enable and try to start service

```shell
# Start the node  
systemctl enable cnd  
systemctl start cnd
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

## 7. Confirm your validator is active
Your validator is active if the following command returns anything:

```shell
cncli query staking validators --chain-id $CHAINID | fgrep $(cnd tendermint show-validator)
```
You should now see your validator inside the [Commercio.network explorer](https://test.explorer.commercio.network)

## Congratulations, you are now a Commercio.network validator 🎉

# Update chain
**IMPORTANT BEFORE YOU START**: If you are a new validator you need follow ["Getting Started"](##getting-started) procedure. __DON'T USE THESE UPDATE PROCEDURES__    
      
This section describe the procedures to update chain from a version to another.    
Every update have a specific produre type.   
First type will be used only for testnet chains, while the second will be used to update mainnet chain.  
Every chain starting `commercio-testnet3000` contains type procedure adopted.   
In     

`https://github.com/commercionetwork/chains/blob/master/commercio-<chain-version>/.data`      

You should find `Update type`.



## 1. Update with "getting started" procedure
This type is similar to the "getting started" procedure.   
You need to delete or move the `~/.cnd` folder and start as fresh.    
You can mantain your wallet that is installed in `~/.cncli` folder or in your `ledger` device, or recreate it with mnemonic.   
You can create new wallet if you prefered and use a new account to become a validator.   

```shell
systemctl stop cnd
pkill cnd #We want be sure that chain process was stopped ;)
```

Delete `~/.cnd` folder

```shell
rm -rf ~/.cnd
```

or move it (if you want keep the old testnet state for your porpouses). 
Use `<previous-chain-version>` name for copy name for example

```shell
cp -r ~/.cnd ~/.cnd.<previous-chain-version>
```

Now you can start follow "getting started" procedure.
**ATTENTION**: before go haed with "getting started" procedure read follow changes about some steps

In [`step 1`](##1-Setup) in order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && sudo apt upgrade -y
snap refresh --classic go # You need to update golang to last version
```


 In [`step 4`](##4-install-binaries-genesis-file-and-setup-configuration) you don't need to change the follow rows of your `~/.profile` file

```
export GOPATH="\$HOME/go"
export PATH="\$GOPATH/bin:\$PATH"
```

You need clean up your file from previous chain configurations

```shell
sed -i \
 -e '/export NODENAME=.*/d' \
 -e '/export CHAINID=.*/d' ~/.profile
```

and add new chain configs

```shell
export NODENAME="<your-moniker>"
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')

cat <<EOF >> ~/.profile
export NODENAME="$NODENAME"
export CHAINID="$CHAINID"
EOF
```

   

## 2. Update with cnd commands **(WIP 🛠)**
This procedure will be applied to mainnet chain and to some specific testnet update

### A. Preliminary/Risks **(WIP 🛠)**
To this type of procedure will be assigned a height of block, informations about checksum of geneis file and software version and a deadline expressed in UTC format.    
There is some risks about double signature: to avoid every sort of risks verify software and hash of `genesis.json` and specific configuration in `config.toml`.
The deadline of update must be respected: every validator that will not update just in time will be slashed.

### B. Recovery **(WIP 🛠)**
Is recommended to take a full data snapshot at the export height before update.   
This procedure is quite simple using commands below

```shell
systemctl stop cnd
cp -r ~/.cnd ~/.cnd.[OLD VERSION]
cp -r ~/.cncli ~/.cncli.[OLD VERSION]
# Save binaries also
cp -r /root/go/bin/cnd /root/go/bin/cnd.[OLD VERSION]
cp -r /root/go/bin/cncli /root/go/bin/cncli.[OLD VERSION]
```
### C. Upgrade Procedure **(WIP 🛠)**

```shell
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-<chain-version> # eg. cd commercio-testnet1001 
```

Compile binaries 

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

Get height from update info

```shell
export BLOCKHEIGHT=$(cat .data | grep -oP 'Height\s+\K\S+')
```

Export state from 




## 1. Setup version 3.0.0 (WIP)
For the sake of simplicity, we will assume you have selected the following DigitalOcean configuration.  
Please not that this is just an example, but any configuration similar to this one will work perfectly fine.      

| Characteristic | Specification |
| :------------: | :-----------: |
| Operative System | Ubuntu 18.04 |
| Number of CPUs | 8 |
| RAM | 32GB |
| SSD | 200GB | 

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
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-<chain-version> # eg. cd commercio-testnet1001 
```

## 4. Install binaries, genesis file and setup configuration

Compile binaries 

```shell
git init . 
git remote add origin https://github.com/commercionetwork/commercionetwork.git
git pull
git checkout tags/$(cat .data | grep -oP 'Release\s+\K\S+')
make install
```

Test if you have the correct binaries version:

```shell
commercionetworkd version
# Should output the same version written inside the .data file
```

Setup the validator node name. We will use the same name for node as well as the wallet key:

```shell
export NODENAME="<your-moniker>"
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
cat <<EOF >> ~/.profile
export NODENAME="$NODENAME"
export CHAINID="$CHAINID"
export GOPATH="\$HOME/go"
export PATH="\$GOPATH/bin:\$PATH"
EOF
```

Init the `.commercionetworkd` folder with the basic configuration

```shell
pkill cnd
commercionetworkd unsafe-reset-all

# If you get a error because .cnd folder is not present don't worry 
cnd init $NODENAME
```

Install `genesis.json` file

```shell
pkill cnd
rm -rf ~/.commercionetworkd/config/genesis.json
cp genesis.json ~/.commercionetworkd/config
```

Change the persistent peers inside `config.toml` file

```shell
sed -e "s|persistent_peers = \".*\"|persistent_peers = \"$(cat .data | grep -oP 'Persistent peers\s+\K\S+')\"|g" ~/.commercionetwork/config/config.toml > ~/.commercionetwork/config/config.toml.tmp
mv ~/.commercionetwork/config/config.toml.tmp  ~/.commercionetwork/config/config.toml
```

Change the seeds inside the `config.toml` file
```shell
sed -e "s|seeds = \".*\"|seeds = \"$(cat .data | grep -oP 'Seeds\s+\K\S+')\"|g" ~/.commercionetwork/config/config.toml > ~/.commercionetwork/config/config.toml.tmp
mv ~/.commercionetwork/config/config.toml.tmp  ~/.commercionetwork/config/config.toml
```

## 5. Configure the service

```shell
tee /etc/systemd/system/commercionetworkd.service > /dev/null <<EOF  
[Unit]
Description=Commercio Node
After=network-online.target

[Service]
User=root
ExecStart=/root/go/bin/commercionetwork start
Restart=always
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF
```

**Optional**. You can quick sync with the follow procedure:
```shell
wget "https://quicksync.commercio.network/$CHAINID.latest.tgz" -P ~/.cnd/
# Check if the checksum matches the one present inside https://quicksync.commercio.network
cd ~/.cnd/
tar -zxf $(echo $CHAINID).latest.tgz
```


Now you can start full node. Enable and try to start service

```shell
# Start the node  
systemctl enable commercionetworkd  
systemctl start commercionetworkd
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

## 7. Confirm your validator is active
Your validator is active if the following command returns anything:

```shell
cncli query staking validators --chain-id $CHAINID | fgrep $(cnd tendermint show-validator)
```
You should now see your validator inside the [Commercio.network explorer](https://test.explorer.commercio.network)

## Congratulations, you are now a Commercio.network validator 🎉

# Update chain
**IMPORTANT BEFORE YOU START**: If you are a new validator you need follow ["Getting Started"](##getting-started) procedure. __DON'T USE THESE UPDATE PROCEDURES__    
      
This section describe the procedures to update chain from a version to another.    
Every update have a specific produre type.   
First type will be used only for testnet chains, while the second will be used to update mainnet chain.  
Every chain starting `commercio-testnet3000` contains type procedure adopted.   
In     

`https://github.com/commercionetwork/chains/blob/master/commercio-<chain-version>/.data`      

You should find `Update type`.



## 1. Update with "getting started" procedure
This type is similar to the "getting started" procedure.   
You need to delete or move the `~/.cnd` folder and start as fresh.    
You can mantain your wallet that is installed in `~/.cncli` folder or in your `ledger` device, or recreate it with mnemonic.   
You can create new wallet if you prefered and use a new account to become a validator.   

```shell
systemctl stop cnd
pkill cnd #We want be sure that chain process was stopped ;)
```

Delete `~/.cnd` folder

```shell
rm -rf ~/.cnd
```

or move it (if you want keep the old testnet state for your porpouses). 
Use `<previous-chain-version>` name for copy name for example

```shell
cp -r ~/.cnd ~/.cnd.<previous-chain-version>
```

Now you can start follow "getting started" procedure.
**ATTENTION**: before go haed with "getting started" procedure read follow changes about some steps

In [`step 1`](##1-Setup) in order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && sudo apt upgrade -y
snap refresh --classic go # You need to update golang to last version
```


 In [`step 4`](##4-install-binaries-genesis-file-and-setup-configuration) you don't need to change the follow rows of your `~/.profile` file

```
export GOPATH="\$HOME/go"
export PATH="\$GOPATH/bin:\$PATH"
```

You need clean up your file from previous chain configurations

```shell
sed -i \
 -e '/export NODENAME=.*/d' \
 -e '/export CHAINID=.*/d' ~/.profile
```

and add new chain configs

```shell
export NODENAME="<your-moniker>"
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')

cat <<EOF >> ~/.profile
export NODENAME="$NODENAME"
export CHAINID="$CHAINID"
EOF
```

   

## 2. Update with cnd commands **(WIP 🛠)**
This procedure will be applied to mainnet chain and to some specific testnet update

### A. Preliminary/Risks **(WIP 🛠)**
To this type of procedure will be assigned a height of block, informations about checksum of geneis file and software version and a deadline expressed in UTC format.    
There is some risks about double signature: to avoid every sort of risks verify software and hash of `genesis.json` and specific configuration in `config.toml`.
The deadline of update must be respected: every validator that will not update just in time will be slashed.

### B. Recovery **(WIP 🛠)**
Is recommended to take a full data snapshot at the export height before update.   
This procedure is quite simple using commands below

```shell
systemctl stop cnd
cp -r ~/.cnd ~/.cnd.[OLD VERSION]
cp -r ~/.cncli ~/.cncli.[OLD VERSION]
# Save binaries also
cp -r /root/go/bin/cnd /root/go/bin/cnd.[OLD VERSION]
cp -r /root/go/bin/cncli /root/go/bin/cncli.[OLD VERSION]
```
### C. Upgrade Procedure **(WIP 🛠)**

```shell
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-<chain-version> # eg. cd commercio-testnet1001 
```

Compile binaries 

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

Get height from update info

```shell
export BLOCKHEIGHT=$(cat .data | grep -oP 'Height\s+\K\S+')
```

Export state from 

