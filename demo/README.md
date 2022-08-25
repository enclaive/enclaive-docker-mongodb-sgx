# Running

```bash
php generate_data.php > data.json
docker-compose up -d
```

# Demonstrating

Use two shells in demo:

```bash
docker-compose exec demo bash
docker-compose exec demo bash
```

```bash
# first
fswatch -artux --event=Created /sgx/data/
fswatch -artux --event=Created /vanilla/data/

# second
mongosh --host sgx
> db.createCollection('data')
> db.data.insertOne({"test":1})

mongosh --host vanilla
> db.createCollection('data')
> db.data.insertOne({"test":1})
```

The file should be located somewhere at `/sgx/data/collection-7--4217537638384089610.wt`. Same goes for `/vanilla/data/collection-7--1408183255387016099.wt`.

We can now watch the file as we import our data:

```bash
# first
tail -q -c 0 -f /sgx/data/collection-*.wt     | strings
tail -q -c 0 -f /vanilla/data/collection-*.wt | strings

# second
mongoimport --host sgx     data.json
mongoimport --host vanilla data.json
```

Instead of `strings` we also could use `xxd -c 64`, but it is sometimes harder to find our imported data due to other things also written to this log.

Or simply do a `grep`:

```bash
grep -Ri testUsername /vanilla/ /sgx/
```

# Notes

Vanilla has a reduced sync-delay of 5 seconds. The sgx version takes 60 seconds to sync the imported data to disk, so you have to wait for a bit, but the output will eventually appear. This is a configuration option and not related to gramine.

Compression is disabled for the vanilla showcase to easily recognize data in the output.
