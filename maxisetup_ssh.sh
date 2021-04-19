#!/bin/bash
# Do this after transfer this 2 files via SCP
cd /root || exit 1
chmod +x maxisetup
touch maxisetup.log
./maxisetup --setup 2>&1 | tee maxisetup.log
echo ""