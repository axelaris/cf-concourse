#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
ADDR=`cat keys/vault_addr`
TOKEN=`cat keys/concourse_token`
cd cf-concourse/concourse

bosh -n -d concourse deploy -o ops-vault.yml --var=VAULT_ADDR=${ADDR} --var=TOKEN=${TOKEN} concourse.yml

