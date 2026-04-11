#!/bin/bash

XAUTH=/tmp/.docker.xauth
XSOCK=/tmp/.X11-unix

version=${1:-"1.0.0"}
here=$(dirname "$(realpath $0)")

docker buildx build --platform linux/amd64 \
             --build-arg HOST_UID=$(id -u) \
             --build-arg HOST_GID=$(id -g) \
             --build-arg VERSION=$version \
             --tag "freecad:$version" \
             --tag 'freecad:latest' \
             $here

# preserve settings between runs
mkdir -p "$HOME/.cache/FreeCAD" \
         "$HOME/.cache/mesa_shader_cache" \
         "$HOME/.cache/mesa_shader_cache_db" \
         "$HOME/.config/FreeCAD" \
         "$HOME/.local/share/FreeCAD"

# While xhost +local:docker is more restrictive than xhost +
# (which allows anyone on the network to access your screen),
# it still lowers the security of your host machine.
# For better security, use an Xauthority token (.Xauthority)
# to grant access only to a specific container rather than
# the entire local Docker user.

xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run --rm -it \
           --user $UID:$UID \
           --network host \
           --env DISPLAY=$DISPLAY \
           --env QT_X11_NO_MITSHM=1 \
           --env XAUTHORITY=$XAUTH \
           --device=/dev/dri:/dev/dri \
           --volume $XSOCK:$XSOCK:ro \
           --volume $HOME/.cache/FreeCAD:/home/freecad/.cache/FreeCAD \
           --volume $HOME/.cache/mesa_shader_cache:/home/freecad/.cache/mesa_shader_cache \
           --volume $HOME/.cache/mesa_shader_cache_db:/home/freecad/.cache/mesa_shader_cache_db \
           --volume $HOME/.config/FreeCAD:/home/freecad/.config/FreeCAD \
           --volume $HOME/.local/share/FreeCAD:/home/freecad/.local/share/FreeCAD \
           freecad:latest

rm --force $XAUTH
