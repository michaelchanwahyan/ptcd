#!/bin/sh
clear
export TZ=Asia/Hong_Kong
docker rm -f sleepy_mew
mem=$(free -g | head -2 | tail -1 | awk -F " " '{print $2}') # if you run to error, set mem to your system memory (in GB unit)
target_mem=$(echo "$mem * 0.9" | bc) # if you run to error, install bc
if [ -z "$target_mem" ]; then
    target_mem=4
fi
docker run -dt \
           --name=sleepy_mew \
           --memory="$target_mem"g \
           ptcd:latest \
           /bin/bash
