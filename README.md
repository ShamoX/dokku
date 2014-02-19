# Dokku

Docker powered mini-Heroku. The smallest PaaS implementation you've ever seen.

[![Build Status](https://travis-ci.org/progrium/dokku.png?branch=master)](https://travis-ci.org/progrium/dokku)

## Requirements

Assumes Ubuntu 13 x64 right now. Ideally have a domain ready to point to your host. It's designed for and is probably
best to use a fresh VM. The bootstrapper will install everything it needs.

**Note: There are known issues with docker and Ubuntu 13.10 ([1](https://github.com/dotcloud/docker/issues/1300), [2](https://github.com/dotcloud/docker/issues/1906)) - use of 13.04 is recommended until these issues are resolved.**

## Installing

Everything (including docker, gitreceive, sshcommand, pluginhook, & buildstep):

    $ wget -qO- https://raw.github.com/shamox/dokku/master/bootstrap.sh | sudo bash

This may take around 5 minutes. Certainly better than the several hours it takes to bootstrap Cloud Foundry.

You'll have to add a public key associated with a username by doing something like this from your local machine:

    $ cat ~/.ssh/id_rsa.pub | ssh <your domain> "sudo sshcommand acl-add dokku git"


