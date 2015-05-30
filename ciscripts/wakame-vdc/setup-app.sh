#!/bin/bash
#
#
set -e
set -o pipefail
set -u

: "${IMAGE_ID:?"should not be empty"}"
: "${YUM_HOST:?"should not be empty"}"
: "${DB_HOST:?"should not be empty"}"

eval "$(
 IMAGE_ID="${IMAGE_ID}" \
 YUM_HOST="${YUM_HOST}" \
  DB_HOST="${DB_HOST}"  \
  ${BASH_SOURCE[0]%/*}/run-app.sh
)"

echo APP_ID="${instance_id}"
echo APP_HOST="${ipaddr}"
