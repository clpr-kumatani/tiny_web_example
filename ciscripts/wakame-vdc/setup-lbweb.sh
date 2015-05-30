#!/bin/bash
#
#
set -e
set -o pipefail
set -u

: "${APP_ID:?"should not be empty"}"

eval "$(
  ${BASH_SOURCE[0]%/*}/run-lbweb.sh
)"

${BASH_SOURCE[0]%/*}/load_balancer-register-instance.sh "${load_balancer_id}" "${APP_ID}" >&2

echo LDWEB_ID="${load_balancer_id}"
echo LBWEB_HOST="${ipaddr_public}"
