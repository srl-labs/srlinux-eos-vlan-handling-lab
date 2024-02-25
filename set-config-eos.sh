#!/bin/bash

# Save the current working directory in a variable
pwd=$(pwd)

# Save the command in a variable
gnmic="docker run --network clab --rm -t -v ${pwd}/configs:/configs ghcr.io/openconfig/gnmic:0.34.3 --config /configs/nodes_eos.yml"

MODE=$1

if [ "$MODE" == "disabled-tagging" ]; then
    REPLACE_FILE=configs/disabled-tagging_eos.yml
fi

if [ "$MODE" == "disabled-tagging-native" ]; then
    REPLACE_FILE=configs/disabled-tagging-native_eos.yml
fi

if [ "$MODE" == "single-tag" ]; then
    REPLACE_FILE=configs/single-tag-10_eos.yml
fi

if [ "$MODE" == "single-tag-range" ]; then
    REPLACE_FILE=configs/single-tag-range-10-15_eos.yml
fi

if [ "$MODE" == "untagged" ]; then
    REPLACE_FILE=configs/untagged_eos.yml
fi

if [ -z "$REPLACE_FILE" ]; then
    echo "Invalid mode. Please use one of the following modes: disabled-tagging,disabled-tagging-native, single-tag, single-tag-range, untagged"
    exit 1
fi

$gnmic set --update-path "cli:"  --update-value "no vlan 2-4094"
$gnmic set --update-path "cli:"  --update-value "default interface ethernet 1"
$gnmic set --update-path "cli:"  --update-value "default interface ethernet 10"
$gnmic set  --request-file ${REPLACE_FILE}