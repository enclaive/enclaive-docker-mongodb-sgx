# MongoDB-SGX Demonstration
The goal is to show the mongo-sgx database remains encrypted while in use (recall, encryption at rest decrypts the data collection in memory to perform the database operation). To this end, we create a collection in the database and send some data. While we do that and import the data, we wiretap with the database and eavesdrop the file system using `fswatch`. The rationality is that the imported data is encrypted at any moment in time, while vanilla mongodb reveals the data.


## Prerequisites

Install PHP (version 8.0+)
```
sudo add-apt-repository ppa:ondrej/php
suod apt update
sudo apt install php8.1 php8.1-mbstring
```
to create a password list
```bash
php generate_data.php > data.json
```

## Building and Running
```bash
docker compose up -d    # builds demo, mongodb and mongodb-sgx container
```

**Remarks:** Vanilla has a reduced sync-delay of 5 seconds. The sgx version takes 60 seconds to sync the imported data to disk, so you have to wait for a bit, but the output will eventually appear. This is a configuration option and not related to gramine. Compression is disabled for the vanilla showcase to easily recognize data in the output.

## Stopping and Restarting
In which case prune the volume
```
docker compose down
docker container prune -f && docker volume prune -f
```
## Setup

Use two shells in demo:

```bash
docker exec -it demo bash     # shell 1
docker exec -it demo bash     # shell 2
```

## Insert data and trace query (mongodb)
Listen for changes in folder `/vanilla/data`
```bash
# shell 1
fswatch -artux --event=Created /vanilla/data/   # 
```
Create a collection
```bash
# shell 2
mongosh --host mongodb
> db.createCollection('data')
> db.data.insertOne({"test":1})
```
resulting in writing file `/vanilla/data/collection-7--1408183255387016099.wt`.

Now trace the file
```bash
# shell 1
tail -q -c 0 -f /vanilla/data/collection-*.wt | strings
```
and import the password list
```
# shell 2
mongoimport --host mongodb data.json
```

## Insert data and trace query (mongodb-sgx)
Listen for changes in folder `/sgx/data`
```bash
# shell 1
fswatch -artux --event=Created /sgx/data/    
```
Create a collection
```bash
# shell 2
mongosh --host mongodb-sgx
> db.createCollection('data')
> db.data.insertOne({"test":1})
```
resulting in writing file `/sgx/data/collection-7--4217537638384089610.wt`

Now trace the file
```bash
# shell 1
tail -q -c 0 -f /sgx/data/collection-*.wt | strings
```
and import the password list
```
# shell 2
mongoimport --host mongodb-sgx data.json
```
## Remarks
Instead of `strings` we also could use `xxd -c 64`, but it is sometimes harder to find our imported data due to other things also written to this log.

Alternatively simply `grep` a username:

```bash
grep -Ri testUsername /vanilla/ /sgx/
```


