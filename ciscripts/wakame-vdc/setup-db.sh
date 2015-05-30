#!/bin/bash
#
#
set -e
set -o pipefail
set -u

: "${IMAGE_ID:?"should not be empty"}"

eval "$(
 IMAGE_ID="${IMAGE_ID}" \
  ${BASH_SOURCE[0]%/*}/run-db.sh
)"

echo DB_ID="${instance_id}"
echo DB_HOST="${ipaddr}"
