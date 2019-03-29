# bitcoin-core

A docker image for bitcoin-core. The image in the Docker Hub address is: [webfuse/bitcoins - core - Docker] (https://hub.docker.com/r/webfuse/bitcoin-core).

## Tags

- `0.17.1`, `latest` ([0.17.1/Dockerfile](https://github.com/guanzhenxing/blockchain-docker-hub/blob/master/bitcoin/bitcoin-core/0.17.1/Dockerfile))

## How to use this image

You can pull this image:

```shell
docker pull webfuse/bitcoin-core
```

The default tag is `latest`.The most basic use:

```shell
docker run webfuse/bitcoin-core
```

If you want to use a specific Tag, for example 0.17.1:

```shell
docker run webfuse/bitcoin-core:0.17.1
```

This image contains the main binaries from the Bitcoin Core project - ` bitcoind`, `bitcoin-cli` and `bitcoin-tx`. So you can pass any arguments to the image and they will be forwarded to the bitcoind binary:

```shell
docker run webfuse/bitcoin-core \
  -printtoconsole \
  -regtest=1
```

By default,`bitcoind` will store data to dir `~/.bitcoin`.  If you'd like to customize where bitcoin-core stores its data, you must use the `BITCOIN_DIR` environment variable. The directory will be automatically created with the correct permissions for the bitcoin user and bitcoin-core automatically configured to use it.

```shell
docker run --env BITCOIN_DIR='/bitcoin-data' webfuse/bitcoin-core
```

A custom `bitcoin.conf` file can be placed in the mounted data directory. Otherwise, a default bitcoin.conf file will be automatically generated based on environment variables passed to the container:

| name | describe | default |
| ---- | ------- |---- |
| BITCOIN_NETWORK | Options apply to mainnet, testnet and regtest.|  |
| BITCOIN_EXTRA_ARGS | You can pass any arguments.  |  |

You can optionally create a service using docker-compose:

```
bitcoin-core:
  image: webfuse/bitcoin-core
  command:
    -printtoconsole
    -regtest=1
```

or

```
bitcoind:
    image: webfuse/bitcoin-core
    environment:
      BITCOIN_NETWORK: "${testnet}"
      BITCOIN_DATA: /data
      BITCOIN_EXTRA_ARGS: |
        disablewallet=1
        txindex=1
        server=1
        rpcuser=rpcuser
        rpcpassword=rpcpass
        rpcport=43782
        port=39388
        whitelist=0.0.0.0/0
        zmqpubrawblock=tcp://0.0.0.0:28332
        zmqpubrawtx=tcp://0.0.0.0:28333
```

Check if it is running:

```shell
docker ps
docker logs -f bitcoind
```

## The bitcoin-core ports

The default port for bitcoin-core is:

**Mainnet**

- JSON-RPC/REST: 8332
- P2P: 8333

**Testnet**

- Testnet JSON-RPC: 18332
- P2P: 18333

**Regtest**

- JSON-RPC/REST: 18443 (since 0.16+, otherwise 18332)
- P2P: 18444

---

Thanks [ruimarinho/docker-bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core) and [NicolasDorier/docker-bitcoin](https://github.com/NicolasDorier/docker-bitcoin)