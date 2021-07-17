# This readme is deprecated. Will update soon

Ths is powerful script to manage server installation. 
This script is currently compatible with linode server (might add digitalocean or amazonaws later)

Fully support Directadmin

For example:

When triggering ./maxisetup --init-server init-all rebuild-iso

1) It will create a linode server from scratch (removing any disks configs)
....
   
more than 100 more features ...

The feature is currently huge to list out. You can see the sample installation log output (maxisetup.log) to see what it can do

============================================================

Without creating a server from scratch (assume server is accessible with root):

Usage:

Rename maxisetup.conf.sample to maxisetup.conf, fill in your settings, then place
this file in the same path for maxisetup. Then chmod +x maxisetup -> run

./maxisetup

Installation might ask you to reboot, or it will reboot automatically (depends on the config file) but you can resume the installation where you left off.

Author: Arafat Ali | Email: arafat@sofibox.com | Personal Blog: arafatx.com

Note: A public version of git repo for maxicode will be publish. It's currently using private repo to get the latest maxicode binary.
