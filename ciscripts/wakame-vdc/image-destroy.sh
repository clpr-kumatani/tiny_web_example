#!/bin/bash
#
# Usage:
#  $0 image_id
#
set -e
set -o pipefail
set -u

## shell params

image_id="${1}"
: "${image_id:?"should not be empty"}"

## main

mussel image destroy "${image_id}" >/dev/null
echo image_id="${image_id}"
