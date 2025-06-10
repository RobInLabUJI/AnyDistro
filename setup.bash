IMAGE=ros-$DISTRO
TAG=$DISTRO-desktop-full
CONTAINER=$IMAGE
WORKDIR=$PWD
COMMAND="source /opt/ros/$DISTRO/setup.bash && cd $WORKDIR && bash"
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
  fi

  #echo "Container" $CONTAINER "not running."
  
  image_exists=$(docker images -q "$IMAGE")
  if [ -z "$image_exists" ]; then
  
    #echo "Image" $IMAGE "not found: creating image."
    
    rocker $ROCKER_NVIDIA --x11 --user --home --nocleanup \
      --image-name $IMAGE \
      --name $CONTAINER \
      osrf/ros:$TAG "sleep 0"

    docker commit $CONTAINER $IMAGE
    docker container remove $CONTAINER
  fi
  
  #echo "Creating container" $CONTAINER
  
  docker create -it -v /home/$USER:/home/$USER  --name $CONTAINER  \
    -h $CONTAINER \
    $DOCKER_NVIDIA -e DISPLAY -e TERM -e QT_X11_NO_MITSHM=1 \
    -e XAUTHORITY=/tmp/.$IMAGE.xauth -v /tmp/.$IMAGE.xauth:/tmp/.$IMAGE.xauth \
    -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro $IMAGE \
    bash -c "$COMMAND"

  #echo "Starting container" $CONTAINER

  docker container start $CONTAINER

fi

#echo "Executing bash in container" $CONTAINER

docker exec -it "$CONTAINER" bash -c "$COMMAND"

INSTANCES=$(docker exec "$CONTAINER" bash -c "ps -e | grep bash | wc -l")

if [[ "$DISTRO" == "kinetic" || "$DISTRO" == "indigo" ]]; then
  MIN_INSTANCES=3
else
  MIN_INSTANCES=2
fi

if [ "$INSTANCES" -eq "$MIN_INSTANCES" ]; then
  #echo "Stopping and removing container" $CONTAINER

  docker commit $CONTAINER $IMAGE
  docker container stop $CONTAINER
  docker container remove $CONTAINER
fi

