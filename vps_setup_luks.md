# This documentation is deprecated, new version will be released.
version: 0.1

# How to setup OS disk encryption using Linode

We will use Volume Storage to attach as a home directory so that it can grow easily

# Disk setup

1) First create 2 Disks storage with the following information:

First disk:

Disk Label: Boot_Disk
Type: RAW | Size: 1024 MB
Note this disk will be used to store installation file. It's useful space for putting custom rescue disk in the future

Second disk:
Disk Label: OS_Disk
Type: RAW | Size: [the rest of the size left]
Note this disk will be used as the main operating system, this one should be encrypted

2) Create a volume for mounting home directory:

First volume:

Volume Label: Home_Volume
Region: Singapore (Same like the linode region)
Size: 20GiB (initial size can grow later)
Attached to: server.sofibox.com

3) Now create 2 configuration profiles

First config:

Config Label: Boot_Config
VM Mode: Paravirtualization
Kernel: Direct Disk
/dev/sda: OS_Disk
/dev/sdb: Home_Volume
/dev/sdc: Boot_Disk
Root Device: /dev/sdc
Turn off all Filesystem/Boot Helpers

Second config:

Config Label: OS_Config
VM Mode: Paravirtualization
Kernel: Direct Disk
/dev/sda: OS_Disk
/dev/sdb: Home_Volume
Root Device: /dev/sda
Turn off all Filesystem/Boot Helpers

# Download Distribution

We will download a small debian distribution and put it inside Boot_Disk. We will use this disk to install Debian on OS_Disk

1. Enter into rescue mode in Linode Finnix. Make sure to select Boot_Disk as the first partition for /dev/sda
   
2. When you have entered into the terminal type this command to download net installer for Debian:

wget http://ftp.debian.org/debian/dists/stable/main/installer-amd64/current/images/netboot/mini.iso
dd if=mini.iso of=/dev/sda

3. After that, type command poweroff tu turn off linode

# Boot Installer and Install Debian

1. Now Boot the config installer Boot_Config. Open up console in graphic mode (using glish not lish)
2. You will see a GUI installation for Debian is ready for you. Follow the instruction. For partition this is the guide:

1. Language -> English | Country -> Other -> Asia -> Malaysia | Country Local Setting -> United States | Keymap -> American English

2. Press Enter + L to configure network manually

3. Enter Ipv4 address | enter gateway | enter 3 name servers (all this can get from maxisetup.conf)

4. For archive mirror country select Singapore because it's the nearest country in Malaysia and has the best internet speed. select deb.debian.org

5. Leave blank for proxy

# Setup user and Partition

Press ALT + L to manually setup this

USER
----
1. Enter root password (initial strong root password). Use browser Edit -> Paste Function

2. Enter Name and username for SSH guy including its password (refer maxisetup.conf)

PARTITION
---------
1. For setting up partition use manual, you will see 2 Drivers sda and sdb

sdb is your installation disk (do not delete this)
sda is your operating system disk (you need to make sure it's not used). If it has spaced used, delete it

2. click on sda disk to initialize the disk and create empty partition (free space). You will see a free space

3. create a new primary partition (beginning of the disk) called boot with 1GB space. make sure it's mount to /boot file type should be ext4

Remember that this boot partition must have setting bootable flag = on. click go back

4. Click Configure encrypted volumes -> Yes -> Create encrypted volumes (select sda - which said FREE) -> Continue

5. Click go back and Yes to format the partition as encrypted partition - > click Finish, wait for the encryption ( this will take a long time ) 
   
6. Enter the LUKS encryption passphrase

7. Click on configure logical disk manager -> yes to write system partition

8. Create a volume group called box1, then select the encrypted LUKs disk /dev/mapper/sdaX_crypt

Now create logical volume for this LVM with the following details (sample server with 80GB disk and 4GB RAM):

# Specification for 80GB | 4GB RAM | Debian
#1 15 GB | FS: Ext4 | Mount Point: / | Label: root | Bootable flag: on | (optional for performance: noatime, nodiratime)
#2 2GB | ext4 /tmp | mount with: nosuid, noexec (optional for performance: noatime, nodiratime but need to check if compatible)
#3 4GB | swap (for swap) | logical partition
#4 60GB (or the rest space left) | ext4 /home | mount with: nosuid | put home at the end so it can be extend easily without modifying above partitions

Click Go back and make sure all information from the partition follow the above:





This tutorial is written by Arafat Ali | arafat@sofibox.com

