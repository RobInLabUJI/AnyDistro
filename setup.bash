IMAGE_NAME=ros-$DISTRO
TAG=$DISTRO-desktop-full
CONTAINER_NAME=$IMAGE_NAME
WORKDIR=$PWD
COUNT=$(docker ps | grep "$CONTAINER_NAME" | wc -l)

if [ "$COUNT" -eq 0 ]; then

  image_exists=$(docker images -q "$IMAGE_NAME")
  if [ -z "$image_exists" ]; then
    rocker --nvidia --x11 --user --home --nocleanup \
      --image-name $IMAGE_NAME \
      --name $CONTAINER_NAME \
      osrf/ros:$TAG 'bash -c "source /opt/ros/$DISTRO/setup.bash && cd $WORKDIR && bash"'
  else
    docker run -it -v /home/$USER:/home/$USER  --name $CONTAINER_NAME  \
      --gpus all -e DISPLAY -e TERM -e QT_X11_NO_MITSHM=1 \
      -e XAUTHORITY=/tmp/.$IMAGE_NAME.xauth -v /tmp/.$IMAGE_NAME.xauth:/tmp/.$IMAGE_NAME.xauth \
      -v /tmp/.X11-unix:/tmp/.X11-unix -v /etc/localtime:/etc/localtime:ro $IMAGE_NAME \
      bash -c "source /opt/ros/$DISTRO/setup.bash && cd $WORKDIR && bash"
  fi
  
  docker commit $CONTAINER_NAME $IMAGE_NAME
  docker container remove $CONTAINER_NAME

else

  docker exec -it "$CONTAINER_NAME" bash -c "source /opt/ros/$DISTRO/setup.bash && cd $WORKDIR && bash"

fi

