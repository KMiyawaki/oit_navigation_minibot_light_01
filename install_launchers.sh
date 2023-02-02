#!/bin/bash

function add_favorite(){
    local -r ENTRY=${1##*/}
    local -r ORG=`gsettings get com.canonical.Unity.Launcher favorites`
    echo ${ORG}|grep -o ${ENTRY}
    if [ $? = 0 ];then
        echo "${ENTRY} is already registered for favorite apps."
    else
        local -r NEW=`echo ${ORG} | sed s/\\\\[/"['application:\\/\\/${ENTRY}', "/`
        # echo ${NEW}
        local -r COM="gsettings set com.canonical.Unity.Launcher favorites \"${NEW}\""
        eval ${COM}
        echo "${ENTRY} is registered for favorite apps."
    fi
}

function install_desktop_entry(){
    local -r DST=${1}
    local -r SRC=${2}
    local -r FILENAME=${SRC##*/}
    
    desktop-file-install --dir="${DST}" ${SRC}
    chmod u+x "${DST}/${FILENAME}"

    if [ $# = 3 ];then
        add_favorite ${SRC}
    fi
}

function main(){
    local -r APPS=${HOME}/.local/share/applications
    local -r ICONS=${HOME}/.icons
    local -r DESK=${HOME}/Desktop
    if [ ! -e ${ICONS} ]; then
        mkdir ${ICONS}
    fi
    cp ./icons/*.png ${ICONS}
    
    install_desktop_entry ${APPS} ./desktop/oit_stop_all.desktop 1
    install_desktop_entry ${APPS} ./desktop/oit_capture.desktop 1
    install_desktop_entry ${DESK} ./desktop/oit_mapping.desktop
    install_desktop_entry ${DESK} ./desktop/oit_teleop.desktop 
    install_desktop_entry ${APPS} ./desktop/oit_devices.desktop 1
    install_desktop_entry ${APPS} ./desktop/oit_ros_python2.desktop
    echo "Set default app for python with right click *.py file."
}

main "$@"