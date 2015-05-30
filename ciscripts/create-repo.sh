#!/bin/bash
#
#
set -e 
set -x
set -o pipefail

# check

rpm -ql httpd >/dev/null || sudo yum install -y httpd

/etc/init.d/httpd status >/dev/null || sudo /etc/init.d/httpd start

# create repo
REPO_DIR=/var/www/html/pub
[ -d ${REPO_DIR} ] || sudo mkdir -p ${REPO_DIR}

cd ${HOME}/rpmbuild/RPMS/
sudo rsync -avx . ${REPO_DIR}/

cd ${REPO_DIR}

sudo createrepo .

