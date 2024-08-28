#!/bin/bash
path=$0
dir=$(dirname "$path")
cd "$dir" || exit 1
ID=$1
CONTAINER_NAME=android_$ID
LOCAL_DIR=$2
CONTAINER_DIR=$3
VOLUME=$LOCAL_DIR:$CONTAINER_DIR
YQ_KEY=.services.$CONTAINER_NAME.volumes
FORMAT_LINE="$YQ_KEY += [ \"$VOLUME\" ]"
COMPOSE_FILE=../docker-compose.yml
YQ=../utils/yq
if ! $YQ e "$YQ_KEY" "$COMPOSE_FILE" | grep -q "$VOLUME"; then 
    $YQ e -i "$FORMAT_LINE" "$COMPOSE_FILE"
fi