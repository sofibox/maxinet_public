#!/bin/bash
# Do this after transfer this 2 files via SCP
cd /root || exit 1
chmod +x maxinet
touch maxinet.log
./maxinet --setup 2>&1 | tee maxinet.log
echo ""