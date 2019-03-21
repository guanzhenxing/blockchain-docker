FROM bitcoin-alpine-bin
 
#
# Copy the bitcoin.conf file from
# the build context into the container
#
COPY bitcoin.conf /bitcoin.conf
 
#
# Expose the port for the RPC interface
#
EXPOSE 8332/tcp
 
#
# Start the bitcoin server
#
ENTRYPOINT ["/usr/local/bin/bitcoind"]
CMD ["-conf=/bitcoin.conf", "-regtest", "-rest=1", "-server=1", "-printtoconsole", "-txindex=1"]
