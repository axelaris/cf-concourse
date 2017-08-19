#!/bin/bash
fly -t $1 set-pipeline -p concourse -c pipeline.yml -l ../bosh-vars.yml
