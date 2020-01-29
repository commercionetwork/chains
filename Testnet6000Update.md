# Commercio.network testnet 6000 Update

**ATTENTION**: This guide is only for updating from commercio-testnet5000 to commercio-testnet6000 and for full nodes or validators that have followed the instructions reported here [Installing a full node](https://docs.commercio.network/nodes/full-node-installation.html#_1-installing-the-software-requirements)

## **BEFORE YOU START**
After genesis time the chain may not be started immediately: if the consensus is not reached, the first block will not be released.   
It is important that 2/3 of the validator nodes must be on-line.    
**If chain is not started after two hours a new chain will be released starting from scratch and all create-validator transactions must be repeated. All other transactions will be lost**

## 1. Quick update

### 1. Install binaries

```bash
systemctl stop cnd
pkill cncli
cp -r ~/go/bin ~/go/bin.1.3.3
cd ~/go/bin
wget "https://github.com/commercionetwork/commercionetwork/releases/download/v1.4.0/Linux-AMD64.zip"
unzip -o Linux-AMD64.zip 
rm -rf Linux-AMD64.zip
```

### 2. Get chain data


```bash
cd ~/
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet6000
```

Update your CHAINID

```bash
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile
```

Test if you have the correct binaries version:

```bash
cnd version
```
Should output the same version written inside the .data file: v1.4.0     
Use this command to control it
```bash
cat .data | grep -oP 'Release\s+\K\S+'
```



### 3. Backup your .cnd folder and install new chain

Cancel previous backup if you have it
```bash
rm -rf ~/.cnd.save
```
Save state of commercio-testnet5000

```bash
cp -r ~/.cnd ~/.cnd.save
```

Reset chain and install new genesis:


```bash
cnd unsafe-reset-all
cp genesis.json ~/.cnd/config
```

Change the persistent peers inside config.toml file
```bash
sed -e "s|persistent_peers = \".*\"|persistent_peers = \"$(cat .data | grep -oP 'Persistent peers\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

Change the seeds inside the config.toml file
```bash
sed -e "s|seeds = \".*\"|seeds = \"$(cat .data | grep -oP 'Seeds\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

### 4. Start your node 
```bash
systemctl start cnd
```

Control if the node was started. Use Ctrl + C to interrupt the tail command

```bash
tail -100f /var/log/syslog
```

Output should be like below if you start the chain before the genesis time
```bash
#Gen 29 10:38:33 yournodehost cnd[25314]: I[2020-01-29|10:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

Start rest server if you need

```bash
cncli rest-server
```




## 2. Slow update

### 1. Install requirements
In order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && apt upgrade -y
snap refresh go
```

### 2. Get chain data
Before update the node, get commercio-testnet6000 chain data 

```shell
cp -r ~/go/bin ~/go/bin.1.3.3
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet6000 
```

### 3. Install binaries, genesis file and setup configuration

Compile binaries 

```shell
systemctl stop cnd
pkill cncli
git init . 
git remote add origin https://github.com/commercionetwork/commercionetwork.git
git pull
git checkout tags/$(cat .data | grep -oP 'Release\s+\K\S+')
make install
```

Test if you have the correct binaries version:

```shell
cnd version
```

Should output the same version written inside the .data file: v1.4.0     
Use this command to control it
```bash
cat .data | grep -oP 'Release\s+\K\S+'
```

Update CHAINID:

```shell
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile
```

### 4. Backup your .cnd folder and install new chain

Cancel previous backup if you have it
```bash
rm -rf ~/.cnd.save
```
Save state of commercio-testnet5000

```bash
cp -r ~/.cnd ~/.cnd.save
```

Reset chain and install new genesis:


```bash
cnd unsafe-reset-all
cp genesis.json ~/.cnd/config
```

Change the persistent peers inside config.toml file
```bash
sed -e "s|persistent_peers = \".*\"|persistent_peers = \"$(cat .data | grep -oP 'Persistent peers\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

Change the seeds inside the config.toml file
```bash
sed -e "s|seeds = \".*\"|seeds = \"$(cat .data | grep -oP 'Seeds\s+\K\S+')\"|g" ~/.cnd/config/config.toml > ~/.cnd/config/config.toml.tmp
mv ~/.cnd/config/config.toml.tmp  ~/.cnd/config/config.toml
```

### 5. Start your node 
```bash
systemctl start cnd
```

Control if the sync was started. Use Ctrl + C to interrupt the tail command

```bash
tail -100f /var/log/syslog
```

Output should be like below if you start the chain before the genesis time
```bash
#Gen 29 10:38:33 yournodehost cnd[25314]: I[2020-01-29|10:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

Start rest server if you need

```bash
cncli rest-server
```
