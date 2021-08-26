#!/bin/bash

function extract_map_origin(){
  if [ $# -ne 1 ]; then
    echo "usage:${0} map_yaml" 1>&2
    exit 1
  fi
  local ORIGIN=$(grep origin ${1})
  ORIGIN=${ORIGIN/origin:/}
  ORIGIN=${ORIGIN/[/}
  ORIGIN=${ORIGIN/]/}
  ORIGIN=$(echo ${ORIGIN})
  ORIGIN=${ORIGIN//,/ }
  echo "${ORIGIN}"
}

function main(){
  if [ $# -ne 1 ]; then
    echo "usage:${0} map_yaml" 1>&2
    exit 1
  fi
  local -r MAP_YAML=${1}
  local MAP_NAME=${1##*/}
  MAP_NAME=${MAP_NAME%.*}
  readonly MAP_NAME
  local -r MAP_PGM=${MAP_NAME}.pgm
  local -r MAP_PNG=${MAP_NAME}_border.png
  local -r SIMULATION_WORLD=${MAP_NAME}.world
  echo "Add black border into ${MAP_PGM}... "
  ./add_map_image_border.sh ${MAP_PGM}
  echo "Generated ${MAP_PNG}"
  local -r IMG_WIDTH=$(identify -format "%w" ${MAP_PNG})
  local -r IMG_HEIGHT=$(identify -format "%h" ${MAP_PNG})
  local -r MAP_WIDTH=$(echo "scale=2;${IMG_WIDTH} * 0.05" | bc)
  local -r MAP_HEIGHT=$(echo "scale=2;${IMG_HEIGHT} * 0.05" | bc)
  local -r ORIGIN=$(extract_map_origin "${MAP_YAML}")
  local OX=
  local OY=
  local OZ=
  read OX OY OZ <<< "${ORIGIN}"
  readonly OX;  readonly OY;  readonly OZ
  local CX=$(echo "scale=2;${MAP_WIDTH} / 2 + ${OX}" | bc)
  local CY=$(echo "scale=2;${MAP_HEIGHT} / 2 + ${OY}" | bc)
  CX=$(printf "%.2f" ${CX})
  CY=$(printf "%.2f" ${CY})
  readonly CX;  readonly CY
  # Make stage simulator world file
cat << EOF > ${SIMULATION_WORLD}
include "./stage/map.inc"
include "./stage/device.inc"

# set the resolution of the underlying raytrace model in meters
resolution 0.02

interval_sim 25  # simulation timestep in milliseconds

# configure the GUI window
window
(
  size [700.000 700.000]
  scale 20
)

# load an environment bitmap
floorplan
(
  bitmap "./${MAP_PNG}"
  size [${MAP_WIDTH} ${MAP_HEIGHT} 1.5]
  pose [${CX} ${CY} 0 0 0]
)

robot
(
  # can refer to the robot by this name
  name "r0"
  pose [0 0 0 0]
)

rect_block(
  pose [0 -2 0 0]
  color "blue"
)

polygon_block(
  pose [0 2 0 0]
  color "yellow"
)
EOF
}

main "$@"
