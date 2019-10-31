# Commercio.network testnet 4000 Update

**ATTENTION**: This guide is only for updating from commercio-testent3000 to commercio-testent4000 and for full nodes or validators that have followed the instructions reported here [Installing a full node](https://docs.commercio.network/nodes/full-node-installation.html#_1-installing-the-software-requirements)

## 1. Quick update

### 1. Install binaries

```bash
service cnd stop
pkill cncli
cd ~/go/bin
wget "https://github.com/commercionetwork/commercionetwork/releases/download/v1.3.1/Linux-AMD64.zip"
unzip -o Linux-AMD64.zip 
rm -rf Linux-AMD64.zip
```

### 2. Get chain data


```bash
cd ~/
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet4000
```

Update your CHAINID

```bash
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile
```

### 3. Backup your .cnd folder and install new chain

```bash
cp -r ~/.cnd ~/.cnd.save
```

Test if you have the correct binaries version:

```bash
cnd version
# Should output the same version written inside the .data file.
# cat .data | grep -oP 'Release\s+\K\S+'
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

Control if the sync was started. Use Ctrl + C to interrupt the tail command

```bash
tail -100f /var/log/syslog
# OUTPUT SHOULD BE LIKE BELOW If you start the chain before the genesis time
#Oct 30 18:38:33 yournodehost cnd[25314]: I[2019-10-30|18:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

## 2. Slow update

### 1. Install requirements
In order to update the OS so that you can work properly, execute the following commands:

```shell
apt update && apt upgrade -y
snap refresh go
```

### 2. Get chain data
Before update the node, get commercio-testnet4000 chain data 

```shell
rm -rf commercio-chains
mkdir commercio-chains && cd commercio-chains
git clone https://github.com/commercionetwork/chains.git .
cd commercio-testnet4000 
```

### 3. Install binaries, genesis file and setup configuration

Compile binaries 

```shell
service cnd stop
pkill cncli
git init . 
git remote add origin https://github.com/commercionetwork/commercionetwork.git
git pull
git checkout tags/$(cat .data | grep -oP 'Release\s+\K\S+')
go mod tidy
make install
```

Test if you have the correct binaries version:

```shell
cnd version
# Should output the same version written inside the .data file
# cat .data | grep -oP 'Release\s+\K\S+'
```

Update CHAINID:

```shell
export CHAINID=commercio-$(cat .data | grep -oP 'Name\s+\K\S+')
sed -ie "s|CHAINID=\".*\"|CHAINID=\"$CHAINID\"|g" ~/.profile
```

### 4. Backup your .cnd folder and install new chain

```bash
cp -r ~/.cnd ~/.cnd.save
```

Test if you have the correct binaries version:

```bash
cnd version
# Should output the same version written inside the .data file.
# cat .data | grep -oP 'Release\s+\K\S+'
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
# OUTPUT SHOULD BE LIKE BELOW If you start the chain before the genesis time
#Oct 30 18:38:33 yournodehost cnd[25314]: I[2019-10-30|18:38:33.401] starting ABCI with Tendermint                module=main
```

Update cncli config

```bash
cncli config chain-id $CHAINID
```

