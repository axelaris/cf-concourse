echo "192.168.0.149 bosh.sslip.io" >>/etc/hosts
bosh -n -d cf deploy \
  -o cf-deployment/operations/bosh-lite.yml \
  --vars-store=cf-deployment/deployment-vars.yml \
  -v system_domain=${DOMAIN}.nip.io \
  cf-deployment/cf-deployment.yml
