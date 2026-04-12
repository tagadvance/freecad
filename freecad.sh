#!/bin/bash

XSOCK=/tmp/.X11-unix

registry='ghcr.io/tagadvance'
image_name='freecad'

# preserve settings between runs
mkdir -p "$HOME/cad" \
         "$HOME/.cache/FreeCAD" \
         "$HOME/.cache/mesa_shader_cache" \
         "$HOME/.cache/mesa_shader_cache_db" \
         "$HOME/.config/FreeCAD" \
         "$HOME/.local/share/FreeCAD"

docker run --rm -it \
           --user $UID:$UID \
           --network host \
           --env DISPLAY=$DISPLAY \
           --env QT_X11_NO_MITSHM=1 \
           --device=/dev/dri:/dev/dri \
           --volume $XSOCK:$XSOCK:ro \
           --volume $HOME/cad:/home/freecad/host \
           --volume $HOME/.cache/FreeCAD:/home/freecad/.cache/FreeCAD \
           --volume $HOME/.cache/mesa_shader_cache:/home/freecad/.cache/mesa_shader_cache \
           --volume $HOME/.cache/mesa_shader_cache_db:/home/freecad/.cache/mesa_shader_cache_db \
           --volume $HOME/.config/FreeCAD:/home/freecad/.config/FreeCAD \
           --volume $HOME/.local/share/FreeCAD:/home/freecad/.local/share/FreeCAD \
           "$registry/$image_name:latest"
