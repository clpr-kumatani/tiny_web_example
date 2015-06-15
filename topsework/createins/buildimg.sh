#!/bin/bash
#######################################################
# Instance Image build
#######################################################

#####################################################
# MACRO
#####################################################
#------------------------------------
# COMMAND
#------------------------------------
SSH="/usr/bin/ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i/root/createins/mykeypair"
RBENV=/root/.rbenv/bin/rbenv
GEM=/root/.rbenv/shims/gem

#------------------------------------
# Parameters
#------------------------------------
WORKDIR=$HOME/createins

if [ $# -eq 1 ]; then
    ExEnvPATHtmp=$1
else
    ExEnvPATHtmp=/tmp/machineimg.list
fi
echo "imageID file is ${ExEnvPATHtmp}"

DISPNAME=vdc-instance
DEMOIMG=wmi-centos1d64
VIFS=vifs.json
SSHKEYID=ssh-h0tbhpfo
MEMSIZE=512

# DB Server ----------------------
DISPNAME_DB=DBimg

# Web Server ---------------------
DISPNAME_WEB=WEBimg
REPOSFILE=/etc/yum.repos.d/tiny-web-example.repo

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
    --image-id ${DEMOIMG} \
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

#+ Get IP address
IPADDR_DB="$(
    mussel instance show ${instance_id_DB} | egrep :address: \
    | awk '{print $2}'
)"
echo DBServerIP="${IPADDR_DB}"

#-------------------------------------------------------
# DB Server Set up
#
${WORKDIR}/instance-wait4ssh.sh ${instance_id_DB}

echo "Installing MySQL"
${SSH} root@${IPADDR_DB} yum install -y mysql-server

echo "MySQL Start"
${SSH} root@${IPADDR_DB} service mysqld start
${SSH} root@${IPADDR_DB} chkconfig --list mysqld
${SSH} root@${IPADDR_DB} chkconfig mysqld on
${SSH} root@${IPADDR_DB} chkconfig --list mysqld
${SSH} root@${IPADDR_DB} mysql -uroot mysql <<EOS
GRANT ALL PRIVILEGES ON tiny_web_example.* TO root@'10.0.22.%';
FLUSH PRIVILEGES;
SELECT * FROM user WHERE User = 'root' \G
EOS
echo "MySQL create DB"
${SSH} root@${IPADDR_DB} mysqladmin -uroot create tiny_web_example --default-character-set=utf8

#-------------------------------------------------------
# Instance Image Create
#
echo "DB Power OFF"
mussel instance poweroff ${instance_id_DB}
retry_until [[ '"$(mussel instance show "${instance_id_DB}" | egrep -w "^:state: halted")"' ]]

echo "DB backup image createing"
image_id_DB="$(
    mussel instance backup ${instance_id_DB} \
    | egrep :image_id: | awk '{print $2}'
)"

echo "new DB Server Image create!"
echo "${image_id_DB} is creating..."

retry_until [[ '"$(mussel image show "${image_id_DB}" | egrep -w "^:state: available")"' ]]
echo DB_IMAGE_ID="${image_id_DB}"
echo "DB_IMAGE_ID=${image_id_DB}" > ${ExEnvPATHtmp}

#*************************************************
# Web Server Create & Set up
#*************************************************
# Create Web Server
echo "WEB Server Creating!!"
instance_id_WEB="$(
    mussel instance create \
    --hypervisor kvm \
    --cpu-cores 1 \
    --image-id ${DEMOIMG} \
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

${SSH} root@${IPADDR_WEB} yum install -y git

echo "epel-release install"
${SSH} root@${IPADDR_WEB} rpm -ivh http://ftp.jaist.ac.jp/pub/Linux/Fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

echo "rbenv install"
${SSH} root@${IPADDR_WEB} git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

echo "setup rbenv"
${SSH} root@${IPADDR_WEB} echo 'export PATH="$HOME/.rbenv/bin:$PATH" >> ~/.bash_profile'
${SSH} root@${IPADDR_WEB} echo 'eval "$(/root/.rbenv/bin/rbenv init -)" >> ~/.bash_profile'
##echo "SHELL reload"
##${SSH} root@${IPADDR_WEB} exec $SHELL -l

echo "Install Package for ruby-build"
${SSH} root@${IPADDR_WEB} yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel

echo "Install ruby-build"
${SSH} root@${IPADDR_WEB} git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

echo "Install Ruby"
${SSH} root@${IPADDR_WEB} ${RBENV} install -v 2.0.0-p598

echo "rbenv reload"
${SSH} root@${IPADDR_WEB} ${RBENV} rehash

echo "Ruby Version Setup"
${SSH} root@${IPADDR_WEB} ${RBENV} global 2.0.0-p598

echo "Install budler"
${SSH} root@${IPADDR_WEB} ${GEM} install bundler --no-ri --no-rdoc

echo "create repofile"
${SSH} root@${IPADDR_WEB} curl -fsSkL \
https://raw.githubusercontent.com/axsh/tiny_web_example/master/rpmbuild/tiny-web-example.repo \
-o /etc/yum.repos.d/tiny-web-example.repo

echo "baseurl edit..."
${SSH} root@${IPADDR_WEB} sed -i -e "s/127.0.0.1/10.0.22.100/g" ${REPOSFILE}

echo "tiny_web_example install"
${SSH} root@${IPADDR_WEB} yum install -y tiny-web-example

# 2015-06-12 Append
${SSH} root@${IPADDR_WEB} yum install -y nginx mysql-server mysql-devel
${SSH} root@${IPADDR_WEB} "cd /opt/axsh/tiny-web-example/webapi && /root/.rbenv/shims/bundle install"
${SSH} root@${IPADDR_WEB} "cd /opt/axsh/tiny-web-example/frontend && /root/.rbenv/shims/bundle install"

#-------------------------------------------------------
# Instance Image Create
#
mussel instance poweroff ${instance_id_WEB}
retry_until [[ '"$(mussel instance show "${instance_id_WEB}" | egrep -w "^:state: halted")"' ]]

image_id_WEB="$(
    mussel instance backup ${instance_id_WEB} \
    | egrep :image_id: | awk '{print $2}'
)"

echo "new WEB Server Image create!"
echo "${image_id_WEB} is creating..."

retry_until [[ '"$(mussel image show "${image_id_WEB}" | egrep -w "^:state: available")"' ]]
echo WEB_IMAGE_ID="${image_id_WEB}"
echo "WEB_IMAGE_ID=${image_id_WEB}" >> ${ExEnvPATHtmp}

# terminate instance
mussel instance destroy ${instance_id_DB}
mussel instance destroy ${instance_id_WEB}

