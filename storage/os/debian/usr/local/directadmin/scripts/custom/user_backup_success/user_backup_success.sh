#!/bin/bash
# ----------------------------------------------------------
# Directadmin user_backup_success.sh (User Backup Success)
# This script will check the backup file for corruption that was triggered from DA backup
# It also will auto encrypt the backup file and upload only the encrypted backup to cloud
# ----------------------------------------------------------

# Only run this script if backup directory is /home/$username/backups/*
# This means run only if user backup is triggered.
# For System backup normally directory like this: /backup/*
# We use this check because Admin Level backup also can trigger this script where we don't want
# shellcheck disable=SC2154
DA_USERNAME="${username}"
DA_BACKUP_FILE="${file}"
if grep -q "/home/${DA_USERNAME}/backups/*" <<<"${DA_BACKUP_FILE}"; then
  SCRIPT_PATH="$(dirname "$(readlink -f "$0")")"
  SCRIPT_NAME=$(basename -- "$0")
  MAIL_BIN=$(command -v mail)
  LOG_PATH="${SCRIPT_PATH}/log"
  mkdir -p "${SCRIPT_PATH}/log"
  REPORT_FILE="${LOG_PATH}/${SCRIPT_NAME}.log"
  ADMIN_EMAIL="webmaster@sofibox.com"
  DATE_TIME_NOW="$(date '+%d-%m-%Y_%H-%M-%S')"
  BACKUP_DIR_DTN="${DA_USERNAME}_backup_${DATE_TIME_NOW}"
  BACKUP_SOURCE="/home/${DA_USERNAME}/backups"
  BACKUP_TAR_NAME="${BACKUP_SOURCE}/${BACKUP_DIR_DTN}.tar.gz"
  BACKUP_TAR_NAME_ENCRYPTED="${BACKUP_SOURCE}/${BACKUP_DIR_DTN}.tar.gz.gpg"
  BACKUP_DESTINATION="Earthbox/user_backups/${DA_USERNAME}/${BACKUP_DIR_DTN}/"
  WARN_STATUS="OK"
  ENABLE_BACKUP_ENCRYPTION="yes"
  ENABLE_BACKUP_UPLOAD="yes"
  # Must enable ENABLE_BACKUP_UPLOAD to use this
  REMOVE_BACKUP_AFTER_UPLOAD="no"
  RET_VAL=0
  #env | grep -v pass > "$REPORT_FILE"
  # Sensitive information:
  # Import RCLONE CONFIG FILE
  # For GPG Encryption ID
  USER_ID=arafat@sofibox.com
  # Import RCLONE CONFIG FILE
  RCLONE_SECURE_PATH="/usr/local/maxicode/secure/rclone/"
  echo "[${SCRIPT_NAME}]: Decrypting rclone config file ..." | tee -a "${REPORT_FILE}"
  # Decrypt rclone_pass before continue
  RCLONE_CONFIG_PASS=$(gpg --decrypt "${RCLONE_SECURE_PATH}/rclone_pass")
  RET_VAL=$?
  if [ $RET_VAL = 0 ]; then
    echo "[${SCRIPT_NAME}]: OK, rclone config file decrypted successfully" | tee -a "${REPORT_FILE}"
    export RCLONE_CONFIG_PASS
    # After RCLONE_CONFIG_PASS if decrypted and exported, this ENVIRONMENT variable will be used for the rest of the script
    RCLONE_CONFIG="${RCLONE_SECURE_PATH}/rclone.conf"
    export RCLONE_CONFIG
  else
    WARN_STATUS="WARNING"
    echo "[${SCRIPT_NAME}]: Error, rclone config file decrypting failed. Perhaps passphrase is not cached ?" | tee -a "${REPORT_FILE}"
    ${MAIL_BIN} -s "[${SCRIPT_NAME} | ${WARN_STATUS}]: Admin-Level Backup Operation Report @ ${BOX_HOSTNAME}" ${ADMIN_EMAIL} <"${REPORT_FILE}"
    exit 1
  fi

  # Rename DA backup file name to new file name
  mv "${DA_BACKUP_FILE}" "${BACKUP_TAR_NAME}"
  file="${BACKUP_TAR_NAME}"
  #echo "[${SCRIPT_NAME}]: FILE path is: ${file}" | tee -a "${REPORT_FILE}"
  #check_valid_tar
  echo "[${SCRIPT_NAME}]: Performing user-level backup ..." | tee -a "${REPORT_FILE}"
  echo "[${SCRIPT_NAME}]: Checking backup archive for corruption ... (this may take some time)" | tee -a "${REPORT_FILE}"
  if gzip -t "${file}" &>/dev/null; then
    echo "[${SCRIPT_NAME}]: OK, backup archive file of [$(basename "${file}")] is valid" | tee -a "${REPORT_FILE}"
  else
    echo "[${SCRIPT_NAME}]: Warning, backup file of [$(basename "${file}")] is corrupted" | tee -a "${REPORT_FILE}"
    #rm -f "$f"
    echo "[${SCRIPT_NAME}]: Script is terminated! Please inspect the backup file of [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    WARN_STATUS="WARNING"
    exit 1
  fi
  # encrypt backup file
  if [ "${ENABLE_BACKUP_ENCRYPTION}" == "yes" ]; then
    echo "[${SCRIPT_NAME}]: OK, backup encryption [is set]. Backup encryption is using [GPG method]" | tee -a "${REPORT_FILE}"
    echo "[${SCRIPT_NAME}]: Encrypting backup file of [$(basename "${file}")] as $(basename "${BACKUP_TAR_NAME_ENCRYPTED}") ..." | tee -a "${REPORT_FILE}"
    echo "----------" | tee -a "${REPORT_FILE}"
    gpg --recipient $USER_ID --encrypt "${file}"
    RET_VAL=$?
    echo "----------" | tee -a "${REPORT_FILE}"
    if [ ${RET_VAL} = 0 ]; then
      if [ -f "$BACKUP_TAR_NAME_ENCRYPTED" ]; then
        echo "[${SCRIPT_NAME}]: Successfully encrypted backup file of [$(basename "${file}")] as $(basename "${BACKUP_TAR_NAME_ENCRYPTED}")" | tee -a "${REPORT_FILE}"
        rm -f "$file" #Remove the unencrypted backup
        echo "[${SCRIPT_NAME}]: Unencrypted backup file of [$(basename "${file}")] was deleted" | tee -a "${REPORT_FILE}"
        file=$BACKUP_TAR_NAME_ENCRYPTED
      else
        echo "[${SCRIPT_NAME}]: No encrypted file was created. Something is wrong" | tee -a "${REPORT_FILE}"
      fi
    fi
    if [ ${RET_VAL} -ne 0 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Warning, unable to encrypt backup file of [$(basename "${file}")]. GPG error code is: ${RET_VAL}" | tee -a "${REPORT_FILE}"
      echo "[${SCRIPT_NAME}]: Backup status: [${WARN_STATUS}]" | tee -a "${REPORT_FILE}"
      $MAIL_BIN -s "[${SCRIPT_NAME} | ${WARN_STATUS}]: User-Level Backup Operation Report @ $MYHOSTNAME" ${ADMIN_EMAIL} <"${REPORT_FILE}"
      exit 1
    fi

  else
    echo "[${SCRIPT_NAME}]: Warning, backup encryption is not set" | tee -a "${REPORT_FILE}"
  fi
  #create_backup_dir
  echo "[${SCRIPT_NAME}]: Creating new backup directory in [onedrive] as [${BACKUP_DESTINATION}] ..." | tee -a "${REPORT_FILE}"
  bash -o pipefail -c "rclone mkdir onedrive-backup:${BACKUP_DESTINATION} | tee -a ${REPORT_FILE}"
  RET_VAL=$?
  if [ ${RET_VAL} = 0 ]; then
    echo "[${SCRIPT_NAME}]: OK, new backup folder [${BACKUP_DESTINATION}] created at [onedrive]" | tee -a "${REPORT_FILE}"
  else
    WARN_STATUS="WARNING"
    echo "[${SCRIPT_NAME}]: [${RET_VAL}] Warning, something was wrong while creating directory [${BACKUP_DESTINATION}] at [onedrive]" | tee -a "${REPORT_FILE}"
  fi
  if [ "${ENABLE_BACKUP_UPLOAD}" == "yes" ]; then
    echo "[${SCRIPT_NAME}]: Cloud upload is enabled" | tee -a "${REPORT_FILE}"
    #upload_backup_file (use copy and move with other method to send encrypted file and leave the unencrypted)
    echo "-------------------" | tee -a "${REPORT_FILE}"
    bash -o pipefail -c "rclone copy ${file} onedrive-backup:${BACKUP_DESTINATION} --log-file=${REPORT_FILE} --log-level INFO --stats-one-line -P --stats 2s"
    RET_VAL=$?
    echo "-------------------" | tee -a "${REPORT_FILE}"
    if [ ${RET_VAL} = 0 ]; then
      echo "[${SCRIPT_NAME}]: Success, backup file of [$(basename "${file}")] has been successfully uploaded into [onedrive]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 1 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, syntax or usage error while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 2 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, error not otherwise categorised while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 3 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, directory not found while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 4 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, file not found while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 5 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, temporary error (one that more retires might fix) (Retry errors) while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 6 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, less serious errors (like 461 errors from dropbox) (NoRetry errors) while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 7 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, fatal error (one that more retries won't fix, like account suspended) (Fatal errors) while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 8 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, transfer exceeded - limit set by --max-transfer reached while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    elif [ ${RET_VAL} = 9 ]; then
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, operation successful, but no files transferred while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    else
      WARN_STATUS="WARNING"
      echo "[${SCRIPT_NAME}]: Error, unknown error while performing file upload [$(basename "${file}")]" | tee -a "${REPORT_FILE}"
    fi
    if [ "${REMOVE_BACKUP_AFTER_UPLOAD}" == "yes" ]; then
      rm -f "${file}"
      echo "[${SCRIPT_NAME}]: Backup local file has been removed." | tee -a "${REPORT_FILE}"
    fi
  fi
  echo "[${SCRIPT_NAME} | info]: Backup status: [${WARN_STATUS}]" | tee -a "${REPORT_FILE}"
  echo "===================================================================================="
  $MAIL_BIN -s "[${SCRIPT_NAME} | ${WARN_STATUS}]: Directadmin User-Level Backup Status for [${DA_USERNAME}]" ${ADMIN_EMAIL} <"${REPORT_FILE}"
fi
