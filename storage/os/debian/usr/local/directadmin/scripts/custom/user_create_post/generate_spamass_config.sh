#!/bin/bash
# https://forum.directadmin.com/threads/enable-spamassassin-for-all-users.46983/#post-308277
# This executes when a new user is created and generates the user_prefs file containing some default settings.

if [ "$spam" = "ON" ]; then
  DIR=/home/$username/.spamassassin
  mkdir -p "$DIR"
  UP=$DIR/user_prefs
  if [ ! -s "${UP}" ]; then
    echo 'required_score 5.0' > "${UP}"
    echo 'rewrite_header subject ***SPAM***' >> "${UP}"
    echo 'report_safe 0' >> "${UP}"
    chown "$username":"$username" "${UP}"
    chmod 644 "${UP}"
  fi
  chown "${username}":mail "$DIR"
  chmod 771 "$DIR"
fi
exit 0