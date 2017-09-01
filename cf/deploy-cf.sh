#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
cd cf-deployment
git checkout ${CF_TAG}

set +e
vault read -tls-skip-verify -format=yaml secret/cf-deployment >deployment-vars.tmp
RES=$?
set -e
if [ ${RES} = 0 ]; then
  echo "=== Found CF deployment. Retreiving variables"
  cat deployment-vars.tmp | ../cf-concourse/scripts/get_data.py >deployment-vars.yml
else
  echo "=== No deployment vars found. Deploying fresh CF"
fi
bosh -n -d cf deploy \
  -o operations/bosh-lite.yml \
  --vars-store=deployment-vars.yml \
  -v system_domain=${DOMAIN} \
  cf-deployment.yml

cat deployment-vars.yml | ../cf-concourse/scripts/yaml2json.py > deployment-vars.json
echo "=== Saving deployment vars into Vault"
vault write -tls-skip-verify secret/cf-deployment @deployment-vars.json
