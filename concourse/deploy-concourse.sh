#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/concourse

bosh -n -d concourse deploy -o ops-vault.yml --var-file=/instance_groups/name=web/jobs/name=atc/properties/vault/url=keys/vault_addr --var-file=/instance_groups/name=web/jobs/name=atc/properties/vault/auth/client_token=keys/concourse_token concourse.yml

