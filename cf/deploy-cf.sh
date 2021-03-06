#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
echo ${VAULT_ADDR} vault >>/etc/hosts
export VAULT_ADDR=https://vault:8200
cd cf-deployment
git checkout ${CF_TAG}

set +e
vault read -format=yaml secret/cf-deployment >deployment-vars.tmp
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
vault write secret/cf-deployment @deployment-vars.json
