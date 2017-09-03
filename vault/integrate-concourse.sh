#!/bin/bash
vault mount -path=/concourse -description="Secrets for concourse pipelines" generic
vault policy-write policy-concourse cf-concourse/vault/policy-concourse.hcl
vault token-create --policy=policy-concourse -period="600h" -format=json | jq -r ".auth.client_token" >keys/concourse_token
vault policy-write policy-secret cf-concourse/vault/policy-secret.hcl
vault token-create --policy=policy-secret -period="600h" -format=json | jq -r ".auth.client_token" >keys/secret_token
vault write concourse/main/secret-token value=`cat keys/secret_token`
vault write concourse/main/vault-address value=${VAULT_ADDR}
vault write concourse/main/cf-tag value=v0.4.0
# This is for BOSH Lite only
DOMAIN=`curl -s ipinfo.io/ip`.nip.io
echo "=== CF domain will be set to ${DOMAIN}"
vault write concourse/main/cf-domain value=${DOMAIN}
