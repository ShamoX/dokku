DOKKU_VERSION = v0.2.1

SSHCOMMAND_URL ?= https://raw.github.com/progrium/sshcommand/5f9afe79698332d24a69873721619f5af4670d09/sshcommand
PLUGINHOOK_URL ?= https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb
STACK_URL ?= github.com/ginlane/buildstep
PREBUILT_STACK_URL ?= https://s3.amazonaws.com/progrium-dokku/progrium_buildstep_79cf6805cf.tgz
DOKKU_ROOT ?= /home/dokku

.PHONY: all install copyfiles version plugins dependencies sshcommand pluginhook docker aufs stack count

all:
	# Type "make install" to install.

install: dependencies stack copyfiles plugins version

copyfiles:
	cp dokku /usr/local/bin/dokku
	mkdir -p /var/lib/dokku/plugins
	cp -r plugins/* /var/lib/dokku/plugins

version:
	git describe --tags > ${DOKKU_ROOT}/VERSION  2> /dev/null || echo '~${DOKKU_VERSION} ($(shell date -uIminutes))' > ${DOKKU_ROOT}/VERSION

plugins: pluginhook docker
	dokku plugins-install

dependencies: sshcommand pluginhook docker stack

sshcommand:
	wget -qO /usr/local/bin/sshcommand ${SSHCOMMAND_URL}
	chmod +x /usr/local/bin/sshcommand
	sshcommand create dokku /usr/local/bin/dokku

pluginhook:
	wget -qO /tmp/pluginhook_0.1.0_amd64.deb ${PLUGINHOOK_URL}
	dpkg -i /tmp/pluginhook_0.1.0_amd64.deb

docker: aufs
	egrep -i "^docker" /etc/group || groupadd docker
	usermod -aG docker dokku
	curl https://get.docker.io/gpg | apt-key add -
	echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
	apt-get update
	apt-get install -y lxc-docker 
	sleep 2 # give docker a moment i guess
	rm -rf /var/lib/docker/volumes/*
	# remove all stopped containers
	docker rm $(docker ps -a -q)
	# removed all untagged images
	docker rmi $(docker images | grep "^<none>" | awk "{print $3}")
	chmod 0755 /var/lib/docker
	chmod 0777 /var/lib/docker/volumes
	chmod 0777 /var/run/docker.sock

aufs:
	lsmod | grep aufs || modprobe aufs || apt-get install -y linux-image-extra-`uname -r`

stack:
	# @docker images | grep ginlane/buildstep ||  was prefixing the below command
	docker build -t ginlane/buildstep ${STACK_URL}
	# docker build -t ginlane/buildstep github.com/ginlane/buildstep

count:
	@echo "Core lines:"
	@cat dokku bootstrap.sh | wc -l
	@echo "Plugin lines:"
	@find plugins -type f | xargs cat | wc -l
	@echo "Test lines:"
	@find tests -type f | xargs cat | wc -l
