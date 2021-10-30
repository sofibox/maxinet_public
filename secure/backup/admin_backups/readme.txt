Note this is the place where you put your directadmin backup.
The script will automatically restore all of this backup if the variable C_DA_DISABLE_USER_BACKUP_RESTORE is set to false
and each of the admin,reseller and user config C_DA_<ROLE>_RESTORE_USER_BACKUP[N] is set to true

The format of the backup should follow the default directadmin backup file format. For example,

Format:
<role>.<creator>.<username>.<file_type>
Example:
admin.root.useradmin.tar.gz

The script also works with some different type of compression formats such as .tar, .tar.gz and .tar.zst
It even supports backup with encryption password like tar.enc, tar.gz.enc, .tar.zst.enc
For backup decryption, at this point it only decrypt backup password set in C_DA_USER_BACKUP_PASSWORD.
If each of backup file has different password, it will not able to decrypt and thus error will occur during restoration.

If restoration is success or failed, it will notify and produce error message

If there is missing backup for a user but this user is defined in config file, you will be prompt to continue or exit
You can always rerun the script to resume.

After restore, it will also auto sync all the DNS record to external DNS

If the config C_DA_DISABLE_USER_BACKUP_RESTORE is not set, or each individual config C_DA_<ROLE>_RESTORE_USER_BACKUP[N] is
set to false, it will create a new user.

Note: Backup restore also will restore SSL certificate for each domain if previous SSL certificate was requested.