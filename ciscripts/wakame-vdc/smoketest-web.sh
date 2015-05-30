#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -u
set -x

# required shell params

: "${WEB_HOST:?"should not be empty"}"

#

curl -fs -X GET http://${WEB_HOST}/
