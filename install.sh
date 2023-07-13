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
    sudo apt-get install -y ros-${TARGET_ROS}-teleop-twist-keyboard
    sudo apt-get install -y ros-${TARGET_ROS}-key-teleop
    sudo apt-get install -y xterm
    if [[ $TARGET_ROS = "melodic" ]]; then
        sudo /usr/bin/python2 -m pip install pyserial
    else
        sudo /usr/bin/python3 -m pip install pyserial
    fi
    cd ${HOME}/catkin_ws
    catkin_make
}

main "$@"
