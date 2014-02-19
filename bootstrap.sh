#!/usr/bin/env bash

set -eo pipefail
export DEBIAN_FRONTEND=noninteractive
export DOKKU_REPO=${DOKKU_REPO:-"https://github.com/shamox/dokku.git"}

if ! which apt-get &>/dev/null
then
  echo "This installation script requires apt-get. For manual installation instructions, consult https://github.com/progrium/dokku ."
  exit 1
fi

apt-get update
apt-get install -y git make curl software-properties-common

cd ~ && rm -rf dokku
cd ~ && test -d dokku || git clone $DOKKU_REPO
cd dokku
git fetch origin

if [[ -n $DOKKU_BRANCH ]]; then
  git checkout origin/$DOKKU_BRANCH
elif [[ -n $DOKKU_TAG ]]; then
  git checkout $DOKKU_TAG
fi

make install

echo
echo "Be sure to upload a public key for your user:"
echo "  cat ~/.ssh/id_rsa.pub | ssh root@$HOSTNAME \"sudo sshcommand acl-add dokku yourusername\""
