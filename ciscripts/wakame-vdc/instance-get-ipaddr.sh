#!/bin/bash
#
# Usage:
#  $0 instance_id
#
set -e
set -o pipefail
set -u

## include

## shell params

instance_id="${1}"
: "${instance_id:?"should not be empty"}"

## get the instance's ipaddress

ipaddr="$(
  mussel instance show "${instance_id}" \
  | egrep :address:  \
  | awk '{print $2}' \
  | tr '\n' ','
)"
: "${ipaddr:?"should not be empty"}"

## show the instance

echo ipaddr="${ipaddr%%,}"
