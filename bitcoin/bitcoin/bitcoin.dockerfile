FROM alpine:3.7 as build

#
# 安装所有的依赖
#
RUN apk update && apk add git \ 
                          make \
                          file \
                          autoconf \
                          automake \ 
                          build-base \
                          libtool \
                          db-c++ \
                          db-dev \
                          boost-system \
                          boost-program_options \
                          boost-filesystem \ 
                          boost-dev \ 
                          libressl-dev \ 
                          libevent-dev 

#
# 拉取代码
#
RUN git clone https://github.com/bitcoin/bitcoin --branch v0.15.0 --single-branch

#
# 构建
#
RUN (cd bitcoin  && ./autogen.sh && \
                      ./configure --disable-tests \
                      --disable-bench --disable-static  \
                      --without-gui --disable-zmq \ 
                      --with-incompatible-bdb \
                      CFLAGS='-w' CXXFLAGS='-w' && \
                      make -j 4 && \
                      strip src/bitcoind && \
                      strip src/bitcoin-cli && \
                      strip src/bitcoin-tx && \
                      make install )


# FROM alpine:3.7

# #
# # 拷贝到新容器
# #
# COPY --from=build /usr/local/bin/bitcoind /usr/local/bin
# COPY --from=build /usr/local/bin/bitcoin-cli /usr/local/bin

# #
# # 安装所有的依赖
# #
# RUN apk update && apk add boost boost-filesystem \
#             boost-program_options \
#             boost-system boost-thread busybox db-c++ \
#             libevent libgcc libressl2.6-libcrypto \ 
#             libstdc++ musl

# #
# # 将bitcoin.conf文件拷贝到容器中
# #
# COPY bitcoin.conf /bitcoin.conf

# #
# # 开启rpc端口
# #
# EXPOSE 18332/tcp

# #
# # 开启 bitcoin server
# #
# ENTRYPOINT ["/usr/local/bin/bitcoind"]
# CMD ["-conf=/bitcoin.conf", "-rest=1", "-server=1", "-printtoconsole", "-txindex=1"]