#!/bin/bash

function main(){
    if [ -d /opt/ros/noetic ]; then
        echo "noetic"
    elif [ -d /opt/ros/melodic ]; then
        echo "melodic"
    elif [ -d /opt/ros/kinetic ]; then
        echo "kinetic"
    else
        echo "*** No supported ROS found ***"
    fi
}

main "$@"
