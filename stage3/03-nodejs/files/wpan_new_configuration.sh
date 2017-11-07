#!/bin/sh

CONFIG_ROOT=/home/pi/.node-red/scripts

XPANID=`head -c 64 /dev/urandom | sha256sum -b | head -c 16`
NETWORK_NAME=RPi-`head -c 64 /dev/urandom | sha256sum -b | head -c 4`

echo -n $XPANID > $CONFIG_ROOT/wpan_network_xpanid
echo -n $NETWORK_NAME > $CONFIG_ROOT/wpan_network_name

# Use /dev/random as cold-started device may not have a lot of entropy
head -c 64 /dev/random | sha256sum -b | head -c 32 > $CONFIG_ROOT/wpan_network_key
head -c 64 /dev/random | sha256sum -b | base64 | head -c 12 > $CONFIG_ROOT/wpan_commissioning_credential
