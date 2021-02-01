#!/bin/sh
docker build -t ptcd:latest ./
docker rmi   -f $(docker images -f "dangling=true" -q)
