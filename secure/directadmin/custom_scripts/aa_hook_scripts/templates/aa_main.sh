#!/bin/bash
# =~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~=~="
# Author: Arafat Ali | Email: webmaster@sofibox.com | Website: sofibox.com
# This is directadmin universal main script to manage hook script execution in order
# It will automatically run the script at aa_hook_scripts/da_hook_name/<list_of_script>.sh here in order
# The order list can be defined in each hook script options.conf
# Readme at custom/aa_hook_scripts/readme.md

SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
SCRIPT_NAME=$(basename -- "$0")
DA_HOOK_NAME="$(basename -- "${SCRIPT_PATH}")"
AA_SCRIPT_PATH="/usr/local/directadmin/scripts/custom/aa_hook_scripts"
AA_OPTIONS_CONF="${AA_SCRIPT_PATH}/aa_options.conf"
AA_DA_HOOK_SCRIPT_PATH="${AA_SCRIPT_PATH}/scripts/${DA_HOOK_NAME}"
AA_DA_HOOK_OPTIONS_CONF="${AA_DA_HOOK_SCRIPT_PATH}/options.conf"
EXECUTION_TIME=$(date +"%T.%6N")
RUN_COUNT=1

# =================== #
# START FUNCTION LIST #
check_return_code() {
  local retval
  retval="$1"
  if [[ "${retval}" -eq 0 ]]; then
    return 0
  else
    exit 1
    echo "===================== SCRIPT IS TERMINATED DUE TO ERROR ====================="
  fi
}

check_path() {
  local paths
  paths="$*"
  for path in ${paths}; do
    if [ -f "${path}" ]; then
      :
      # echo "[${SCRIPT_NAME}]: OK, the file path [ ${path} ] exists"
    elif [ -d "${path}" ]; then
      :
      # echo "[${SCRIPT_NAME}]: OK, the directory path [ ${path} ] exists"
    elif [ -L "${path}" ]; then
      :
      # echo "[${SCRIPT_NAME}]: OK, the symlink path [ ${path} ] exists"
    elif [ -S "${path}" ]; then
      :
      # echo "[${SCRIPT_NAME}]: OK, the socket path [ ${path} ] exists"
    else
      echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}]: Error, the path [ ${path} ] does not exist!"
      exit 1
    fi
  done
}

# END FUNCTION LIST #
# ================= #

# source from aa_hook_scripts/aa_options.conf
if [ -s "${AA_OPTIONS_CONF}" ]; then
  source "${AA_OPTIONS_CONF}"
else
  echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}]: Error, the config file ${AA_OPTIONS_CONF} does not exist!"
  exit 1
fi

# we then check whether this hook should be enabled
IS_HOOK_ENABLED=$(echo "${AA_ENABLE_HOOKS[@]}" | grep "${DA_HOOK_NAME}")

# Check whether to separate log or use multi log
if [[ "${AA_ENABLE_GLOBAL_HOOK_LOG^^}" == "YES" || "${AA_ENABLE_GLOBAL_HOOK_LOG^^}" == "TRUE" || "${AA_ENABLE_GLOBAL_HOOK_LOG}" == "1" ]]; then
  REPORT_FILE="${AA_SCRIPT_PATH}/all_hook_scripts.log"
else
  REPORT_FILE="${AA_DA_HOOK_SCRIPT_PATH}/${DA_HOOK_NAME}_${SCRIPT_NAME}.log"
fi

touch "${REPORT_FILE}"

# check whether to disable file reporting completely
if [[ ! ("${AA_ENABLE_HOOK_LOG^^}" = "YES" || "${AA_ENABLE_HOOK_LOG^^}" = "TRUE" || "${AA_ENABLE_HOOK_LOG}" = "1") ]]; then
  REPORT_FILE=/dev/null
fi

if [ -n "${IS_HOOK_ENABLED}" ]; then

  check_path "${AA_DA_HOOK_SCRIPT_PATH}"

  # source from aa_hook_scripts/scripts/da_hook_name/options.conf
  if [ -s "${AA_DA_HOOK_OPTIONS_CONF}" ]; then
    source "${AA_DA_HOOK_OPTIONS_CONF}"
  else
    echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}]: Error, the config file ${AA_DA_HOOK_OPTIONS_CONF} does not exist!"
    exit 1
  fi

  # This is the main script that will manage which script to execute in order
  {
    echo ""
    echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}][${EXECUTION_TIME}]:" >>"${REPORT_FILE}"
    echo ""
    echo "******************** START MAIN SCRIPT ${DA_HOOK_NAME}/${SCRIPT_NAME} ********************"
    # DA script environment variables
    echo ""
    echo "----------- START DA ENV VARIABLES ---------"
    env
    echo "----------- END DA ENV VARIABLES -----------"
    echo ""

    echo ""

    # Run each predefined script
    for RUN_SCRIPT_NAME in ${RUN_HOOK_SCRIPT_LIST[*]}; do
      echo "${RUN_COUNT}) START calling script at ${AA_DA_HOOK_SCRIPT_PATH}/${RUN_SCRIPT_NAME}"
      check_path "${AA_DA_HOOK_SCRIPT_PATH}/${RUN_SCRIPT_NAME}"
      chmod +x "${AA_DA_HOOK_SCRIPT_PATH}/${RUN_SCRIPT_NAME}"
      echo ""
      echo "        start output"
      echo ""
      echo "---------------------------------------"
      "${AA_DA_HOOK_SCRIPT_PATH}/${RUN_SCRIPT_NAME}"
      check_return_code "$?"
      echo "---------------------------------------"
      echo ""
      echo "        end output"
      echo ""
      echo "${RUN_COUNT}) END calling script at ${AA_DA_HOOK_SCRIPT_PATH}/${RUN_SCRIPT_NAME}"
      echo ""
      ((RUN_COUNT++))
      # Run next script
    done

    echo "******************** END MAIN SCRIPT ${DA_HOOK_NAME}/${SCRIPT_NAME} ********************"
  } >>"${REPORT_FILE}"
else
  # Optional, we don't need to output this if hook is not enabled
  echo "[${DA_HOOK_NAME}->${SCRIPT_NAME}][${EXECUTION_TIME}]: Skipped, this hook is not enabled in ${AA_OPTIONS_CONF}" >>"${REPORT_FILE}"
  exit 0
fi
