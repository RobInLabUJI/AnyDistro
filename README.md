# AnyDistro
[![distros](distros.png)](https://docs.ros.org/)

## Prerequisites
* [Docker](https://docs.docker.com/engine/install/ubuntu/)
* [OSRF Rocker](https://github.com/osrf/rocker)
* [NVIDIA Container Toolkit (optional)](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

Tested on the following configurations:
* Ubuntu 22.04.5 LTS, Docker 28.1.1, OSRF Rocker 0.2.19, nvidia-container-toolkit 1.17.6-1.
* Ubuntu 24.04.3 LTS, Docker 28.4.0, OSRF Rocker 0.2.19, Intel graphics.

## Installation
1. Clone this repository
```
git clone https://github.com/RobInLabUJI/AnyDistro.git
```
2. Run the installation script
```
cd AnyDistro && ./install.bash <DISTRO>
```
This may take a few minutes because the Docker image of the distribution must be downloaded.

## Usage
Run the following command in a terminal:
```
source /opt/ros/<DISTRO>/setup.bash
```
* Afterward, you can open as many terminals as you like and run the `source` command in each one. 
* When you're finished, simply type `exit` in each terminal to close it.

You can also execute a shell script that includes the `source` command.

## TODO list
* ~~RViz not working in Indigo/Jade (Ubuntu 14.04)~~
* ~~Test Intel Graphics~~
* Add legacy ROS distros (without graphics)
* Windows/Mac support
