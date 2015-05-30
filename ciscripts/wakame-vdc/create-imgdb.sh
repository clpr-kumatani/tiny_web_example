#!/bin/bash
#
set -e
set -o pipefail
set -u

# vifs

network_id="nw-demo1"
security_group_id="sg-cicddemo"
vifs="vifs.json"

# instance-specific parameter

cpu_cores="1"
hypervisor="kvm"
memory_size="512"
image_id="wmi-centos1d64"
display_name="imgdb"
ssh_key_id="ssh-cicddemo"

#

if [[ -f ${BASH_SOURCE[0]%/*}/config/${display_name} ]]; then
  . ${BASH_SOURCE[0]%/*}/config/${display_name}
fi

## create an instance

${BASH_SOURCE[0]%/*}/gen-musselrc.sh
vifs="${vifs}" network_id="${network_id}" security_group_id="${security_group_id}" \
 ${BASH_SOURCE[0]%/*}/gen-vifs.sh

instance_id="$(
  mussel instance create \
   --cpu-cores    "${cpu_cores}"    \
   --hypervisor   "${hypervisor}"   \
   --image-id     "${image_id}"     \
   --memory-size  "${memory_size}"  \
   --ssh-key-id   "${ssh_key_id}"   \
   --vifs         "${vifs}"         \
   --display-name "${display_name}" \
  | egrep ^:id: | awk '{print $2}'
)"
: "${instance_id:?"should not be empty"}"
echo "${instance_id} is initializing..." >&2

trap 'mussel instance destroy "${instance_id}"' ERR

## wait for the instance to be running

. ${BASH_SOURCE[0]%/*}/retry.sh

retry_until [[ '"$(mussel instance show "${instance_id}" | egrep -w "^:state: running")"' ]]
echo instance_id="${instance_id}"
