This is a personal project that I wrote for server automation to reduce server configuration time. 
The aim of this project is to have everything automated when deploying a new server without wasting a lot of time. 
For example setting up a secured server from scratch with hardened configs might take few days (I've experienced this) but this script will reduce that longer period to about 1 hour with one command! 
I focused a lot of security enhancements in this script for a new server deployment in order to reduce server malicious attack.

# Warning, you should not use this script if you don't know the purpose of this script. This script might contain bug (especially this public version)
There is another private version without ```_public``` name URL that always have the latest code and features.

Running example:

````
maxinet create-server --rebuild-all --backup
````

For example if everything is configured correctly for Directadmin and Linode in maxinet.conf, the above command will configure a new server disk and config in linode, it will then create custom ISO file for Debian, then it will install this operating system.
then do a lot of thing behind ... bla2 bla2 ... (read the code to understand what it does because it is huge to write what it does) ... and finally you will get a fully working server with live websites. So, with only a single command, you will get a clean server with security hardened features

The feature is currently huge to list out.

It might contain bugs for other distributions. This script is fully tested on Debian 10, Debian 11 and with Directadmin custom and auto installation. This script compatible with linode + directadmin

mail-tester.com score:

![mail-tester.com](files/mail_tester.JPG)


ssllabs.com score:

![mail-tester.com](files/ssllabs_test.JPG)


Author: Arafat Ali | Email: arafat@sofibox.com | Personal Blog: arafatx.com
