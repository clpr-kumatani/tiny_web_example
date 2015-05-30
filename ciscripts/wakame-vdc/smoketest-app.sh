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

: "${APP_HOST:?"should not be empty"}"

#

api_url="http://${APP_HOST}:8080/api/0.0.1/comments"

curl -fs -X POST --data-urlencode display_name='webapi test' --data-urlencode comment='sample message.' ${api_url}
curl -fs -X GET ${api_url}
curl -fs -X GET ${api_url}/1
