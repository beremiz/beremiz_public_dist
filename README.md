# Beremiz public distribution #

This repository holds recipes and patches to build the Beremiz 
packages and installers for [Beremiz website](http://beremiz.org/).

Patches have same license as projects being patched. For other files,
unless made explicit in file header, GPLv3 applies.

## Use cases ##

Beremiz development uses Mercurial, but git repositories that are kept in sync.

Build from both Mercurial and Git repositories is supported.

### GitHub CI ##

Use code from https://github.com/beremiz repositories.

Workflows described in .github/workflows are meant to run on a GitHub runner. Please refer to GitHub documentation to run workflows on your own fork.

Dockerfile and part of Makefiles are used for windows installer build, but for Snap build, only snapcraft.yaml is used.

### Developer build ###

Use code from local Git repositories in your workspace.

Uses Makefiles and Dockerfile to build windows installer and Makefile+snapcraft.yaml for Snap package.

Hereafter is documented how to use Makefile and Docker in case of Manual Build

## Prerequisites ##

A usable Docker is required. Docker is used to ensure a reproducible build
environment. 

Other containerization/virtualization could be used to achieve the same effect. 

Reference build environment is obtained by applying [provision_trixie64.sh](provision_trixie64.sh) on [MSYS2 docker image](https://github.com/msys2/msys2-docker) (Debian 13 amd64 with patched Wine), as done in [Dockerfile](Dockerfile).

### Windows host (WSL2) ###

Scripts are meant to run on a Linux host. On Windows, they can be used
unchanged from a shell of a WSL2 Linux distribution (e.g. Ubuntu), provided
that:

 - `docker` command is available in that distribution, either from Docker
   Desktop with "WSL integration" enabled for that distribution, or from Docker
   Engine installed in the distribution itself.
 - source and build directories are in distribution's own filesystem (e.g.
   `~/src` and `~/build`), not in Windows filesystem (`/mnt/c/...`). Build runs
   Wine that creates many thousands of files in build directory, which is way
   slower on Windows filesystem.
 - repositories are cloned with git from inside the distribution. Git for
   Windows converts line endings to CRLF by default, which breaks scripts and
   build.

Setup steps:
```
# If WSL not already installed
wsl --install

# Add a WSL2 distribution
wsl --shutdown
wsl --update
wsl --install -d Ubuntu     # or: wsl -d Ubuntu if already installed

# Get Docker Desktop
winget install -e --id Docker.DockerDesktop

# Docker integration with default WSL distro is on by default
wsl --set-default Ubuntu
docker desktop restart

```

Resulting installer can be retrieved from Windows Explorer at
`\\wsl$\<distribution>\home\<user>\build`.

Only amd64 hosts are supported, MSYS2 docker image isn't available for arm64.

Alternatively, GitHub CI workflow can be run on a fork to get windows
installer built without Docker on the host.

## Preparing source ##

The top Makefile expects source code of Beremiz, Matiec and CanFestival to be 
sibling to beremiz_public_dist directory, in the 'source directory'.
For example :

```
~/src
     /beremiz
     /beremiz_public_dist
     /matiec
     /canfestival [windows, snap]
     /Modbus      [snap]
     /open62541   [snap]
```

Repositories can be cloned from https://github.com/beremiz .

Intermediate and final results are all placed in a single 'build directory'
during build process.

## Windows installer Build ##

### Prepare Docker image ###

The script [rebuild_docker.sh](rebuild_docker.sh) is used for that purpose.

Synopsis:

    ./rebuild_docker.sh [build directory]


Source and Build Volumes :
 
 Role             | Docker Volume     | Host path in example | Rationale
------------------|-------------------|----------------------|------------------------------------------------
 source directory | /home/runner/src   | ~/src                | Always relative to CWD : "../"
 build directory  | /home/runner/build | ~/build              | First argument to rebuild_docker.sh or ~/build

'build directory' can be specified as absolute path argument of rebuild_docker.sh.
If not specified it defaults to ~/build

```
#!sh
./rebuild_docker.sh ~/build_next
```

Note: 'build directory' is created if not already existing.

### Build Windows Installer ###

The script [build_in_docker.sh](build_in_docker.sh) is used for that purpose.

```
#!sh
./build_in_docker.sh 
```

Note: 'build directory' must exist before calling build_in_docker.sh, otherwise
Docker will create it as root user. Be sure to create it again if you delete it.

Resulting installer is Beremiz-${timestamp}.exe in 'build directory'. 

### Manhole ###

Once Docker image ready, the scripts [enter_docker.sh](enter_docker.sh) and
[enter_docker_as_root.sh](enter_docker_as_root.sh) let you issue build 
commands, or install additional packages.

[clean_docker_container.sh](clean_docker_container.sh) and [create_docker_container.sh](create_docker_container.sh) and 
[clean_docker_image.sh](clean_docker_image.sh) and [build_docker_image.sh](build_docker_image.sh) are invoked by 
[rebuild_docker.sh](rebuild_docker.sh). 

## Snap Package Build ##

snapcraft.yaml does not rely on HG or GIT repos, but refers to local sources, this is responsibility of caller to prepare sources for snapcraft.

Reasons for this are :
 - no parameters or conditional variables exist to tell snapcraft.yaml where to get the source from
 - building from local source should be always possible
 - when Snap is built from GitHub actions, Makefile isn't used at all, and GitHub action workflow organize sources and revisions.txt on its own.

In the end, instead of just calling `snapcraft` to get a snap package, it is more complicated:

```
# assuming source repositories are cloned in ~/src 
# and build happens in ~/build

cd ~/build
make -f ~/src/beremiz_public_dist/Makefile DIST=snap

```
Resulting snap package is sources/beremiz_${version}_${platform}.snap.
It can be installed this way:

```
sudo snap install sources/beremiz_1.4-beta2_amd64.snap --dangerous --devmode
```

