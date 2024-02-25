#!/bin/bash

# Save the current working directory in a variable
pwd=$(pwd)

# Save the command in a variable
gnmic="docker run --network clab --rm -t -v ${pwd}/configs:/configs ghcr.io/openconfig/gnmic:0.34.3 --config /configs/nodes_srl.yml"

MODE=$1

if [ "$MODE" == "disabled-tagging" ]; then
    REPLACE_FILE=configs/disabled-tagging_srl.yml
fi

if [ "$MODE" == "single-tag" ]; then
    REPLACE_FILE=configs/single-tag-10_srl.yml
fi

if [ "$MODE" == "single-tag-range" ]; then
    REPLACE_FILE=configs/single-tag-range-10-15_srl.yml
fi

if [ "$MODE" == "untagged" ]; then
    REPLACE_FILE=configs/untagged_srl.yml
fi

if [ -z "$REPLACE_FILE" ]; then
    echo "Invalid mode. Please use one of the following modes: disabled-tagging, single-tag, single-tag-range, untagged"
    exit 1
fi

#$gnmic ${srl} set --update-path / --update-file ${REPLACE_FILE}
$gnmic set --delete "/network-instance[name=bridge-1]/interface[name=*]"
$gnmic set --delete "/interface[name=ethernet-1/1]/subinterface[index=*]"
$gnmic set --delete "/interface[name=ethernet-1/10]/subinterface[index=*]"
$gnmic set --update-path "/interface[name=ethernet-1/1]/vlan-tagging" --update-value "false"
$gnmic set --update-path "/interface[name=ethernet-1/10]/vlan-tagging" --update-value "false"
$gnmic set --update-path / --update-file ${REPLACE_FILE}