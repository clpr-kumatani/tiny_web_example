#!/bin/bash

set -e
set -x
set -o pipefail

rpm -ql yum-utils >/dev/null || sudo yum install -y yum-utils

commit_hasg=$(git log HEAD -n 1 --pretty=format:"%h")
committer_datetime=$(date --date="$(git log $(commit_hash) -n 1 --pretty=format:"%cd" --date=iso)" +%Y%m%d%H%M%S)
release_id=${committer_datetime}git${commit_hash}
echo ${release_id}

sudo yum-builddep ./rpmbuild/SPECS/tiny-web-example.spec
rpmbuild -bb ./rpmbuild/SPECS/tiny-web-example.spec --define "build_id ${release_id}"
