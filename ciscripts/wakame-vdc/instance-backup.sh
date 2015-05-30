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

image_id="$(
  mussel instance backup "${instance_id}" \
  | egrep ^:image_id: | awk '{print $2}'
)"
: "${image_id:?"should not be empty"}"
echo "${image_id} is creating..." >&2

## wait for the image to be available

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel image show "${image_id}" | egrep -w "^:state: available")"' ]]
echo image_id="${image_id}"
