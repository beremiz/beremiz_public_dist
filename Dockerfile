# Dockerfile to setup beremiz_public_dist build container

FROM ubuntu:focal

ENV TERM xterm-256color

COPY provision_focal64.sh .

RUN ./provision_focal64.sh

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ARG UNAME=devel
ENV UNAME ${UNAME}
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME
USER $UNAME

RUN mkdir /home/$UNAME/build /home/$UNAME/src

# easy to remember 'build' alias to invoke main makefile
ARG OWNDIRBASENAME=beremiz_public_dist
ENV OWNDIRBASENAME ${OWNDIRBASENAME}
RUN echo "alias build='make -C /home/"$UNAME"/build -f /home/devel/src/"$OWNDIRBASENAME"/Makefile'">/home/$UNAME/.bash_aliases
