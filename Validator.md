# Auto Install 
```
source <(curl -s https://raw.githubusercontent.com/Coha05/0g-testnet/main/auto-install-0g.sh)
```

# Upgrade Validator to higher version

### Stop the current service
sudo systemctl stop 0gd

### Navigate to home directory and remove the old version
cd $HOME
rm -rf 0g-chain

### Clone the repository
git clone https://github.com/0glabs/0g-chain.git
cd 0g-chain

### Get the latest release tag from GitHub
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)

### Checkout the latest release tag
git checkout $latest_tag

### Build and install the new version
make install

### Check the version
$HOME/go/bin/0gchaind version

### Restart the service and follow the logs
sudo systemctl restart 0gd && sudo journalctl -u 0gd -f -o cat

### Check the new logs folder
tail -f $HOME/.0gchain/log/chain.log
