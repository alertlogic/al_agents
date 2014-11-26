#!/bin/bash
set -ex

if [[ -z $2 ]]; then
    CHEF_CFG_DIR="/etc/chef/"
else
    CHEF_CFG_DIR=$2
fi

if [[ -z $1 ]]; then
    ## assume this script was invoked from particular cookbook directory
    COOKBOOK_DIR=`pwd`"/.."
else
    COOKBOOK_DIR=$1
fi


mkdir -p ${CHEF_CFG_DIR}

cat << EOF > ${CHEF_CFG_DIR}/solo.rb
cookbook_path   "`echo ${COOKBOOK_DIR}`"
ssl_verify_mode :verify_peer
log_level       :info
solo            true
EOF


if [[ -z ${PROVISION_KEY} ]]; then
    echo '${PROVISION_KEY} env variable must be set'
    exit 401
fi

## ${PROVISION_KEY} must be set. In case of travis.ci it is done in project
## settings.
cat << EOF > ${CHEF_CFG_DIR}/node.json
{
    "alertlogic": {
        "agent": {
            "provision_key": "${PROVISION_KEY}"
        }
    },
    "run_list": "recipe[al_agents::agent]"
}
EOF
chmod 600 ${CHEF_CFG_DIR}/node.json

