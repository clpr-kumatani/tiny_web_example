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
: "${YUM_HOST:?"should not be empty"}"

# git
yum install -y git

# epel
rpm -qa epel-release* | egrep -q epel-release || {
    rpm -Uvh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/i386/epel-release-6-8.noarch.rpm
    sed -i \
	-e 's,^#baseurl,baseurl,' \
	-e 's,^mirrorlist=,#mirrorlist=,' \
	-e 's,http://download.fedoraproject.org/pub/epel/,http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/,' \
	/etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo
    yum install -y ca-certificates
}
yum repolist

# install rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
# setup rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
exec $SHELL -l

# install build require for ruby-build
yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

# install ruby-build
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# install ruby
ruby_version="2.0.0-p598"

rbenv install -v "${ruby_version}"
rbenv rehash
rbenv versions
rbenv global "${ruby_version}"
ruby -v

# install bundler
gem install bundler --no-ri --no-rdoc

# install tiny-web-example.repo
cat <<-EOS > /etc/yum.repos.d/tiny-web-example.repo
[tin-web-example]
name=tiny-web-example
baseurl=http://${YUM_HOST}/pub/
enabled=1
gpgcheck=0
EOS

# show available repo list
yum repolist

# install tiny-web-example.rpm
yum install -y tiny-web-example

## /etc/default/tiny-web-example-webapi
cat <<-'EOS' > /etc/default/tiny-web-example-webapi
	# tiny-web-example
	EXAMPLE_ROOT=/opt/axsh/tiny-web-example
	PATH=/root/.rbenv/shims:$PATH

	# Commnet out to run the vdc init script.
	#RUN=yes

	## rack params
	RACK_ENV=development
	BIND_ADDR=0.0.0.0
	PORT=8080
	UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
	EOS

## /etc/default/tiny-web-example-webapp
cat <<-'EOS' > /etc/default/tiny-web-example-webapp
	# tiny-web-example
	EXAMPLE_ROOT=/opt/axsh/tiny-web-example
	PATH=/root/.rbenv/shims:$PATH

	# Commnet out to run the vdc init script.
	#RUN=yes

	## rack params
	RACK_ENV=development
	BIND_ADDR=0.0.0.0
	PORT=80
	UNICORN_CONF=/etc/tiny-web-example/unicorn-common.conf
	EOS
