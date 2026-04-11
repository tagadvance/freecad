FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive
ARG HOST_UID
ARG HOST_GID
ARG VERSION

RUN groupadd --gid ${HOST_GID:-1000} freecad \
    && useradd --uid ${HOST_UID:-1000} --gid ${HOST_GID:-1000} --create-home freecad \
    && apt update \
    && apt install -y freecad libgl1 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER freecad

ENTRYPOINT ["/usr/bin/freecad"]
