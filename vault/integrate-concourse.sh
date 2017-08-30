#!/bin/bash
NOTLS="-tls-skip-verify"
vault mount ${NOTLS} -path=/concourse -description="Secrets for concourse pipelines" generic
vault policy-write ${NOTLS} policy-concourse cf-concourse/vault/policy.hcl
vault token-create ${NOTLS} --policy=policy-concourse -period="600h" -format=json >/tmp/token
TOKEN=`cat /tmp/token | jq -r ".auth.client_token"`
vault write ${NOTLS} concourse/main/vault-root-token value=`cat vault-keys | grep "Token" | sed s/.*Token:\ //`
vault write ${NOTLS} concourse/main/vault-address value="https://${IP}:8200"
