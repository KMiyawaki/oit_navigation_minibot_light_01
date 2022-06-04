#!/bin/bash
./install_ydlidar.sh
cd ~/catkin_ws/src
git clone https://github.com/aamirhatim/twist_filter.git
git clone https://github.com/KMiyawaki/oit_roboclaw_driver.git
sudo apt-get install -y ros-melodic-teleop-twist-keyboard
sudo apt-get install -y ros-melodic-key-teleop
sudo apt-get install -y xterm
cd ~/catkin_ws
catkin_make
sudo reboot
