#!/bin/bash
# This is a sample template how the script should terminate

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

echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}]: This abc.sh. No termination"

exit 0