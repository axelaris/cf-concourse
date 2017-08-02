#!/bin/bash
./cf-concourse/bosh-connect.sh
cd cf-concourse/vault
bosh -n -d vault deploy -l vault-vars.yml vault.yml
