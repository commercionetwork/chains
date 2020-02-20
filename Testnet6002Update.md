# Commercio.network testnet 6001 Update

**ATTENTION**: This guide is only for updating from commercio-testnet6001 to commercio-testnet6002 and for full nodes or validators that have followed the instructions reported here [Installing a full node](https://docs.commercio.network/nodes/full-node-installation.html#_1-installing-the-software-requirements)

**The upgrade is scheduled for 16.00 CET (15.00 UTC) on Friday 21/02/2020**

## **BEFORE YOU START**
After genesis time the chain may not be started immediately: if the consensus is not reached, the first block will not be released.   
It is important that 2/3 of the validator nodes must be on-line.    

## Why backup is not necessary?
Becouse the previus status is relative small and we published it at [Quick sync chain status](https://quicksync.commercio.network). The previus status is relative about paused chain and it doesn't able to start another chain again. **Keep safe only your `~/.cnd/config` folder**



## 1. Quick update 

### 1. Install new bineries


```bash
systemctl stop cnd
pkill cncli
systemctl stop cncli # Works only if you installed service for rest server
cd ~/go/bin
wget "https://github.com/commercionetwork/commercionetwork/releases/download/v1.5.0/Linux-AMD64.zip"
unzip -o Linux-AMD64.zip 
rm -rf Linux-AMD64.zip

```

### 2. Get chain data


```bash
cd ~/
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet6002
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
Should output the same version written inside the .data file: v1.5.0     
Use this command to control it
```bash
cat .data | grep -oP 'Release\s+\K\S+'
```

### 2. Install new chain

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


### 3. Start your node 
```bash
systemctl start cnd
```

Control if the node was started. Use Ctrl + C to interrupt the tail command

```bash
tail -100f /var/log/syslog
```

Output should be like below if you start the chain before the genesis time
```bash
#Feb 21 10:38:33 yournodehost cnd[25314]: I[2020-02-21|10:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

If you need you can start rest server with command

```bash
cncli rest-server >/dev/null 2>&1 &
```



## 2. Slow update from previus chain

### 1. Install requirements
In order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && apt upgrade -y
snap refresh go
```

### 2. Get chain data
Before update the node, get commercio-testnet6002 chain data 

```shell
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet6002
```

### 3. Install binaries, genesis file and setup configuration

Compile binaries 

```shell
systemctl stop cnd
pkill cncli
systemctl stop cncli # Works only if you installed service for rest server
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

Should output the same version written inside the .data file: v1.5.0     
Use this command to control it
```bash
cat .data | grep -oP 'Release\s+\K\S+'
```

Update CHAINID:

```shell
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile
```

### 4. Install new chain

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
#Feb 21 10:38:33 yournodehost cnd[25314]: I[2020-02-21|10:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

If you need you can start rest server with command

```bash
cncli rest-server >/dev/null 2>&1 &
```
