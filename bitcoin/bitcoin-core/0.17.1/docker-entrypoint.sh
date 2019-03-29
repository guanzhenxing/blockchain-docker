#!/bin/bash
set -e

BITCOIN_CONF=${BITCOIN_DIR}/bitcoin.conf

if [ $(echo "$1" | cut -c1) == "-" ]; then
  echo "$@: assuming arguments for bitcoind"
  set -- bitcoind "$@"
fi

if [ "$1" == "bitcoind" ]; then

  mkdir -p "${BITCOIN_DIR}"
  chmod 700 "${BITCOIN_DIR}"
	chown -R bitcoin:bitcoin "${BITCOIN_DIR}"

  echo "$0: setting data directory to $BITCOIN_DIR"

  # Init bitcoin.conf
  if [[ ! -f "${BITCOIN_CONF}" ]]; then
    touch "${BITCOIN_CONF}"
  fi
  if [[ ! -s "${BITCOIN_CONF}" ]]; then
    CONFIG_PREFIX=""
    if [ "${BITCOIN_NETWORK}" == "regtest" ]; then
      CONFIG_PREFIX=$'regtest=1\n[regtest]'
    fi
    if [ "${BITCOIN_NETWORK}" == "testnet" ]; then
      CONFIG_PREFIX=$'testnet=1\n[test]'
    fi
    if [ "${BITCOIN_NETWORK}" == "mainnet" ]; then
      CONFIG_PREFIX=$'mainnet=1\n[main]'
    fi

cat <<-EOF > "${BITCOIN_CONF}"
${CONFIG_PREFIX}
${BITCOIN_EXTRA_ARGS}
EOF

    chown bitcoin:bitcoin "${BITCOIN_CONF}"
  fi

  set -- "$@" -datadir="${BITCOIN_DIR}"
fi

if [ "$1" == "bitcoind" ] || [ "$1" == "bitcoin-cli" ] || [ "$1" == "bitcoin-tx" ]; then
  echo
  exec gosu bitcoin "$@"
fi

echo
exec "$@"
