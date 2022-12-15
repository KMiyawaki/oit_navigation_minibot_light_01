#!/bin/bash

function main(){
    local -r TARGET_ROS=`./get_ros_distoro.sh`
    local -r ROS_SETUP="/opt/ros/${TARGET_ROS}/setup.bash"
    local -r WS_SETUP="${HOME}/catkin_ws/devel/setup.bash"
    source ${ROS_SETUP}
    source ${WS_SETUP}

    cd
    git clone https://github.com/YDLIDAR/YDLidar-SDK.git
    mkdir -p YDLidar-SDK/build
    cd YDLidar-SDK/build
    cmake ..
    make
    sudo make install

    cd ${HOME}/catkin_ws/src
    git clone https://github.com/YDLIDAR/ydlidar_ros_driver.git
    cd ${HOME}/catkin_ws
    catkin_make
}

main "$@"
