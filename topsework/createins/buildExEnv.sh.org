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
if [ -f /tmp/machineimg.list ]; then
    MachineIMG=/tmp/machineimg.list
else
    MachineIMG=/root/createins/machineimg.list
fi
if [ $# -eq 1 ]; then
    MachineIMG=$1
    ExEnvPATHtmp=$1.ExecEnv
else
    ExEnvPATHtmp=/tmp/ExecEnv.list
fi

echo "Machine Image ${MachieIMG}"
echo ${ExEnvPATHtmp}
echo "load Machine Image"
cat ${MachineIMG}
. ${MachineIMG}

DISPNAME=vdc-instance
DEMOIMG=wmi-centos1d64
VIFS=vifs.json
SSHKEYID=ssh-h0tbhpfo
MEMSIZE=512

# DB Server ----------------------
DISPNAME_DB=DB
#DBIMG=wmi-lzyh79yk
##DBIMG=$1
DBIMG=${DB_IMAGE_ID}
echo "DBIMG=>[${DBIMG}]"

# Web Server ---------------------
DISPNAME_WEB=WEB
#WEBIMG=wmi-74qyxxeo
##WEBIMG=$2
WEBIMG=${WEB_IMAGE_ID}
echo "WEBIMG=>[${WEBIMG}]"
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

#*************************************************
# DB Server Create & Set up
#*************************************************
# Create DB Server
instance_id_DB="$(
    sudo mussel instance create \
    --hypervisor kvm \
    --cpu-cores 1 \
    --image-id ${DBIMG} \
    --memory-size ${MEMSIZE} \
    --ssh-key-id ${SSHKEYID} \
    --display-name ${DISPNAME_DB} \
    --vifs ${VIFS} \
    | egrep ^:id: | awk '{print $2}'
)"
echo "new DB Server create!"
echo "${instance_id_DB} is initializing..."

retry_until [[ '"$(mussel instance show "${instance_id_DB}" | egrep -w "^:state: running")"' ]]
echo DBServer_ID="${instance_id_DB}"
echo "DBServer_ID=${instance_id_DB}" > ${ExEnvPATHtmp}

#+ Get IP address
IPADDR_DB="$(
    mussel instance show ${instance_id_DB} | egrep :address: \
    | awk '{print $2}'
)"
echo DBServerIP="${IPADDR_DB}"

#*************************************************
# Web Server Create & Set up
#*************************************************
# Create Web Server
instance_id_WEB="$(
    mussel instance create \
    --hypervisor kvm \
    --cpu-cores 1 \
    --image-id ${WEBIMG} \
    --memory-size ${MEMSIZE} \
    --ssh-key-id ${SSHKEYID} \
    --display-name ${DISPNAME_WEB} \
    --vifs ${VIFS} \
    | egrep ^:id: | awk '{print $2}'
)"
echo "new Web Server create!"
echo "${instance_id_WEB} is initializing..."

retry_until [[ '"$(mussel instance show "${instance_id_WEB}" | egrep -w "^:state: running")"' ]]
echo WebServer_ID="${instance_id_WEB}"
echo "WEBServer_ID=${instance_id_WEB}" >> ${ExEnvPATHtmp}

#+ Get IP address
IPADDR_WEB="$(
    mussel instance show ${instance_id_WEB} | egrep :address: \
    | awk '{print $2}'
)"
echo WEBServerIP="${IPADDR_WEB}"

#+ get VIFID
WEB_VIFS="$(
    mussel instance show ${instance_id_WEB} | egrep :vif_id: \
    | awk '{print $3}'
)"
echo "WEBServer vifid=${WEB_VIFS}"

#--------------------------------------------------
# WEB Server Set Up

${WORKDIR}/instance-wait4ssh.sh ${instance_id_WEB}

echo "modify Startup Scripts"
${SSH} root@${IPADDR_WEB} sed -i \
    -e 's,^#BIND,BIND,' \
    -e 's,^#PORT,PORT,' \
    -e 's,^#UNICORN,UNICORN,' \
    ${WEBAPISUP}
${SSH} root@${IPADDR_WEB} sed -i -e '/^EXAMPLE/a\PATH=\/root\/\.rbenv\/shims:\$PATH' ${WEBAPISUP}
${SSH} root@${IPADDR_WEB} sed -i \
    -e 's,^#BIND,BIND,' \
    -e 's,^#PORT,PORT,' \
    -e 's,^#UNICORN,UNICORN,' \
    ${WEBAPPSUP}
${SSH} root@${IPADDR_WEB} sed -i -e '/^EXAMPLE/a\PATH=\/root\/\.rbenv\/shims:\$PATH' ${WEBAPPSUP}

echo "modify config file"
${SSH} root@${IPADDR_WEB} sed -i -e "s/localhost/${IPADDR_DB}/g" ${WEBAPICONF}
${SSH} root@${IPADDR_WEB} sed -i -e "s/localhost/${IPADDR_DB}/g" ${WEBAPPYAML}

echo "mysqld start up"
${SSH} root@${IPADDR_WEB} service mysqld start

echo "create DB"
${SSH} root@${IPADDR_WEB} mysqladmin create tiny_web_example

echo "create DBTable"
${SSH} root@${IPADDR_WEB} "cd /opt/axsh/tiny-web-example/webapi && /root/.rbenv/shims/bundle exec rake db:up"

echo "Exec Application"
${SSH} root@${IPADDR_WEB} initctl start tiny-web-example-webapi RUN=yes
${SSH} root@${IPADDR_WEB} initctl start tiny-web-example-webapp RUN=yes

#*************************************************
# Load Balancer Create & Set up
#*************************************************
# Create load balancer
instance_id_LB="$(
    mussel load_balancer create \
    --balance-algorithm=leastconn \
    --engine haproxy \
    --instance-port 80 \
    --instance-protocol http \
    --max-connection 1000 \
    --port 80 \
    --protocol http \
    --display-name ${DISPNAME_LB} \
    | egrep ^:id: | awk '{print $2}' )"

echo "new load balancer create!"
echo "${instance_id_LB} is initializing..."


retry_until [[ '"$(mussel load_balancer show "${instance_id_LB}" | egrep -w "^:state: running")"' ]]
echo load_balancer_ID="${instance_id_LB}"
echo "load_balancer_ID=${instance_id_LB}" >> ${ExEnvPATHtmp}

#+ Get IP address
IPADDR_LBtmp="$(
    mussel load_balancer show ${instance_id_LB} | egrep :address: \
    | awk '{print $2}' \
    | tr '\n' ','
)"
IFS=','
set -- $IPADDR_LBtmp
echo IPADDR_LB="$1"

#+ WEB Server add loda balancer
mussel load_balancer register ${instance_id_LB} --vifs ${WEB_VIFS}
