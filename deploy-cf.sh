sudo echo "192.168.0.149 bosh.sslip.io" >>/etc/hosts
DOMAIN=`curl -s ipinfo.io/ip`
bosh -n -d cf deploy \
  -o ../cf-deployment/operations/bosh-lite.yml \
  --vars-store=deployment-vars.yml \
  -v system_domain=${DOMAIN}.nip.io \
  ../cf-deployment/cf-deployment.yml
