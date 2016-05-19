#!/bin/bash

sudo mkdir Dropbox
sudo chmod 777 Dropbox

sudo /root/.dropbox-dist/dropboxd &

sudo mkdir -p Dropbox/cloud-workspace/.eclipse-docker
sudo chmod 777 Dropbox/cloud-workspace
sudo chmod 777 Dropbox/cloud-workspace/.eclipse-docker
cd Dropbox/cloud-workspace

xhost +

sudo docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/.eclipse-docker:/home/developer -v `pwd`:/workspace slarson/docker-eclipse
