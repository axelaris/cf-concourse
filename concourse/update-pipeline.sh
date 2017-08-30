#!/bin/bash
fly -t $1 set-pipeline -n -p concourse -c pipeline.yml -l ../bosh-vars.yml
