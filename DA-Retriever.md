
# Hardware Requirement
> **Hardware Requirements**
> 
> - **RAM:** 8 GB
> - **CPU:** 2 cores
> - **Bandwidth:** 100 MBps for Download/Upload


# Installation

## 1. Install Dependencies:
```sudo apt-get update
sudo apt-get install cmake build-essential protobuf-compiler
```
## 2. Install Rust:
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
## 3. Clone the Source Code:
```
git clone https://github.com/0glabs/0g-da-retriever.git
cd 0g-da-retriever
```
# Configuration (Updating)

# Build in Release Mode:
```
cargo build --release
```
# Running with systemd
## 1. Create service
Create service name "DA-re"
```
sudo nano /etc/systemd/system/da-re.service
```

```
[Unit]
Description=DA Retriever Service
After=network.target

[Service]
User=root
ExecStart=/root/0g-da-retriever/target/release/retriever --config /root/0g-da-retriever/run/config.toml
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=da-re

[Install]
WantedBy=multi-user.target
```
## 2. Run the service

```
sudo systemctl daemon-reload
sudo systemctl enable da-re.service
sudo systemctl start da-re.service
sudo systemctl status da-re.service
```

**Check logs real-time:**

```sudo journalctl -f -u da-re.service```
