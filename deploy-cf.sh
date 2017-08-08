#!/bin/bash 
./cf-concourse/bosh-connect.sh
cd cf-deployment
git checkout v0.4.0

vault read -tls-skip-verify -format=yaml secret/cf-deployment >deployment-vars.tmp
if [ $? = 0 ]; then
  cat deployment-vars.tmp | ./get_data.py >deployment-vars.yml
fi
rm deployment-vars.tmp
bosh -n -d cf deploy \
  -o operations/bosh-lite.yml \
  --vars-store=deployment-vars.yml \
  -v system_domain=${DOMAIN}.nip.io \
  cf-deployment.yml

cat deployment-vars.yml | ./yaml2json.py > deployment-vars.json
vault write -tls-skip-verify secret/cf-deployment @deployment-vars.json
