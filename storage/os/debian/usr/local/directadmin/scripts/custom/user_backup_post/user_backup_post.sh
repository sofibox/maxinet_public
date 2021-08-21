#!/bin/bash

# Directadmin user_backup_post.sh (User Backup Post)
# usage webmod --set user --offline-mode | --online-mode
# Put each user web into online mode
# Author: Arafat Ali | Email: webmaster@sofibox.com

# shellcheck disable=SC2154
DA_USERNAME=${username}
# DA needs full path of the script. using just webmod will not work and product script error
/usr/local/maxicode/maxiweb/maxiweb --set "${DA_USERNAME}" --online-mode

script_name=$(basename -- "$0")
MAIL_BIN="/usr/local/bin/mail"
MYEMAIL="webmaster@sofibox.com"
env >test.txt
$MAIL_BIN -s "[$script_name]: ${script_name^} Report" $MYEMAIL <test.txt
