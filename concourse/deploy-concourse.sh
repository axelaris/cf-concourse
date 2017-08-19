#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/concourse

bosh -n -d concourse deploy concourse.yml

