#!/bin/bash
./cf-concourse/scripts/bosh-connect.sh
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
export VAULT_ADDR=https://${IP}:8200
NOTLS="-tls-skip-verify"
STATUS=`vault status ${NOTLS} 2>&1 | tail -1`
if [[ ${STATUS} == "* server is not yet initialized" ]]; then
  vault init ${NOTLS} >vault-keys
  cat vault-keys
fi
SEALED=`vault status ${NOTLS} | grep "^Sealed" | sed s/^.*:\ //`
if [ ${SEALED} == true ]; then
  echo --- Unseal step 1 of 3
  cat vault-keys | grep "Unseal Key 1" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 2 of 3
  cat vault-keys | grep "Unseal Key 2" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 3 of 3
  cat vault-keys | grep "Unseal Key 3" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Authenticating
  cat vault-keys | grep "Token" | sed s/.*Token:\ // | vault auth ${NOTLS} -
fi
./cf-concourse/vault/integrate-concourse.sh
