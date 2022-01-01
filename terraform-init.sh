#!/bin/sh

tfstateDirList='
/data/providers/aws/environments/prod/10-network
/data/providers/aws/environments/prod/11-acm
/data/providers/aws/environments/prod/12-images
/data/providers/aws/environments/prod/13-vercel
/data/providers/aws/environments/prod/14-txt
/data/providers/aws/environments/prod/15-iam
/data/providers/aws/environments/prod/16-ses
/data/providers/aws/environments/prod/17-cognito
/data/providers/aws/environments/prod/20-api
/data/providers/aws/environments/prod/21-lambda-securitygroup
/data/providers/aws/environments/prod/22-migration
/data/providers/aws/environments/prod/23-rds
/data/providers/aws/environments/stg/11-acm
/data/providers/aws/environments/stg/12-images
/data/providers/aws/environments/stg/17-cognito
/data/providers/aws/environments/stg/20-api
/data/providers/aws/environments/stg/21-lambda-securitygroup
/data/providers/aws/environments/stg/22-migration
'

for tfstateDir in ${tfstateDirList}; do
  echo "$tfstateDir"
  # shellcheck disable=SC2164
  cd "$tfstateDir"
  pwd
  terraform init
done
