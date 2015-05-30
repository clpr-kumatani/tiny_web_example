#!/bin/bash
#
#
set -e
set -o pipefail
set -u
set -x

# required shell params

: "${YUM_HOST:?"should not be empty"}"
: "${DB_HOST:?"should not be empty"}"

#

eval "$(
  ${BASH_SOURCE[0]%/*}/create-app.sh
  )"
trap 'mussel instance destroy "${instance_id}"' ERR

eval "$(${BASH_SOURCE[0]%/*}/instance-get-ipaddr.sh "${instance_id}")"

{
  ${BASH_SOURCE[0]%/*}/instance-wait4ssh.sh  "${instance_id}"
  ${BASH_SOURCE[0]%/*}/instance-exec.sh      "${instance_id}" \
    YUM_HOST="${YUM_HOST}" \
     DB_HOST="${DB_HOST}"  \
     bash -l < ${BASH_SOURCE[0]%/*}/provision-app.sh
} >&2

{
  . ${BASH_SOURCE[0]%/*}/retry.sh

  wait_for_port_to_be_ready "${ipaddr}" tcp 8080
  wait_for_port_to_be_ready "${ipaddr}" tcp 80
} >&2

echo instance_id="${instance_id}"
echo ipaddr="${ipaddr}"
