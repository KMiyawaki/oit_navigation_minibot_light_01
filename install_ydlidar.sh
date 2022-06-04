#!/bin/bash
cd
sudo apt-get install -y cmake
sudo apt-get install -y pkg-config
sudo apt-get install -y swig
git clone https://github.com/YDLIDAR/YDLidar-SDK.git
mkdir ./YDLidar-SDK/build
cd ./YDLidar-SDK/build
cmake ..
make
sudo make install
cd ~/catkin_ws/src
git clone https://github.com/YDLIDAR/ydlidar_ros_driver.git
cd ~/catkin_ws
catkin_make
cd ~/catkin_ws/src/ydlidar_ros_driver/startup
sudo ./initenv.sh
