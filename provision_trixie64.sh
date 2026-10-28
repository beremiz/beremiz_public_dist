#!/usr/bin/env bash

set -xe

# Wine is already provided by MSYS2's docker image, see Dockerfile

apt-get update

apt-get install -y --no-install-recommends \
     build-essential            \
     `# sources and downloads`  \
     git                        \
     wget                       \
     xz-utils                   \
     `# version.py`             \
     python3                    \
     `# matiec cross build`     \
     mingw-w64                  \
     automake                   \
     bison                      \
     flex                       \
     `# canfestival cross build`\
     cmake                      \
     `# installer`              \
     nsis                       \
     zip
