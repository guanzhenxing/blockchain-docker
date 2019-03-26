#!/bin/bash
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "bitcoind" ]; then

    echo ">>>>>>>>>>> >>>>>>>>>>> >>>>>>>>>>> "
    echo "$1"
    echo "$(echo "$1" | cut -c1)"
    echo ">>>>>>>>>>> >>>>>>>>>>> >>>>>>>>>>> "


    mkdir -p "$BITCOIN_DATA"

    CONFIG_PREFIX=""
	if [[ "${BITCOIN_NETWORK}" == "regtest" ]]; then
		CONFIG_PREFIX=$'regtest=1\n[regtest]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "testnet" ]]; then
		CONFIG_PREFIX=$'testnet=1\n[test]'
	fi
	if [[ "${BITCOIN_NETWORK}" == "mainnet" ]]; then
		CONFIG_PREFIX=$'mainnet=1\n[main]'
	fi

    if [[ ! -s "$BITCOIN_DATA/bitcoin.conf" ]]; then
	cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
      ${CONFIG_PREFIX}
      printtoconsole=1
      rpcallowip=::/0
      ${BITCOIN_EXTRA_ARGS}
	EOF
        chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"
    fi

    # ensure correct ownership and linking of data directory
    # we do not update group ownership here, in case users want to mount
    # a host directory and still retain access to it
    chown -R bitcoin "$BITCOIN_DATA"
    ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
    chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

    exec gosu bitcoin "$@"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  echo
  exec gosu bitcoin "$@"
fi

exec "$@"
