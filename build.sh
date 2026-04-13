#!/bin/bash

registry='ghcr.io/tagadvance'
image_name='freecad'
version=${1:-"1.0.0"}
here=$(dirname "$(realpath $0)")

docker buildx build --platform linux/amd64 \
             --label org.opencontainers.image.created=$(date +"%Y-%m-%dT%H:%M:%S%z") \
             --build-arg HOST_UID=$(id -u) \
             --build-arg HOST_GID=$(id -g) \
             --build-arg VERSION=$version \
             --tag "$image_name:$version" \
             --tag "$image_name:latest" \
             --tag "$registry/$image_name:$version" \
             --tag "$registry/$image_name:latest" \
             $here \
&& docker push --all-tags "$registry/$image_name"

