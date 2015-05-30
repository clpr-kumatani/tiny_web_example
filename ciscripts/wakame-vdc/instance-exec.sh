#!/bin/bash
#
# Usage:
#  $0 instance_id
#
set -e
set -o pipefail
set -u

## include

function ssh() {
  $(type -P ssh) -o 'StrictHostKeyChecking no' -o 'UserKnownHostsFile /dev/null' ${@}
}

## shell params

ssh_user="root"
ssh_key="demokeypair"

instance_id="${1}"
: "${instance_id:?"should not be empty"}"

## get the instance's ipaddress

ipaddr="$(
  mussel instance show "${instance_id}" \
  | egrep -w :address: | awk '{print $2}'
)"
: "${ipaddr:?"should not be empty"}"

## ssh to the instance

chmod 600 "${ssh_key}"

shift
ssh "${ssh_user}@${ipaddr}" -i "${ssh_key}" "${@}"
