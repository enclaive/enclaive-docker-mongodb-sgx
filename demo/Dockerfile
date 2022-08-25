FROM ubuntu:focal

RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg2 wget ca-certificates \
    && wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/mongodb-org-6.0.gpg \
    && echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-6.0.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends mongodb-org-server=6.0.0

RUN apt-get install -y --no-install-recommends mongodb-database-tools mongodb-mongosh
RUN apt-get install -y --no-install-recommends fswatch xxd binutils

ENTRYPOINT [ "/usr/bin/mongod", "--config=/etc/mongod.conf", "--bind_ip=0.0.0.0", "--wiredTigerCollectionBlockCompressor=none", "--syncdelay=5" ]
