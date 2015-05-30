#!/bin/bash
#
# Usage:
#  $0 load_balancer_id
#
set -e
set -o pipefail
#set -u

## shell params

load_balancer_id="${1}"
: "${load_balancer_id:?"should not be empty"}"
shift
instance_ids="${@:-""}"
: "${instance_ids:?"should not be empty"}"

## unregister instances from the load_balancer

instance_id=
while [[ "${1:-""}" ]]; do
  instance_id="${1}"
  echo "unregister ${instance_id} from ${load_balancer_id}..." >&2
  eval "$(${BASH_SOURCE[0]%/*}/instance-get-vif.sh "${instance_id}")"
  ${BASH_SOURCE[0]%/*}/load_balancer-unregister-vif.sh "${load_balancer_id}" ${vif} >/dev/null
  shift
done

echo load_balancer_id="${load_balancer_id}"
