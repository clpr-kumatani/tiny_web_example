#!/bin/bash
#
#
set -e
set -x
set -o pipefail

cd spec_integration

bundle install
cp config/webapi.conf.example config/webapi.conf

if [[ -n "${APP_HOST:-""}" ]]; then
  sed -i s,localhost,${APP_HOST}, config/webapi.conf
fi

bundle exec rspec ./spec/webapi_integration_spec.rb
