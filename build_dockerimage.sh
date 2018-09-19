#! /bin/bash
# builds docker image for TomTom Sportsconnect passing local timezone of host system
# as an argument to inherit timezone of host system to docker image
docker build --build-arg LOCALTIMEZONE=`cat /etc/timezone` -t tomtomsc:latest .

