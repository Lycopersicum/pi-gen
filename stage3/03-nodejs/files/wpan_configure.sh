#!/bin/sh

SCRIPT_DIR=/home/pi/.node-red/scripts/
OT_XPANID=`cat ${SCRIPT_DIR}wpan_network_xpanid`
OT_NETWORK_KEY=`cat ${SCRIPT_DIR}wpan_network_key`
OT_NETWORK_NAME=`cat ${SCRIPT_DIR}wpan_network_name`
OT_PASSPHRASE=`cat ${SCRIPT_DIR}wpan_commissioning_credential`
OT_PSKC=`${SCRIPT_DIR}pskc $OT_PASSPHRASE $OT_XPANID $OT_NETWORK_NAME`

wpanctl setprop Network:XPANID $OT_XPANID
wpanctl setprop Network:Key $OT_NETWORK_KEY
wpanctl setprop Network:PSKc $OT_PSKC
wpanctl form -c 11 $OT_NETWORK_NAME
