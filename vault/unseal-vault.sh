#!/bin/bash
./cf-concourse/scripts/bosh-connect.sh
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
echo "We're going to work with ${IP} server"
export VAULT_ADDR=https://${IP}:8200
echo ${VAULT_ADDR} >cf-concourse/vault_addr
NOTLS="-tls-skip-verify"
STATUS=`vault status ${NOTLS} 2>&1 | tail -1`
KEYS=cf-concourse/vault_keys
if [[ ${STATUS} == "* server is not yet initialized" ]]; then
  echo "Initializing vault"
  vault init ${NOTLS} >${KEYS}
  cat ${KEYS}
else
  echo "Server already has been initialized"
fi
SEALED=`vault status ${NOTLS} | grep "^Sealed" | sed s/^.*:\ //`
if [ ${SEALED} == true ]; then
  echo "Server is sealed. Unsealing"
  echo --- Unseal step 1 of 3
  cat vault-keys | grep "Unseal Key 1" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 2 of 3
  cat vault-keys | grep "Unseal Key 2" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 3 of 3
  cat vault-keys | grep "Unseal Key 3" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Authenticating
  cat vault-keys | grep "Token" | sed s/.*Token:\ // >cf-concourse/concourse_token
  cat cf-concourse/concourse_token | vault auth ${NOTLS} -
else
  echo "Server is not sealed"
fi
./cf-concourse/vault/integrate-concourse.sh
