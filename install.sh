#!/bin/bash
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
sudo reboot
