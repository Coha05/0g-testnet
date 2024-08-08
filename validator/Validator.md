# Auto Install 
```
source <(curl -s https://raw.githubusercontent.com/Coha05/0g-testnet/main/validator/auto-install-0g.sh)
```
### Check logs
```
tail -f $HOME/.0gchain/log/chain.log
```

# Upgrade Validator to higher version without Cosmovisor

**1. Stop the current service**
```
sudo systemctl stop 0gd
```
**2. Navigate to home directory and remove the old version**
```
cd $HOME
rm -rf 0g-chain
```
**3. Clone the repository**
```
git clone https://github.com/0glabs/0g-chain.git
cd 0g-chain
```
**4. Get the latest release tag from GitHub**
```
latest_tag=$(git describe --tags `git rev-list --tags --max-count=1`)
```
**5. Checkout the latest release tag**
```
git checkout $latest_tag
```
**6. Build and install the new version**
```
make install
```
**7. Check the version**
```
$HOME/go/bin/0gchaind version
```
**8. Restart the service and follow the logs**
```
sudo systemctl restart 0gd
```
**9. Check the new logs folder**
```
tail -f $HOME/.0gchain/log/chain.log
```

# Upgrade Validator to higher version with Cosmovisor 
**Download the exact binary url NOT compile, also change the service systemd as your service**

**1. Stop the Cosmovisor Service:**
```
sudo systemctl stop 0gd.service
```
**2. Create the Upgrade Directory:**
```
mkdir -p $HOME/.0gchain/cosmovisor/upgrades/v0.3.0/bin
```
**3. Download the New Binary:**
```
wget -O $HOME/0gchaind-linux-v0.3.0 https://zgchaind-test.s3.ap-east-1.amazonaws.com/0gchaind-linux-v0.3.0
```
**4. Move the Binary to the Upgrades Directory:**
```
cp $HOME/0gchaind-linux-v0.3.0 $HOME/.0gchain/cosmovisor/upgrades/v0.3.0/bin/0gchaind
```
**5. Make the New Binary Executable:**
```
chmod +x $HOME/.0gchain/cosmovisor/upgrades/v0.3.0/bin/0gchaind
```
**6. Start the Cosmovisor (OG) Service:**
```
sudo systemctl start 0gd.service
```
**7. Check version:**
```
0gchaind version
```
**8. Check logs:**
```
tail -f $HOME/.0gchain/log/chain.log
```

****NOTE:**
The directory structure looks something like this:

![image](https://github.com/user-attachments/assets/afb1984b-f241-4b16-a4da-97227730c7e5)
