#!/bin/sh

tfstateDirList='
/data/providers/aws/environments/stg/10-acm
/data/providers/aws/environments/stg/11-images
/data/providers/aws/environments/prod/10-acm
/data/providers/aws/environments/prod/11-images
/data/providers/aws/environments/prod/12-vercel
/data/providers/aws/environments/prod/13-txt
'

for tfstateDir in ${tfstateDirList}; do
  echo "$tfstateDir"
  # shellcheck disable=SC2164
  cd "$tfstateDir"
  pwd
  terraform init
done
