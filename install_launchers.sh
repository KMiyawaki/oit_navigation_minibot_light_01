#!/bin/bash

function main(){
    cp ./desktop/devices.desktop ~/Desktop
    cp ./desktop/mapping.desktop ~/Desktop
    cp ./desktop/capture.desktop ~/Desktop
    sudo cp ./desktop/runpython2.desktop /usr/share/applications
    echo "Set default app for python with right click *.py file."
}

main "$@"