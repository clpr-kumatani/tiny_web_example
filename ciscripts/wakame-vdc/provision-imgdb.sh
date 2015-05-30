#!/bin/bash
#
# requires:
#  bash
#  mysqladmin, mysql
#
set -e
set -o pipefail
set -u
set -x

# install mysqld
yum install -y --disablerepo=updates mysql-server

# configure service
svc="mysqld"
chkconfig --list "${svc}"
chkconfig "${svc}" on
chkconfig --list "${svc}"

# start mysqld service
if ! service "${svc}" status; then
  service "${svc}" start
fi

# wait for mysqld to be ready
until mysqladmin -uroot ping; do
  sleep 1
done

# db params
dbname="tiny_web_example"
dbuser="root"
dbacl="10.0.22.%"

# grant db
mysql -u${dbuser} mysql <<EOS
  GRANT ALL PRIVILEGES ON ${dbname}.* TO ${dbuser}@'${dbacl}';
  FLUSH PRIVILEGES;
  SELECT * FROM user WHERE User = '${dbuser}' \G
EOS

# create db
if mysql -u${dbuser} ${dbname} <<< ""; then
  mysqladmin -u${dbuser} drop ${dbname} <<< "Y"
fi
mysqladmin -uroot create ${dbname} --default-character-set=utf8

# stop mysqld service
service "${svc}" stop

# wait for mysqld not to be ready
until ! mysqladmin -uroot ping; do
  sleep 1
done

#
sync
