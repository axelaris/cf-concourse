#!/bin/bash
vault mount ${NOTLS} -path=/concourse -description="Secrets for concourse pipelines" generic
vault policy-write ${NOTLS} policy-concourse cf-concourse/vault/policy-concourse.hcl
vault token-create ${NOTLS} --policy=policy-concourse -period="600h" -format=json | jq -r ".auth.client_token" >keys/concourse_token
vault policy-write ${NOTLS} policy-secret cf-concourse/vault/policy-secret.hcl
vault token-create ${NOTLS} --policy=policy-secret -period="600h" -format=json | jq -r ".auth.client_token" >keys/secret_token
vault write ${NOTLS} concourse/main/secret-token value=`cat keys/secret_token`
vault write ${NOTLS} concourse/main/vault-address value=${VAULT_ADDR}
vault write ${NOTLS} concourse/main/cf-tag value=v0.4.0
# This is for BOSH Lite only
DOMAIN=`curl -s ipinfo.io/ip`.nip.io
echo "=== CF domain will be set to ${DOMAIN}"
vault write ${NOTLS} concourse/main/cf-domain value=${DOMAIN}
