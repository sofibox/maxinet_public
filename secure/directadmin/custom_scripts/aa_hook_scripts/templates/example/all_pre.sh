#!/bin/bash
SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME=$(basename -- "$0")
DA_HOOK_NAME="all_pre"
REPORT_FILE="${SCRIPT_PATH}/${DA_HOOK_NAME}.log"

touch "${REPORT_FILE}"
{
echo ""
echo "----------- DA ENV VARIABLES START ---------"
env
echo "------------ DA ENV VARIABLES END ----------"
echo ""
} >> "${REPORT_FILE}"