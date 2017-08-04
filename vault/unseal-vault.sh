#!/bin/bash
./cf-concourse/bosh-connect.sh
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
export VAULT_ADDR=https://${IP}:8200
NOTLS="-tls-skip-verify"
STATUS=`vault status ${NOTLS} 2>&1 | tail -1`
if [[ ${STATUS} == "* server is not yet initialized" ]]; then
  KEYS=`vault init ${NOTLS}`
  echo ${KEYS}
fi
SEALED=`vault status ${NOTLS} | grep "^Sealed" | sed s/^.*:\ //`
if [ ${SEALED} == true ]; then
  echo ${KEYS} | grep "Unseal Key 1" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo ${KEYS} | grep "Unseal Key 2" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo ${KEYS} | grep "Unseal Key 3" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
fi
echo ${KEYS} | grep "Token" | sed s/.*Token:\ // | vault auth ${NOTLS} -

