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

## backup an instance

eval "$(
  ${BASH_SOURCE[0]%/*}/instance-stop.sh   "${instance_id}" >&2
  ${BASH_SOURCE[0]%/*}/instance-backup.sh "${instance_id}"
  ${BASH_SOURCE[0]%/*}/instance-start.sh  "${instance_id}" >&2
)"

echo image_id="${image_id}"
