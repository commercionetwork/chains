# Commercio.network Chains
This repository contains all the data related to the different chains that a Commercio.network validator can connect to.

# Current Chains

## Mainnet: `commercio-2_2`

### Persistent Peers list

#### We Can Consulting Spa
dfaaf7a522b402a52551d298659d059c628dfe57@35.176.21.232:26656

---
#### APConsulting Srl
027f3f907ee75483285d503c2eac143db8804afb@18.157.241.218:26656

---
#### 5Giornate Srl
4e2d2e4cfd7decabafa11f1ae7e0a59756b3ff98@52.47.96.177:26656

---
#### CPHolding Srl
07490eaa07ff84fc237c26d375cb8d6915f00da5@52.58.194.255:26656

---
#### Jadochain23 Srl
a05ea1165d1b5cbe25633ced63f3545e333e85b7@54.170.169.168:26656

---
#### Infominds Spa
42a724ad22ae4a621b98baaa1a9e29b209b473d3@185.161.193.102:26656
daed964b5e82bd074f6f5e552e0e90514a9c11a9@185.161.193.103:26656

---
#### eglue-v3
4a6a547a38d2e9170f15ba30cde37e3fa9f0955f@108.128.171.148:26656

---
#### 2CSolution
617ae023b642af69c832399980dc6527ddec13a0@35.176.229.43:26656

---
#### 4Chain
ffc7ecf24a26c51837671d22166b273b229038a4@18.132.92.229:26656

---
#### bluit
a2417b3d1e47fe502a6d1a8964f52904dd20b0b4@35.157.212.238:26656

---
#### Flamingo
c8525304ba1005f7ea207d57d739ea43e5a603fd@15.236.221.91:26656

---
#### NSSP
d435b388b80a2d8f316411e64ca371620b6ced28@15.236.228.182:26656

---
#### SPAZIOPROFESSIONISTA
2596f7fe733dec114cdd590eb0bb06ca5d16c12f@18.133.35.165:26656

---
#### StudioBortoletto
53529ed1fa49e0c70b8cd52d86eecc72750cdf8c@18.200.52.241:26656

---
#### BortolettoCentroPaghe
c24ec40f8a4ffc3a21ed13de58da095209478ab1@63.32.146.106:26656

---
#### CPNE
f7d65afbb95a9e405cb2c70176231ac83fd1dc0d@18.192.168.160:26656

---
#### La Fiume Mobili
10e69c7ea2d08a84a224116ae4da8955f0ff236f@3.10.147.9:26656

---
#### Corvallis
05f3ac48231d82bf555d489f53cea2870d267dd6@78.26.127.221:26656

---
#### Commercio/Tradenet
3f26a7d3269e352574e760d4b08d045aa40ebbf2@64.225.78.169:26656
e84b1b8cdb6563170466912f082829c2e4d28ab1@64.225.64.179:26656
01f615a56a7ba14d39e4eaf2bfd00a885cc4e629@64.227.113.198:26656
d6e07b5f0a69bd4d6f4e6e931f00fbcb992a8654@134.122.98.51:26656

------------------


### Persistent Peers

persistent_peers = "dfaaf7a522b402a52551d298659d059c628dfe57@35.176.21.232:26656,027f3f907ee75483285d503c2eac143db8804afb@18.157.241.218:26656,4e2d2e4cfd7decabafa11f1ae7e0a59756b3ff98@52.47.96.177:26656,07490eaa07ff84fc237c26d375cb8d6915f00da5@52.58.194.255:26656,a05ea1165d1b5cbe25633ced63f3545e333e85b7@54.170.169.168:26656,42a724ad22ae4a621b98baaa1a9e29b209b473d3@185.161.193.102:26656,daed964b5e82bd074f6f5e552e0e90514a9c11a9@185.161.193.103:26656,4a6a547a38d2e9170f15ba30cde37e3fa9f0955f@108.128.171.148:26656,617ae023b642af69c832399980dc6527ddec13a0@35.176.229.43:2665,ffc7ecf24a26c51837671d22166b273b229038a4@18.132.92.229:26656,a2417b3d1e47fe502a6d1a8964f52904dd20b0b4@35.157.212.238:26656,c8525304ba1005f7ea207d57d739ea43e5a603fd@15.236.221.91:26656,d435b388b80a2d8f316411e64ca371620b6ced28@15.236.228.182:26656,2596f7fe733dec114cdd590eb0bb06ca5d16c12f@18.133.35.165:26656,53529ed1fa49e0c70b8cd52d86eecc72750cdf8c@18.200.52.241:26656,c24ec40f8a4ffc3a21ed13de58da095209478ab1@63.32.146.106:26656,f7d65afbb95a9e405cb2c70176231ac83fd1dc0d@18.192.168.160:26656,10e69c7ea2d08a84a224116ae4da8955f0ff236f@3.10.147.9:26656,3f26a7d3269e352574e760d4b08d045aa40ebbf2@64.225.78.169:26656,e84b1b8cdb6563170466912f082829c2e4d28ab1@64.225.64.179:26656,01f615a56a7ba14d39e4eaf2bfd00a885cc4e629@64.227.113.198:26656,d6e07b5f0a69bd4d6f4e6e931f00fbcb992a8654@134.122.98.51:26656"


## Testnet: `commercio-testnet10k2`
----

## Devnet: `commercio-devnet07`
**Attention**: Devnet chain is only for internal develop


## Getting Started
**IMPORTANT BEFORE YOU START**: If you are already a validator you need see section [Update chain](#update-chain) procedure.    
If you are thinking of creating a new server instance, use the following procedure.      
      
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

