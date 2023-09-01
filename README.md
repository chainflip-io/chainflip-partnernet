# chainflip-partnernet

## Pre-requisites
- Docker (https://docs.docker.com/get-docker/)
- JQ (https://stedolan.github.io/jq/download/)

## Setup
### Clone the repo

```bash
git clone https://github.com/chainflip-io/chainflip-partnernet.git
cd chainflip-partnernet
```

### Generating Keys

```bash
mkdir -p ./chainflip/keys/lp
mkdir -p ./chainflip/keys/broker
docker run --platform=linux/amd64 --entrypoint=/usr/local/bin/chainflip-node chainfliplabs/chainflip-node:partnernet key generate --output-type=json > chainflip/lp-keys.json
docker run --platform=linux/amd64 --entrypoint=/usr/local/bin/chainflip-node chainfliplabs/chainflip-node:partnernet key generate --output-type=json > chainflip/broker-keys.json
cat chainflip/broker-keys.json | jq -r '.secretSeed' | cut -c 3- > chainflip/keys/broker/signing_key_file
cat chainflip/lp-keys.json | jq -r '.secretSeed' | cut -c 3- > chainflip/keys/lp/signing_key_file
```

### Fund Accounts

1. Get some `tFLIP`

    a. Add the `tFLIP` token to your wallet using the following address: `0x1ea4f05a319a8f779f05e153974605756bb13d4f`

    b. Get in touch with us on [Discord](https://discord.com/channels/824147014140952596/1045323960339935342) and we'll send you some `tFLIP`

2. Get the public key of the Broker or LP account:
```bash
# Broker
cat chainflip/broker-keys.json | jq -r '.ss58Address'

# LP
cat chainflip/lp-keys.json | jq -r '.ss58Address'
```

3. Then head to the [Auctions Web App](https://auctions-partnernet.chainflip.io/nodes)
4. Connect your wallet
5. Click "Add Node"
6. Follow the instructions to fund the account

### Running the APIs

```bash
docker-compose up -d
```

### Interacting with the APIs
You can connect to your local RPC using [PolkadotJS](https://polkadot.js.org/apps/?rpc=ws%3A%2F%2F127.0.0.1%3A9944#/explorer) to see chain events.

> Note: The following commands take a little while to respond because they submit and wait for finality.
#### Broker

Register a broker account:

```bash
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "broker_registerAccount"}' \
    http://localhost:10997 | jq
```

Request a swap deposit address:

```bash
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "broker_requestSwapDepositAddress", "params": ["Eth", "Flip","0xabababababababababababababababababababab", 0]}' \
    http://localhost:10997 | jq
```

#### LP

Register a broker account:

```bash
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_registerAccount", "params": [0]}' \
    http://localhost:10589 | jq
```
Before you request a liquidity deposit address, you need to register an emergency withdrawal address.

```bash
# For Ethereum
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_registerEmergencyWithdrawalAddress", "params": ["Ethereum", "YOUR_ETH_ADDRESS"]}' \
    http://localhost:10589 | jq

# For Polkadot
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_registerEmergencyWithdrawalAddress", "params": ["Polkadot", "YOUR_HEX_ENCODED_DOT_ADDRESS"]}' \
    http://localhost:10589 | jq

# For Bitcoin
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_registerEmergencyWithdrawalAddress", "params": ["Bitcoin", "YOUR_BTC_ADDRESS"]}' \
    http://localhost:10589 | jq
```

After you have registered an emergency withdrawal address, you can request a liquidity deposit address.

```bash
curl -s -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_liquidityDeposit", "params": ["Eth"]}' \
    http://localhost:10589 | jq
```
