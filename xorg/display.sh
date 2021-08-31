#!/usr/bin/env bash

DISPLAYS=($(xrandr | grep " connected " | awk '{ print$1 }'))

SCREEN=${DISPLAYS[0]}
MONITOR=${DISPLAYS[1]}

if [[ "${SCREEN}" == "eDP1" ]]
then
    echo xrandr --output ${SCREEN} --mode 1920x1080 --auto --left-of ${MONITOR} --pos 0x0
else
    echo xrandr --output ${SCREEN} --mode 1920x1080 --auto --left-of ${MONITOR} --pos 0x0 --dpi 96
fi

echo xrandr --output ${MONITOR} --primary --right-of ${SCREEN}
