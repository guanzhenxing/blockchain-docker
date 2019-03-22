FROM phusion/baseimage:0.11

ENV HOME /root

# init baseimage-docker
CMD ["/sbin/my_init"]

RUN groupadd -r bitcoin && useradd -r -m -g bitcoin bitcoin
RUN apt-get update -y \
  && apt-get install -y  -qq --no-install-recommends curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BITCOIN_VERSION 0.17.1
ENV PATH /opt/bitcoin-${BITCOIN_VERSION}/bin:$PATH

RUN curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/SHA256SUMS.asc \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${BITCOIN_VERSION}/bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc

# create data directory
ENV BITCOIN_DATA /data
RUN mkdir "$BITCOIN_DATA" \
	&& chown -R bitcoin:bitcoin "$BITCOIN_DATA" \
	&& ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin \
	&& chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

VOLUME /data


COPY docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8332 8333 18332 18333 18443 18444

CMD ["bitcoind"]

# finish, clean apt.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*