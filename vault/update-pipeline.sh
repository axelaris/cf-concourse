#!/bin/bash
fly -t $1 set-pipeline -n -p vault -c pipeline.yml -l ../bosh-vars.yml 
