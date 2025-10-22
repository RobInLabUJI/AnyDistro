#!/usr/bin/env bash

valid_distros=("indigo" "jade" "kinetic" "lunar" "melodic" "noetic" "foxy" "galactic" "humble" "iron" "jazzy" "kilted" "rolling")

if [ -z "$1" ]; then
  echo "Usage: $0 <distro>"
  echo "Valid options: ${valid_distros[*]}"
  exit 1
fi

distro="$1"
ros_path="/opt/ros/$distro"

if [[ ! " ${valid_distros[*]} " =~ " ${distro} " ]]; then
  echo "Error: '${distro}' is not a supported ROS distribution."
  echo "Valid options are: ${valid_distros[*]}"
  exit 1
fi

if [ -d "$ros_path" ]; then
  echo "ROS distribution '$distro' is already installed at $ros_path."
  exit 0
else
  echo "Creating directory $ros_path..."
  sudo mkdir -p "$ros_path" || { echo "Failed to create $ros_path"; exit 1; }
  sudo cp setup.bash /opt/ros/setup.bash
  sudo cp $distro/setup.bash $ros_path/setup.bash
  echo "Setup files copied successfully."
  IMAGE=ros-$distro
  if [[ "$distro" == "foxy" || "$distro" == "galactic" ]]; then
    TAG="${distro}-desktop"
  else
    TAG="${distro}-desktop-full"
  fi
  docker pull osrf/ros:$TAG
fi

