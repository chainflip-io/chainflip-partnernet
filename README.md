# chainflip-partnernet

## Pre-requisites
- Docker (https://docs.docker.com/get-docker/)
- JQ (https://stedolan.github.io/jq/download/)

## Setup

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

    a. Add the `tFLIP` token to your wallet using the following address: `0x1A3960317647f7a9420c7eBB8E0FB1bCDfe4Ca24`

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

> Note: The following commands take a little while to respond because it submits and waits for finality.
#### Broker

Register a broker account:

```bash
curl -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "broker_registerAccount"}' \
    http://localhost:10997
```

Request a swap deposit address:

```bash
curl -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "broker_requestSwapDepositAddress", "params": ["Eth", "Flip","0xabababababababababababababababababababab", 0]}' \
    http://localhost:10997
```

#### LP

Register a broker account:

```bash
curl -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_registerAccount", "params": [0]}' \
    http://localhost:10589
```

Request a liquidity deposit address:

```bash
curl -H "Content-Type: application/json" \
    -d '{"id":1, "jsonrpc":"2.0", "method": "lp_liquidityDeposit", "params": ["Eth"]}' \
    http://localhost:80
```