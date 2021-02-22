#!/bin/sh

tfstateDirList='
/data/providers/aws/environments/prod/11-images
'

for tfstateDir in ${tfstateDirList}; do
  echo "$tfstateDir"
  # shellcheck disable=SC2164
  cd "$tfstateDir"
  pwd
  terraform init
done
