#!/bin/bash
#
#
set -e
set -x
set -o pipefail

## check mysql-server

rpm -ql mysql-server >/dev/null || sudo yum install -y mysql-server
rpm -ql mysql-devel  >/dev/null || sudo yum install -y mysql-devel

/etc/init.d/mysqld status >/dev/null || sudo /etc/init.d/mysqld start

# create database
yes | mysqladmin -uroot drop tiny_web_example || :
mysqladmin -uroot create tiny_web_example

# bundle install
cd webapi

bundle show >/dev/null || bundle install

# rake db:up
cp config/webapi.conf.example config/webapi.conf
bundle exec rake db:up

# exec unit test
cp spec/webapi.conf.example spec/webapi.conf
bundle exec rspec ./spec/comment_spec.rb

