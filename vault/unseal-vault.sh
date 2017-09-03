#!/bin/bash
echo `cat vault/addr` vault >> /etc/hosts 
echo `cat vault/addr` > keys/vault_addr
export VAULT_ADDR="https://vault:8200"
export KEYS=keys/vault_keys
vault status
if [ $? == 1 ]; then
  echo "=== Initializing vault"
  vault init >${KEYS}
  cat ${KEYS}
else
  echo "=== Server already has been initialized"
fi
vault status
if [ $? == 2 ]; then
  echo "=== Server is sealed. Unsealing"
  echo --- Unseal step 1 of 3
  cat ${KEYS} | grep "Unseal Key 1" | sed s/^.*:\ // | xargs vault unseal
  echo --- Unseal step 2 of 3
  cat ${KEYS} | grep "Unseal Key 2" | sed s/^.*:\ // | xargs vault unseal
  echo --- Unseal step 3 of 3
  cat ${KEYS} | grep "Unseal Key 3" | sed s/^.*:\ // | xargs vault unseal
  echo --- Authenticating
  cat ${KEYS} | grep "Token" | sed s/.*Token:\ // >cf-concourse/concourse_token
  cat cf-concourse/concourse_token | vault auth -
  ./cf-concourse/vault/integrate-concourse.sh
else
  echo "=== Server is not sealed"
fi
