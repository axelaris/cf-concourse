#!/bin/bash
fly -t $1 set-pipeline -n -p main -c pipeline.yml -l ../bosh-vars.yml
