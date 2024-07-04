# Zero Gravity (0G) Testnet Service

Welcome to the Zero Gravity (0G) Testnet Service! This repository provides all the necessary information about the various endpoints available for interacting with the Zero Gravity testnet. Below you will find details and links for the RPC, API, and other services.

## Services

### 1. gRPC Node
- **Endpoint:** https://0grpc.tech-coha05.xyz
- **Description:** This node provides gRPC services for the Zero Gravity testnet.

### 2. Key-Value Node
- **Endpoint:** https://0g-kv-node.tech-coha05.xyz
- **Description:** This node provides key-value storage services for the Zero Gravity testnet.
  
### 3. Storage Node
- **Endpoint:** https://0g-storage-node.tech-coha05.xyz
- **Description:** This node provides storage services for the Zero Gravity testnet.

### 4. Testnet RPC
- **Endpoint:** https://0g-testnet-rpc.tech-coha05.xyz
- **Description:** This endpoint provides RPC services for interacting with the Zero Gravity testnet.

### 5. API Testnet
- **Endpoint:** https://0g-api-testnet.tech-coha05.xyz
- **Description:** This endpoint provides API services for interacting with the Zero Gravity testnet.

## How to Use

To interact with the Zero Gravity testnet, you can use the provided endpoints. Each endpoint corresponds to a specific service, such as key-value storage, gRPC, storage, RPC, and API services.

### Example Request
Here is an example of how you can use one of the endpoints to make a request:
```
curl -X POST https://0g-testnet-rpc.tech-coha05.xyz -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
This request retrieves the list of validators from the Zero Gravity testnet using the API endpoint.

### Example API Request
Here is an example of how you can use the API endpoint to get a list of validators:
```
curl -X GET https://0g-api-testnet.tech-coha05.xyz/cosmos/staking/v1beta1/validators
```
## Fresh peers from my node
```
PEERS=$(curl -sS https://0grpc.tech-coha05.xyz/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}' | paste -sd, -)
echo $PEERS
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml
```
## Explorer
**Dashboard:** https://explorer.tech-coha05.xyz/0g
