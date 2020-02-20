#!/bin/bash -eu

# Start BaseX
/usr/local/bin/basexhttp &

# Wait until it has started up.
sleep 5

# Import the data
cd /usr/src/index

python3 load-db-from-github.py "$1" "$2" "$3" "$4"

/usr/local/bin/basexhttp stop