#!/bin/bash
VENDOR_ID="257f:0002"
DURATION=2
PORT_NUMBER=$( sudo uhubctl|grep ${VENDOR_ID}|awk '{print($2)}'|sed 's/://' )
sudo uhubctl -p ${PORT_NUMBER} -a 2 -d ${DURATION}
