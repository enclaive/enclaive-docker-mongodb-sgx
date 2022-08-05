#!/bin/bash

/aesmd.sh

set -e

gramine-sgx-get-token --output mongodb.token --sig mongodb.sig
gramine-sgx mongodb
