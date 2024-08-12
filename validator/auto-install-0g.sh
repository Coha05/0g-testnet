#!/bin/bash

# Ask for the validator/moniker name
read -p "Enter your validator/moniker name: " MONIKER

# Step 1: Install required packages
sudo apt update && sudo apt install curl git jq build-essential gcc unzip wget lz4 -y

# Step 2: Install Go
cd $HOME
ver="1.22.0"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
source ~/.bash_profile
go version

# Step 3: Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0

# Step 4: Build 0gchaind binary from version v0.2.5
cd $HOME
git clone https://github.com/0glabs/0g-chain.git
cd 0g-chain
git checkout v0.2.5
make install
0gchaind version

# Step 5: Set up variables
echo "export MONIKER=\"$MONIKER\"" >> ~/.bash_profile
echo 'export CHAIN_ID="zgtendermint_16600-2"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
echo 'export DAEMON_NAME="0gchaind"' >> ~/.bash_profile
echo 'export DAEMON_HOME="$HOME/.0gchain"' >> ~/.bash_profile
source ~/.bash_profile

# Step 6: Initialize the node
cd $HOME
0gchaind init $MONIKER --chain-id $CHAIN_ID
0gchaind config chain-id $CHAIN_ID
0gchaind config node tcp://localhost:$RPC_PORT
0gchaind config keyring-backend os

# Step 7: Download genesis.json
wget https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json -O $HOME/.0gchain/config/genesis.json

# Step 8: Add seeds and peers to the config.toml
SEEDS="81987895a11f6689ada254c6b57932ab7ed909b6@54.241.167.190:26656,010fb4de28667725a4fef26cdc7f9452cc34b16d@54.176.175.48:26656,e9b4bc203197b62cc7e6a80a64742e752f4210d5@54.193.250.204:26656,68b9145889e7576b652ca68d985826abd46ad660@18.166.164.232:26656"
sed -i.bak -e "s/^seeds *=.*/seeds = \"${SEEDS}\"/" $HOME/.0gchain/config/config.toml

# Step 9: Change ports (Optional)
EXTERNAL_IP=$(wget -qO- eth0.me)
PROXY_APP_PORT=26658
P2P_PORT=26656
PPROF_PORT=6060
API_PORT=1317
GRPC_PORT=9090
GRPC_WEB_PORT=9091
sed -i \
    -e "s/\(proxy_app = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$PROXY_APP_PORT\"/" \
    -e "s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$RPC_PORT\"/" \
    -e "s/\(pprof_laddr = \"\)\([^:]*\):\([0-9]*\).*/\1localhost:$PPROF_PORT\"/" \
    -e "/\[p2p\]/,/^\[/{s/\(laddr = \"tcp:\/\/\)\([^:]*\):\([0-9]*\).*/\1\2:$P2P_PORT\"/}" \
    -e "/\[p2p\]/,/^\[/{s/\(external_address = \"\)\([^:]*\):\([0-9]*\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/; t; s/\(external_address = \"\).*/\1${EXTERNAL_IP}:$P2P_PORT\"/}" \
    $HOME/.0gchain/config/config.toml
sed -i \
    -e "/\[api\]/,/^\[/{s/\(address = \"tcp:\/\/\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$API_PORT\4/}" \
    -e "/\[grpc\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_PORT\4/}" \
    -e "/\[grpc-web\]/,/^\[/{s/\(address = \"\)\([^:]*\):\([0-9]*\)\(\".*\)/\1\2:$GRPC_WEB_PORT\4/}" \
    $HOME/.0gchain/config/app.toml

# Step 10: Configure pruning to save storage (Optional)
sed -i \
    -e "s/^pruning *=.*/pruning = \"custom\"/" \
    -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" \
    -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" \
    "$HOME/.0gchain/config/app.toml"

# Step 11: Set min gas price
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml

# Step 12: Enable indexer (Optional)
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml

# Step 13: Create the Cosmovisor directories
mkdir -p $HOME/.0gchain/cosmovisor/genesis/bin
mkdir -p $HOME/.0gchain/cosmovisor/upgrades

# Step 14: Copy the 0gchaind binary to the genesis bin directory
cp $(which 0gchaind) $HOME/.0gchain/cosmovisor/genesis/bin

# Step 15: Create a Cosmovisor service file
sudo tee /etc/systemd/system/0gd.service > /dev/null <<EOF
[Unit]
Description=Cosmovisor 0G Node
After=network.target

[Service]
User=root
Type=simple
WorkingDirectory=/root/.0gchain
ExecStart=/root/go/bin/cosmovisor run start
Restart=on-failure
LimitNOFILE=65535
Environment="DAEMON_NAME=0gchaind"
Environment="DAEMON_HOME=/root/.0gchain"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_DATA_BACKUP_DIR=/root/.0gchain/cosmovisor/backup"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF

# Step 16: Start the node
sudo systemctl daemon-reload
sudo systemctl enable 0gd
sudo systemctl start 0gd

# Step 17: Verify the node is running correctly
journalctl -u 0gd -f
