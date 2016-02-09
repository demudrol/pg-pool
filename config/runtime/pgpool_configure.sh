#!/bin/bash

# Loop DB env variables and add to the file in an ordered manner
echo "Building database upstreams"

for i in $(seq 0 10);
do
    tmp='DB_'${i}

    # Array
    arr=$(echo ${!tmp} | tr ";" "\n")

    for x in $arr
    do
        sudo printf $x' \n' >> /etc/pgpool/pgpool.conf
    done

    # Nice line break on different dbs]
    sudo printf ' \n' >> /etc/pgpool/pgpool.conf
done

# Restart pgpool
if [ "$1" == "restart" ]; then
    echo "Restarting pgpool"
    sudo supervisorctl restart pgpool
fi
