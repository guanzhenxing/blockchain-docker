FROM phusion/baseimage:0.11

ENV HOME /root

LABEL MAINTAINER="Jesen Kwan <guan.zhenxing@foxmail.com>"

# init baseimage-docker
CMD ["/sbin/my_init"]

ARG BITCOIN_VERSION=0.17.1

ENV BITCOIN_DIR=/home/bitcoin/.bitcoin
ENV PATH=/opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH


RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin

RUN set -ex \
    && apt-get update \
    && apt-get install -qq --no-install-recommends ca-certificates dirmngr gosu gpg wget procps \
    && rm -rf /var/lib/apt/lists/*

RUN set -ex \
    && BITCOIN_ARCHIVE=bitcoin-${BITCOIN_VERSION}-$(uname -m)-linux-gnu.tar.gz \
    && cd /tmp \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_ARCHIVE} \
    && wget -q https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
    && wget -q https://bitcoin.org/laanwj-releases.asc \
    && SHA256=`grep "${BITCOIN_ARCHIVE}" SHA256SUMS.asc | awk '{print $1}'` \
    && echo "$SHA256 ${BITCOIN_ARCHIVE}" | sha256sum -c - \
    && gpg --no-tty --import ./laanwj-releases.asc \
    && gpg --no-tty --verify SHA256SUMS.asc \
    && tar -xzf ${BITCOIN_ARCHIVE} -C /usr/local --strip-components=1 --exclude=*-qt \
    && rm -rf /tmp/* \
    && bitcoind --version

# clean apt.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8332 8333 18332 18333 18443 18444

COPY docker-entrypoint.sh /usr/local/bin/docker-bitcoind-start.sh

ENTRYPOINT ["/usr/local/bin/docker-bitcoind-start.sh"]

CMD ["bitcoind"]