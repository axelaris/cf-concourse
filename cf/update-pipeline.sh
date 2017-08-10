#!/bin/bash
fly -t $1 set-pipeline -p cf -c pipeline.yml -l pipeline-vars.yml -l ../bosh-vars.yml
