#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -u
set -x

# wait for mysqld to be ready
until mysqladmin -uroot ping; do
  sleep 1
done
