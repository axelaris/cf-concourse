#!/bin/bash
vault mount ${NOTLS} -path=/concourse -description="Secrets for concourse pipelines" generic
vault policy-write ${NOTLS} policy-concourse cf-concourse/vault/policy.hcl
vault token-create ${NOTLS} --policy=policy-concourse -period="600h" -format=json | jq -r ".auth.client_token" >keys/concourse_token
vault write ${NOTLS} concourse/main/vault-root-token value=`cat ${KEYS} | grep "Token" | sed s/.*Token:\ //`
vault write ${NOTLS} concourse/main/vault-address value=${VAULT_ADDR}
vault write ${NOTLS} concourse/main/cf-tag=v0.4.0
# This is for BOSH Lite only
DOMAIN=`curl -s ipinfo.io/ip`.nip.io
echo "=== CF domain will be set to ${DOMAIN}"
vault write ${NOTLS} concourse/main/cf-domain=${DOMAIN}
