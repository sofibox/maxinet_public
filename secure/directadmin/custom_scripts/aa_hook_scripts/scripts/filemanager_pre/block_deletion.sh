#!/bin/bash
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~="
# Author: Arafat Ali | Email: webmaster@sofibox.com | Website: sofibox.com

SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME=$(basename -- "$0")
DA_HOOK_NAME="$(basename -- "${SCRIPT_PATH}")"

# This script will prevent deletion of certain files or folders

_terminate(){
  echo "---------------------------------------"
  echo ""
  echo "******************** END SCRIPT FROM ${DA_HOOK_NAME}/${SCRIPT_NAME} ********************"
  exit 1
}
# Get variable from environment variables
var_button="${button}"

# If the delete button is selected on public_html, we abort the operation!
if [ "${var_button}" = "delete" ]; then
    if env|grep -m1 -q '=/public_html$' || env|grep -m1 -q '=/domains/*.*/public_html$'; then
        echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}]: You cannot delete your public_html link!"
        _terminate
    fi
fi

exit 0