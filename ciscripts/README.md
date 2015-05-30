## Image Build

シェルスクリプトに下記内容を定義してください。

```
#!/bin/bash
#
#
set -e
set -o pipefail
set -u
set -x
cd ciscripts

WRITE_FILE=${WORKSPACE}/${BUILD_TAG} IMAGE_ID=${image_id} YUM_HOST=${yum_host} ./image-build.sh
```

## JenkinsCI

シェルジョブに下記内容を定義して下さい。
なお、`APP_IMAGE_ID`と`DB_IMAGE_ID`には、それぞれ新規作成したマシンイメージIDで置き換えて下さい。

```
#!/bin/bash
#
#
set -e
set -o pipefail
set -u
set -x

cd ciscripts
ls -l

ipaddr="$(< /metadata/meta-data/local-ipv4)"

APP_IMAGE_ID="wmi-********" \
 DB_IMAGE_ID="wmi-********" \
    YUM_HOST="${ipaddr}" \
 ./web3layers-ci.sh
```
