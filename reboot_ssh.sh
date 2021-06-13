#!/bin/bash
# TODO will make the name of the script dynamic. Do not use 'maxisetup'
# This script will only shutdown the current server that has script in it
cd /root || exit 1
chmod +x maxisetup
touch maxisetup.log
./maxisetup --shutdown-server 2>&1 | tee maxisetup.log
echo ""