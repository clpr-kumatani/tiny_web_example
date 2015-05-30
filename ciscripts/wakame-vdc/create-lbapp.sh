#!/bin/bash
#
# Usage:
#  $0
#
set -e
set -o pipefail
set -u

## shell params

balance_algorithm="leastconn"
engine="haproxy"
max_connection="1000"
instance_port="8080"
instance_protocol="http"
port_maps="8080:http"
display_name="lbapp"

#

if [[ -f ${BASH_SOURCE[0]%/*}/config/${display_name} ]]; then
  . ${BASH_SOURCE[0]%/*}/config/${display_name}
fi

## create a load_balancer

${BASH_SOURCE[0]%/*}/gen-musselrc.sh

load_balancer_id="$(
  mussel load_balancer create \
   --balance-algorithm "${balance_algorithm}" \
   --engine            "${engine}"            \
   --instance-port     "${instance_port}"     \
   --instance-protocol "${instance_protocol}" \
   --max-connection    "${max_connection}"    \
   --display-name      "${display_name}"      \
   $(
    IFS=,
    for i in ${port_maps}; do
      echo --port     ${i%%:*}
      echo --protocol ${i##*:}
    done
   ) \
  | egrep ^:id: | awk '{print $2}'
)"

: "${load_balancer_id:?"load_balancer is empty"}"
echo "${load_balancer_id} is initializing..." >&2

trap "mussel load_balancer destroy \"${load_balancer_id}\"" ERR

## wait for the load_balancer to be running

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel load_balancer show "${load_balancer_id}" | egrep -w "^:state: running")"' ]]
echo load_balancer_id="${load_balancer_id}"
