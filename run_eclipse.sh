#!/bin/bash

xhost +

sudo docker run -ti --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v `pwd`/.eclipse-docker:/home/developer -v `pwd`:/workspace slarson/docker-eclipse
