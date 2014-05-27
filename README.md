owncloud-docker
===============

Private Owncloud with just few clicks (enters) under Ubuntu! 

How to use? 
===========

This script allows you creating automatically owncloud, 
what you need is only: 

1. `sudo apt-get docker.io`
1. `sudo mkdir /var/owncloud`
1. `sudo ln -f -s /usr/bin/docker $(which docker.io)`
1. `sudo docker build --rm=false -t $(whoami)/owncloud .`
1. `sudo docker rm -f owncloud`
1. `sudo docker run -i -t -p 127.0.0.1:9000:80 --name="owncloud" -v /var/owncloud:/var/www/owncloud/data $(whoami)/owncloud`

How does it work?
====

1. Download Docker
2. create proper folder for user data
3. create synonym to docker.io for docker *by default docker is some GUI program*
4. build image of owncloud
5. remove previous owncloud's image if exists
6. deploy ownclouds image, alternatively you can append `init.sh` at the end to run tmux

Used technologies
==

1. Docker
2. Owncloud
3. a lot of bash scripting for creating `Dockerfile`
4. Tmux for immediate `init.sh` logging environment with few spiltted panes
5. `/dev/shm/` acts as exchange space for mysql logs - for production this should be turned off
6. php + apache + mysql
