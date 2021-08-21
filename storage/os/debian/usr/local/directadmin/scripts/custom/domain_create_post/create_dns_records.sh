#!/bin/bash
# Do not use this
exit 0

# This to assume that DA is already in SSL m
script_path="$(dirname "$(readlink -f "$0")")"
script_name=$(basename -- "$0")
# For debugging purpose this file is not encrypted but it must be encrypted!
source /usr/local/maxicode/maxipass/secure/da/da.conf
directadmin_conf="/usr/local/directadmin/conf/directadmin.conf"
da_ssl=$(sed -n 's/^ssl=//p' ${directadmin_conf})
# TODO make this auto select whether to use https or http
if [[ "${da_ssl}" == "1" ]]; then
  ssl="https"
else
  ssl="http"
fi
api_username="${API_USERNAME}"
api_password="${API_PASSWORD}"
api_client="${username}"
domain=${domain}
data="domain=${domain}&type=TXT&name=_domainkey&value=o%3D%7E%3B+r%3Dwebmaster%40${domain}&ttl=3600&affect_pointers=yes&json=yes&action=add"
command="CMD_DNS_CONTROL"
method="POST"
query=$(curl --request "${method}" --user "${api_username}|${api_client}":"${api_password}" --data "${data}" "${ssl}://${BOX_HOSTNAME_FQDN}:${DA_PORT}/${command}")

echo "---"
# DA API doesn't have fixed status. Some API can return different kind of success messages:
echo "Status: ${query} | status=0 means success or any success message"
#echo "The name of this script is: ${script_name}"
#echo "==========="
# env | grep -v pass > "${script_name}.env"
#env >"${script_path}/${script_name}.env"
#echo "==========="
echo "The script ${script_name} has finished executed"
