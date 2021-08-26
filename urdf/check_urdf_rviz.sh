#!/bin/bash
rosrun xacro xacro --inorder minibot_light_01.xacro -o /tmp/robot.urdf
roslaunch urdf_tutorial display.launch model:=/tmp/robot.urdf
