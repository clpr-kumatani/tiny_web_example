#!/bin/bash

#####################################################
# MACRO
#####################################################
#------------------------------------
# COMMAND
#------------------------------------
SSH="/usr/bin/ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i/root/createins/mykeypair"

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
##. /tmp/ExEnvPath.jenkins-child-26
. ${ExEnvPATHtmp}
echo "instanceID[DB]=${DBServer_ID}"
echo "instanceID[WEB]=${WEBServer_ID}"
echo "instanceID[LB]=${load_balancer_ID}"

DISPNAME=vdc-instance
DEMOIMG=wmi-centos1d64
VIFS=vifs.json
SSHKEYID=ssh-h0tbhpfo
MEMSIZE=256

# DB Server ----------------------
DISPNAME_DB=DB
#DBIMG=wmi-lzyh79yk
DBIMG=$1

# Web Server ---------------------
DISPNAME_WEB=WEB
#WEBIMG=wmi-74qyxxeo
WEBIMG=$2
WEBAPISUP=/etc/default/tiny-web-example-webapi
WEBAPPSUP=/etc/default/tiny-web-example-webapp
WEBAPICONF=/etc/tiny-web-example/webapi.conf
WEBAPPYAML=/etc/tiny-web-example/webapp.yml

# Load Balancer ------------------
DISPNAME_LB=lb80

##################################################
# main
##################################################
# load scripts
. ${WORKDIR}/retry.sh

# Work Directry
cd /root/createins/

#+ get VIFID
WEB_VIFS="$(
    mussel instance show ${WEBServer_ID} | egrep :vif_id: \
    | awk '{print $3}'
)"
echo "WEBServer vifid=${WEB_VIFS}"

#--------------------------------------------------
# Unregistring vifid
mussel load_balancer unregister ${load_balancer_ID} --vifs ${WEB_VIFS}

#--------------------------------------------------
# destroy load balancer
mussel load_balancer destroy ${load_balancer_ID}

#--------------------------------------------------
# destroy WEB Server
mussel instance destroy ${WEBServer_ID}

#--------------------------------------------------
# destroy DB Server
mussel instance destroy ${DBServer_ID}

echo "destroy finish!"
