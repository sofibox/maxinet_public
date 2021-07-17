#!/bin/bash
# TODO will make the name of the script dynamic. Do not use 'maxinet'
# This script will only shutdown the current server that has script in it
cd /root || exit 1
chmod +x maxinet
touch maxinet.log
./maxinet --shutdown-server 2>&1 | tee maxinet.log
echo ""