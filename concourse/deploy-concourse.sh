#!/bin/bash -e
./cf-concourse/scripts/bosh-connect.sh
cd cf-concourse/concourse

bosh -d concourse deploy concourse.yml

