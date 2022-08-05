# patched mongodb
FROM ubuntu:jammy AS mongodb

COPY ./build-packages.txt ./packages.txt

RUN apt-get update \
    && xargs -a packages.txt -r apt-get install -y --no-install-recommends \
    && pip3 install types-pyyaml "psutil<=5.8.0" \
    && rm -rf /var/lib/apt/lists/*

COPY ./mongod.diff /

RUN git clone --branch=r6.0.0 --depth=1 https://github.com/mongodb/mongo /mongo/ \
    && cd /mongo/ \
    && git apply /mongod.diff \
    && python3 buildscripts/scons.py DESTDIR=/app/mongo install-mongod --ssl --disable-warnings-as-errors \
        --use-system-pcre --use-system-snappy --use-system-stemmer --use-system-tcmalloc \
        --use-system-libunwind --use-system-yaml --use-system-zlib --use-system-zstd \
    && strip /app/mongo/bin/mongod \
    && rm -rf /mongo/

# final stage
FROM enclaive/gramine-os:jammy-7e9d6925

RUN apt-get update \
    && apt-get install -y --no-install-recommends libstemmer0d libsnappy1v5 libyaml-cpp0.7 libpcrecpp0v5 libgoogle-perftools4 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app/

RUN adduser --system --no-create-home mongodb \
    && addgroup --system mongodb \
    && adduser mongodb mongodb \
    && mkdir -p /var/lib/mongodb /var/log/mongodb \
    && chown -R mongodb:mongodb /var/lib/mongodb /var/log/mongodb

COPY --from=mongodb /app/mongo/ /app/mongo/
COPY ./mongodb.manifest.template ./entrypoint.sh ./mongod.conf /app/

RUN gramine-argv-serializer "/app/mongod" "--config=/app/mongod.conf" > ./argv \
    && gramine-manifest -Darch_libdir=/lib/x86_64-linux-gnu \
        -Dapp_uid=$(id -u mongodb) -Dapp_gid=$(id -g mongodb) \
        mongodb.manifest.template mongodb.manifest \
    && gramine-sgx-sign --key "$SGX_SIGNER_KEY" --manifest mongodb.manifest --output mongodb.manifest.sgx

VOLUME /data/ /logs/

EXPOSE 27017/tcp

ENTRYPOINT [ "/app/entrypoint.sh" ]
