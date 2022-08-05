# enclaive-docker-mongodb-sgx

## Running

As `mongod` is currently build from source we do not recommend building the image on your own. This might change in the future, if gramine adds support for things listed under `Notes`.

```bash
docker-compose up
```

## Connecting

Use MongoDB Compass or the MongoDB Shell to connect. No password or authentication required, this is a demo setup.

## Notes

- Logfile is currently broken, see [mongod.conf](mongod.conf)
- Data persistence requires a clean shutdown, as in `db.shutdownServer()`, for the same reason as the logfile
- `HAVE_FTRUNCATE` is disabled during compilation as arbitrary sizes are not yet supported by [gramines encrypted mount](https://github.com/gramineproject/gramine/blob/master/common/src/protected_files/protected_files.c#L1219) / [permalink](https://github.com/gramineproject/gramine/blob/562c639703d56fa5d26b3bed135d31c6a843385f/common/src/protected_files/protected_files.c#L1219)
- Patch removes `flock(2)` call, as it is only used to prevent multiple instances running with the same configuration
- Another patch removes the extraction of process information from `/proc/<pid>/stat`, as it is not implemented in gramine
  - This only creates unnecessary logging of errors once a second and could be ignored
