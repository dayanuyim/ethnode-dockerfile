FROM ubuntu:16.04

LABEL version="1.0"
LABEL maintainer="dayanuyim@gmail.com"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --yes software-properties-common
RUN add-apt-repository ppa:ethereum/ethereum
RUN apt-get update && apt-get install --yes geth solc

RUN adduser --disabled-login --gecos "" eth_user

COPY eth_common /home/eth_user/eth_common
RUN chown -R eth_user:eth_user /home/eth_user/eth_common

COPY ROC /etc/localtime
RUN echo "Asia/Taipei" > /etc/timezone

USER eth_user

WORKDIR /home/eth_user

RUN geth init eth_common/genesis.json
RUN { cat eth_common/pass & cat eth_common/pass; } | geth account new

ENTRYPOINT geth --identity node1 --unlock 0 --password eth_common/pass --networkid 160230 --port=30308 --mine --minerthreads 1  --rpc --rpcport 8545 --rpccorsdomain '*' --rpcaddr 0.0.0.0 --rpcapi=db,eth,net,web3,personal,admin console

