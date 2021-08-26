#!/bin/bash
rosrun xacro xacro --inorder minibot_light_01.xacro -o /tmp/robot.urdf
check_urdf /tmp/robot.urdf
