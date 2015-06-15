#!/bin/bash

set -e
set -x
set -o pipefail

RPMROOT=${HOME}/rpmbuild
WEBROOT=/var/www/html/pub

# direcry check
[ -d ${WEBROOT} ] || sudo mkdir -p ${WEBROOT}

# RPM Package Copy
cd ${RPMROOT}/RPMS/
pwd
sudo rsync -avx . ${WEBROOT}/

# make yum repositry
cd ${WEBROOT}
pwd
sudo createrepo .
