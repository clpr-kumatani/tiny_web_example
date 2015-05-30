#!/bin/bash
#
#
set -e
set -o pipefail
set -u
set -x

#

eval "$(
  ${BASH_SOURCE[0]%/*}/create-lbapp.sh
  )"
trap 'mussel load_balancer destroy "${load_balancer_id}"' ERR

eval "$(${BASH_SOURCE[0]%/*}/load_balancer-get-ipaddr.sh "${load_balancer_id}")"

{
  . ${BASH_SOURCE[0]%/*}/retry.sh

  wait_for_port_to_be_ready "${ipaddr_public}" tcp 8080
} >&2

echo load_balancer_id="${load_balancer_id}"
echo ipaddr="${ipaddr}"
echo ipaddr_public="${ipaddr_public}"
echo ipaddr_managed="${ipaddr_managed}"
