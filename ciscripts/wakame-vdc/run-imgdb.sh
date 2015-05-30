#!/bin/bash
#
#
set -e
set -o pipefail
set -u
set -x

eval "$(
  ${BASH_SOURCE[0]%/*}/create-imgdb.sh
)"

trap 'mussel instance destroy "${instance_id}"' ERR

eval "$(${BASH_SOURCE[0]%/*}/instance-get-ipaddr.sh "${instance_id}")"

{
  ${BASH_SOURCE[0]%/*}/instance-wait4ssh.sh  "${instance_id}"
  ${BASH_SOURCE[0]%/*}/instance-exec.sh      "${instance_id}" < ${BASH_SOURCE[0]%/*}/provision-imgdb.sh
} >&2

echo instance_id="${instance_id}"
echo ipaddr="${ipaddr}"
