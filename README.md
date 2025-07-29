# AnyDistro

## Prerequisites
Tested on Ubuntu 22.04.5 LTS, Docker 28.1.1, OSRF Rocker 0.2.19, nvidia-container-toolkit 1.17.6-1.
* [Docker](https://docs.docker.com/engine/install/ubuntu/)
* [OSRF Rocker](https://github.com/osrf/rocker)
* [NVIDIA Container Toolkit (optional)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

## Installation
1. Clone this repository
```
git clone https://github.com/RobInLabUJI/AnyDistro.git
```
2. Run the installation script
```
cd AnyDistro && ./install.bash
```

## Usage
Run in a terminal:
```
source /opt/ros-docker/<DISTRO>/setup.bash
```
* The first execution may take a few minutes because the Docker image of the distribution must be downloaded. 
* Afterward, you can open as many terminals as you'd like and run the `source` command in each of them. 
* When you're finished, simply type `exit` in each terminal.

## TODO list
* RViz not working in Indigo/Jade (Ubuntu 14.04)
* ~~Test Intel Graphics~~
* Add legacy ROS distros (without graphics)
* Windows/Mac support
