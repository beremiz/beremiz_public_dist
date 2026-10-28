# Dockerfile to setup beremiz_public_dist build container

# MSYS2's docker image provides a Wine patched to run MSYS2 programs (pacman,
# bash, git...) on top of debian:trixie. It is pinned by digest to control
# Wine version (wine-11.15, see build-base/Dockerfile in msys2-docker repo).
# https://github.com/msys2/msys2-docker
FROM ghcr.io/msys2/msys2-docker-experimental:latest@sha256:9f95ea3e57b4c9b32c77ee8588022e57a125f7d6ddff776fc8f525827055be54

# MSYS2 installed in base image is for root only, and isn't used.
# Back to defaults of a plain debian image.
WORKDIR /
CMD ["/bin/bash"]

ENV TERM=xterm-256color

ENV TZ=America/Paris
ENV DEBIAN_FRONTEND=noninteractive

ARG UNAME=runner
ENV UNAME=${UNAME}
ARG UID=1000
ARG GID=1000

RUN sed -i "/$GID/d" /etc/group
RUN sed -i "/$UID/d" /etc/passwd

RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME

COPY ./provision_trixie64.sh .

RUN ./provision_trixie64.sh

# easy to remember 'build' alias to invoke main makefile
ARG OWNDIRBASENAME=beremiz_public_dist
ENV OWNDIRBASENAME=${OWNDIRBASENAME}
RUN /bin/echo -e '#!/bin/bash\nmake -f /home/'$UNAME'/src/'$OWNDIRBASENAME'/Makefile $*' > /usr/local/bin/build
RUN chmod +x /usr/local/bin/build

USER $UNAME

RUN mkdir /home/$UNAME/build /home/$UNAME/src
