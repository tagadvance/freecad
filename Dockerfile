FROM debian:trixie

ARG DEBIAN_FRONTEND=noninteractive
ARG HOST_UID
ARG HOST_GID
ARG VERSION

LABEL org.opencontainers.image.title="FreeCAD"
LABEL org.opencontainers.image.description="Unofficial release of FreeCad."
LABEL org.opencontainers.image.version="${VERSION}"
LABEL org.opencontainers.image.source="https://github.com/tagadvance/freecad"
LABEL org.opencontainers.image.vendor="https://github.com/tagadvance"
LABEL org.opencontainers.image.licenses="GNU Lesser General Public License v2.1"

RUN groupadd --gid ${HOST_GID} freecad \
    && useradd --uid ${HOST_UID} --gid ${HOST_GID} --create-home freecad \
    && apt update \
    && apt install -y freecad libgl1 \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

USER freecad

ENTRYPOINT ["/usr/bin/freecad"]
