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

## create an instance

mussel instance poweron "${instance_id}" >/dev/null
echo "${instance_id} is starting..." >&2

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel instance show "${instance_id}" | egrep -w "^:state: running")"' ]]
echo instance_id="${instance_id}"
