#!/bin/bash
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/vault
bosh -n -d vault deploy -l vault-vars.yml vault.yml
IP=`bosh -d vault --column=IPs --json vms | jq -r ".Tables[0].Rows[0].ips"`
echo "=== Vault server ${IP} will be used as main"
echo "https://${IP}:8200" > ../../vault/addr
