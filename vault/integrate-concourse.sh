#!/bin/bash
vault mount ${NOTLS} -path=/concourse -description="Secrets for concourse pipelines" generic
vault policy-write ${NOTLS} policy-concourse cf-concourse/vault/policy.hcl
vault token-create ${NOTLS} --policy=policy-concourse -period="600h" -format=json | jq -r ".auth.client_token" >keys/concourse_token
vault write ${NOTLS} concourse/main/vault-root-token value=`cat keys/vault-keys | grep "Token" | sed s/.*Token:\ //`
vault write ${NOTLS} concourse/main/vault-address value=${VAULT_ADDR}
