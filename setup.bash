TMP_SCRIPT=$1

IMAGE=ros-$DISTRO
if [[ "$DISTRO" == "foxy" || "$DISTRO" == "galactic" ]]; then
  TAG="${DISTRO}-desktop"
else
  TAG="${DISTRO}-desktop-full"
fi
CONTAINER=$IMAGE
WORKDIR=$PWD
#COMMAND="source /opt/ros/$DISTRO/setup.bash && cd $WORKDIR && bash"
COUNT=$(docker ps | grep "$CONTAINER" | wc -l)

if [ "$COUNT" -eq 0 ]; then

  if nvidia-container-toolkit --version &>/dev/null; then
    if  [[ "$DISTRO" == "indigo" ]]; then
      unset ROCKER_NVIDIA
      unset DOCKER_NVIDIA
    else 
      ROCKER_NVIDIA="--nvidia"
      DOCKER_NVIDIA="--gpus all"
    fi
  else
    ROCKER_NVIDIA="--devices /dev/dri"
    DOCKER_NVIDIA="--device=/dev/dri"
  fi
  
  image_exists=$(docker images -q "$IMAGE")
  if [ -z "$image_exists" ]; then
    
    rocker $ROCKER_NVIDIA --x11 --user --home --nocleanup \
      --image-name $IMAGE \
      --name $CONTAINER \
      osrf/ros:$TAG "sleep 0"

    docker commit $CONTAINER $IMAGE
    docker container remove $CONTAINER
  fi
  
  docker create -it -v /home/$USER:/home/$USER  --name $CONTAINER  \
    -h $CONTAINER --network host \
    $DOCKER_NVIDIA -e DISPLAY -e TERM -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=/tmp/.$IMAGE.xauth -v /tmp/.$IMAGE.xauth:/tmp/.$IMAGE.xauth \
    -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro $IMAGE \
    bash

  docker container start $CONTAINER

fi

if [[ -z "$TMP_SCRIPT" ]]; then
  docker exec -w `pwd` -it "$CONTAINER" /ros_entrypoint.sh bash --rcfile /opt/ros/$DISTRO/setup.bash
else
  docker cp "$TMP_SCRIPT" "$CONTAINER":/tmp/inside.bash
  docker exec -w `pwd` -it "$CONTAINER" /ros_entrypoint.sh bash /tmp/inside.bash --rcfile /opt/ros/$DISTRO/setup.bash
fi

INSTANCES=$(docker exec "$CONTAINER" bash -c "ps -e | grep bash | wc -l")

if [ "$INSTANCES" -eq 2 ]; then
  docker commit $CONTAINER $IMAGE
  docker container stop $CONTAINER
  docker container remove $CONTAINER
fi

