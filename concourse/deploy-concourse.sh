#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/concourse

bosh -n -d concourse deploy -o ops-vault.yml --var-file=VAULT_ADDR=keys/vault_addr --var-file=TOKEN=keys/concourse_token concourse.yml

