#!/bin/bash
# ===============================================
# This script file was automatically generated by maxinet
# Author: Arafat Ali | Email: admin@sofibox.com | Web: sofibox.com
# ===============================================
# Using --setup will trigger setup script from maxinet
cd /root || exit 1
chmod +x maxinet
touch maxinet.log
./maxinet --setup 2>&1 | tee maxinet.log
# Put 2 times exit below to safely exit the script if the first exit is not executed
return 0
return 0
