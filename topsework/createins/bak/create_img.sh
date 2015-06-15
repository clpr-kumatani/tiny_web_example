#!/bin/bash

WORKDIR=$HOME/createins

DISPNAME=vdc-instance
DEMOIMG=wmi-centos1d64
VIFS=vifs.json
SSHKEYID=ssh-h0tbhpfo
MEMSIZE=256

# Work Directry
cd /root/createins/


instance_id="$(
mussel instance create \
--hypervisor kvm \
--cpu-cores 1 \
--image-id ${DEMOIMG} \
--memory-size ${MEMSIZE} \
--ssh-key-id ${SSHKEYID} \
--display-name ${DISPNAME} \
--vifs ${VIFS} \
| egrep ^:id: | awk '{print $2}' )"

echo "${instance_id} is initializing..."
