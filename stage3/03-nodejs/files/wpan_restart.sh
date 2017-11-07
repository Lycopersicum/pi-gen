#!/bin/sh

ROOT_DIR=`dirname $0`

systemctl stop otbr-agent-mdns
systemctl stop otbr-agent
systemctl stop wpantund.service

$ROOT_DIR/wpan_reset_usb.sh
sleep 2

systemctl start wpantund.service
sleep 1
$ROOT_DIR/wpan_configure.sh
sleep 1

systemctl start otbr-agent
systemctl start otbr-agent-mdns

