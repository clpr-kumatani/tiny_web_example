#!/bin/bash
#
# Usage:
#  $0 instance_id
#
set -e
set -o pipefail
set -u

## shell params

instance_id="${1}"
: "${instance_id:?"should not be empty"}"

## wait...

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel instance show "${instance_id}" | egrep -w "^:state: running")"' ]]

## get the instance's ipaddress

ipaddr="$(
  mussel instance show "${instance_id}" \
  | egrep :address: \
  | awk '{print $2}' \
  | tr '\n' ','
)"
: "${ipaddr:?"should not be empty"}"
ipaddr="${ipaddr%%,}"

## wait...

{
  wait_for_network_to_be_ready "${ipaddr}"
  wait_for_sshd_to_be_ready    "${ipaddr}"
} >&2
echo ipaddr="${ipaddr}"
