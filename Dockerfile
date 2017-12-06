# Builds Beremiz windows installer

# initialize :
#   docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t beremiz_builder .
#
# build installer as-is :
#   docker run -v ~/src:/home/devel/src -v ~/build/:/home/devel/build --rm beremiz_builder
#
# to use on code-build-test cycle :
#   docker create --name current -v ~/src:/home/devel/src -v ~/build/:/home/devel/build -i -t beremiz_builder /bin/bash
#   docker start -i current 
#       # call build operations from here
#   docker stop current
#   docker rm current

FROM ubuntu:xenial

ENV TERM xterm-256color

COPY provision_xenial64.sh .

RUN ./provision_xenial64.sh

ARG UNAME=devel
ENV UNAME ${UNAME}
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID $UNAME
RUN useradd -m -u $UID -g $GID -s /bin/bash $UNAME
USER $UNAME

RUN mkdir /home/$UNAME/build /home/$UNAME/src
COPY . /home/$UNAME/src/beremiz_public_dist/

CMD xvfb-run make -C /home/$UNAME/build -f /home/$UNAME/src/beremiz_public_dist/Makefile

