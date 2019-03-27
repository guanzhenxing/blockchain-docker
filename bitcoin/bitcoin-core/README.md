# bitcoin-core

bitcoin-core 的 docker 镜像。镜像在 Docker Hub 上的地址为： [webfuse/bitcoin-core-docker](https://hub.docker.com/r/webfuse/bitcoin-core-docker)

## Tags

- `0.17.1`, `0.17`, `latest` ([0.17.1/Dockerfile](https://github.com/guanzhenxing/blockchain-docker-hub/blob/master/bitcoin/bitcoin-core/0.17.1/Dockerfile))

## 怎么使用

```shell
docker pull webfuse/bitcoin-core-docker
```

使用最新的版本：

```shell
docker run webfuse/bitcoin-core-docker
```

使用指定的版本，以下代码中的 `<Version>` 请替换为相应的版本，如： 0.17.1

```shell
docker run webfuse/bitcoin-core-docker:<Version>
```

使用指定的参数：

```shell
docker run webfuse/bitcoin-core-docker \
  -printtoconsole \
  -regtest=1
```

查看是否运行的方法：

```shell
docker ps
```

或

```shell
 docker logs -f bitcoind
```



---
https://github.com/ruimarinho/docker-bitcoin-core/blob/master/0.17/docker-entrypoint.sh

https://github.com/NicolasDorier/docker-bitcoin