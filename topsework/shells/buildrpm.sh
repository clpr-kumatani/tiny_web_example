#!/bin/bash

set -e
set -x
set -o pipefail

RPMROOT=${HOME}/rpmbuild

rpm -ql yum-utils >/dev/null || sudo yum install -y yum-utils

cd ${RPMROOT}/SPECS
pwd
sudo yum-builddep example.spec
rpmbuild -bb example.spec

