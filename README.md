# ROS 1

## Prerequisites
Tested on Ubuntu 22.04.5 LTS, Docker 28.1.1, OSRF Rocker 0.2.19, nvidia-container-toolkit 1.17.6-1.
* [Docker](https://docs.docker.com/engine/install/ubuntu/)
* [OSRF Rocker](https://github.com/osrf/rocker)
* [NVIDIA Container Toolkit (optional)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Installation
1. Clone this repository
```
git clone https://github.com/RoboticRepositories/ros1.git
```
2. Run the installation script
```
cd ros1 && ./install.bash
```

## TODO list
* RViz not working in Indigo/Jade (Ubuntu 14.04)
* Test Intel Graphics
* Add legacy ROS distros (without graphics)
* ~~[Fix GPG key](https://github.com/osrf/docker_images/issues/814)~~
* ~~Check Indigo~~
* ~~Check Kinetic~~
* ~~Update image when exiting the last terminal of container~~
* ~~Set NVIDIA as optional~~
* ~~Keep current directory~~
