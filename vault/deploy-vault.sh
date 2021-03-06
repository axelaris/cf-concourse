#!/bin/bash
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/vault
bosh -n -d vault deploy --vars-store=vault-vars.yml -o ops-bosh.yml ../../vault-boshrelease/manifests/vault.yml
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
echo "=== Vault server ${IP} will be used as main"
echo ${IP} > ../../vault/addr
