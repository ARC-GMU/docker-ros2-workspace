#!/bin/sh

docker run --rm -d --user "$(id -u):$(id -g)" --name rdc-ros2 -p 2222:22 -v "${PWD}\workspace:/home/rdc/workspace" rdc-ros2