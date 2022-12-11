#!/bin/bash

function main(){
    local -r TARGET_ROS=`./get_ros_distoro.sh`
    local -r ROS_SETUP="/opt/ros/${TARGET_ROS}/setup.bash"
    local -r WS_SETUP="~/catkin_ws/devel/setup.bash"
    source ${ROS_SETUP}
    source ${WS_SETUP}
    cd ~/catkin_ws/src
    git clone https://github.com/YDLIDAR/ydlidar_ros.git
    git clone https://github.com/aamirhatim/twist_filter.git
    git clone https://github.com/KMiyawaki/oit_roboclaw_driver.git
    cd ~/catkin_ws/src/ydlidar_ros
    git checkout refs/tags/1.4.1
    sudo apt-get install -y ros-melodic-teleop-twist-keyboard
    sudo apt-get install -y ros-melodic-key-teleop
    sudo apt-get install -y xterm
    cd ~/catkin_ws
    catkin_make
    cd ~/catkin_ws/src/ydlidar_ros/startup
    sudo ./initenv.sh
}

main "$@"
