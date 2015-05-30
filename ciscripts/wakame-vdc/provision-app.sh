#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -u
set -x

# required shell params

: "${DB_HOST:?"should not be empty"}"

# configure db host
for config in /etc/tiny-web-example/webapi.conf /etc/tiny-web-example/webapp.yml; do
  sed -i "s,localhost,${DB_HOST}," "${config}"
  egrep "${DB_HOST}" "${config}"
done

# setup db
cd /opt/axsh/tiny-web-example/webapi/
bundle exec rake db:up

# start system jobs
initctl start tiny-web-example-webapi RUN=yes
initctl start tiny-web-example-webapp RUN=yes
