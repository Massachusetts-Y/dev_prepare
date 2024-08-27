#!/bin/bash

while true; do
    for container in $(docker ps --format '{{.Names}}' | awk '/^android_/ {print $0}'); do
        docker exec $container sh -c "$(cat /usr/bin/android_dev_prepare.sh)"
        echo "[$(date)]" "$container" prepare dev success
    done
    sleep 10
done
    

