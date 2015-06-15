#!/bin/bash

IMAGEID=`echo $1`
echo ${IMAGEID}

mussel instance create \
--hypervisor kvm \
--cpu-cores 1 \
--image-id ${IMAGEID} \
--memory-size 256 \
--ssh-key-id ssh-h0tbhpfo \
--display-name vdc-instance \
--vifs vifs.json
