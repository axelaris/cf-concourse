#!/bin/bash
./cf-concourse/scripts/bosh-connect.sh
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
echo "=== We're going to work with ${IP} server"
export VAULT_ADDR=https://${IP}:8200
export KEYS=keys/vault_keys
export NOTLS="-tls-skip-verify"
echo ${VAULT_ADDR} >keys/vault_addr
vault status ${NOTLS}
if [ $? == 1 ]; then
  echo "=== Initializing vault"
  vault init ${NOTLS} >${KEYS}
  cat ${KEYS}
else
  echo "=== Server already has been initialized"
fi
vault status ${NOTLS}
if [ $? == 2 ]; then
  echo "=== Server is sealed. Unsealing"
  echo --- Unseal step 1 of 3
  cat ${KEYS} | grep "Unseal Key 1" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 2 of 3
  cat ${KEYS} | grep "Unseal Key 2" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Unseal step 3 of 3
  cat ${KEYS} | grep "Unseal Key 3" | sed s/^.*:\ // | xargs vault unseal ${NOTLS}
  echo --- Authenticating
  cat ${KEYS} | grep "Token" | sed s/.*Token:\ // >cf-concourse/concourse_token
  cat cf-concourse/concourse_token | vault auth ${NOTLS} -
  ./cf-concourse/vault/integrate-concourse.sh
else
  echo "=== Server is not sealed"
fi
