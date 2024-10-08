
# Hardware Requirement
> **Hardware Requirements**
> 
> - **RAM:** 8 GB
> - **CPU:** 2 cores
> - **Bandwidth:** 100 MBps for Download/Upload


# Installation

### 1. Install Dependencies:
```sudo apt-get update
sudo apt-get install cmake build-essential protobuf-compiler
```
### 2. Install Rust:
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
### 3. Clone the Source Code:
```
git clone https://github.com/0glabs/0g-da-retriever.git
cd 0g-da-retriever
```
### 4. Edit the configuration 

```
sudo nano $HOME/0g-da-retriever/run/config.toml
```
**Replace your JSON_RPC, default port: 8545** 

```
log_level = "info"

grpc_listen_address = "0.0.0.0:34005"
eth_rpc_endpoint = "your-json-rpc-port"
```

### 5. Build in Release Mode:
```
cargo build --release
```
# Running with systemd
## 1. Create service with name
```
sudo nano /etc/systemd/system/0g-dar.service
```

```
[Unit]
Description=DA Retriever Service
After=network.target

[Service]
User=root
WorkingDirectory=/root/0g-da-retriever
ExecStart=/root/0g-da-retriever/target/release/retriever --config /root/0g-da-retriever/run/config.toml
Restart=always
RestartSec=10
SyslogIdentifier=da-re

[Install]
WantedBy=multi-user.target
```

## 2. Run the service

```
sudo systemctl daemon-reload
sudo systemctl enable 0g-dar.service
sudo systemctl start 0g-dar.service
sudo systemctl status 0g-dar.service
```

**Check logs real-time:**

```
sudo journalctl -f -u 0g-dar.service
```

### Example for the logs
![image](https://github.com/user-attachments/assets/1209f527-6d71-4836-ad8f-bafa1cb667b2)


