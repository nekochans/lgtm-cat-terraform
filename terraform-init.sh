#!/bin/sh

currentDir=$(pwd)

for tfstateDir in $(find . -maxdepth 5 -regex "\./providers.*/[0-9]\{2,\}.*" -type d); do
  echo "$tfstateDir"
  # shellcheck disable=SC2164
  cd "$tfstateDir"
  pwd
  terraform init
  # shellcheck disable=SC2164
  cd "$currentDir"
done
