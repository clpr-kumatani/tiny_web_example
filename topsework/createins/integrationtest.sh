#!/bin/bash

#####################################################
# MACRO
#####################################################
#------------------------------------
# COMMAND
#------------------------------------

#------------------------------------
# Parameters
#------------------------------------
WORKDIR=$HOME/createins
##ExEnvPATHtmp=/tmp/ExEnvPath.$3
if [ $# -eq 1 ]; then
    ExEnvPATHtmp=$1.ExecEnv
else
    ExEnvPATHtmp=/tmp/ExecEnv.list
fi
echo ${ExEnvPATHtmp}

# load Environment for Execution
. ${ExEnvPATHtmp}
echo "instanceID[DB]=${DBServer_ID}"

WEBAPICONF=/opt/axsh/tiny-web-example/spec_integration/config/webapi.conf
#IPADDR_DB="10.0.22.111"
# get DB Server IPaddress
IPADDR_DB="$(
    mussel instance show ${DBServer_ID} | egrep :address: \
    | awk '{print $2}'
)"
echo DBServerIP="${IPADDR_DB}"

##################################################
# main
##################################################
# Work Directry
cd /opt/axsh/tiny-web-example/spec_integration/config
cp -p ${WEBAPICONF}.example ${WEBAPICONF}

echo "modify config file"
sed -i -e "s/localhost/${IPADDR_DB}/g" ${WEBAPICONF}

# Integration Test running
cd /opt/axsh/tiny-web-example/spec_integration
/root/.rbenv/shims/bundle exec rspec ./spec/webapi_integration_spec.rb
