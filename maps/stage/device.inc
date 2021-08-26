# https://player-stage-manual.readthedocs.io/en/latest/

define UTM-30LX ranger
(
  # https://www.hokuyo-aut.co.jp/search/single.php?serial=21
  sensor(                         
    range [ 0.0  30.0 ]
    fov 270.25
    samples 1081
  )
  # generic model properties
  color "black"
  size [ 0.06 0.06 0.09 ]
  update_interval 25
)

define YDLIDAR_X4 ranger
(
  # https://www.ydlidar.com/products/view/5.html
  sensor(                         
    range [ 0.0  11.0 ]
    fov 360
    samples 720
  )
  # generic model properties
  color "black"
  size [ 0.05 0.05 0.1 ]
  update_interval 25
)

define robot position
(
  size   [0.24 0.24 0.158]
  origin [-0.05 0 0 0] # move rotation center forward
  gui_nose 1
  drive "diff"
  YDLIDAR_X4(pose [ 0.03 0 0.0787 0 ])
  velocity_bounds     [-1.2 1.2 0 0 0 0 -270 270]
  acceleration_bounds [-1.2 1.2 0 0 0 0 -270 270]
  update_interval 25
)
