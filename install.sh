#!/bin/bash

function main(){
    ./install_ydlidar.sh
    local -r TARGET_ROS=`./get_ros_distoro.sh`
    local -r ROS_SETUP="/opt/ros/${TARGET_ROS}/setup.bash"
    local -r WS_SETUP="${HOME}/catkin_ws/devel/setup.bash"
    source ${ROS_SETUP}
    source ${WS_SETUP}
    cd ${HOME}/catkin_ws
    catkin_make
    cd ${HOME}/catkin_ws/src
    git clone https://github.com/aamirhatim/twist_filter.git
    git clone https://github.com/KMiyawaki/oit_roboclaw_driver.git
    sudo apt-get install -y ros-melodic-teleop-twist-keyboard
    sudo apt-get install -y ros-melodic-key-teleop
    sudo apt-get install -y xterm
    cd ${HOME}/catkin_ws
    catkin_make
}

main "$@"
