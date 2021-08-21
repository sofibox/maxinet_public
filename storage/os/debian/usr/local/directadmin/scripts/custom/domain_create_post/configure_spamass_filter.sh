#!/bin/bash
# This executes when a new domain is added and generates the filter.conf file containing some default settings.
if [ "${domain}" != "" ]; then
  FCONF=/etc/virtual/${domain}/filter.conf
  if [ ! -s "${FCONF}" ]; then
    echo 'high_score=10' > "${FCONF}"
    echo 'high_score_block=yes' >> "${FCONF}"
    # shellcheck disable=SC2086
    echo 'where=inbox' >> ${FCONF}
    chown mail:mail "${FCONF}"

    echo "action=rewrite&value=filter&user=${username}" >> /usr/local/directadmin/data/task.queue
  fi
fi
exit 0