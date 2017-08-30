#!/bin/bash
fly -t $1 set-pipeline -n -p cf -c pipeline.yml -l pipeline-vars.yml -l ../bosh-vars.yml
