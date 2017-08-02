#!/bin/bash
./cf-concourse/bosh-connect.sh
cd cf-deployment/vault
bosh -n -d vault deploy vault.yml
