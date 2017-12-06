#! gmake

# This is Makefile for Beremiz installer
#
# Invoke with "make -f path/to/Makefile" on a linux box
# in directory where build should happen.
#
# All those dependencies have to be installed :
#
#  Windows installer :
#  - wine (tested with 1.2 and 1.6. Fail with 1.4)
#  - mingw32
#  - flex
#  - bison
#  - tar
#  - unrar
#  - wget
#  - nsis
#  - libtool
#  - xmlstarlet
#  - xsltproc
#  - python-lxml
#
# WARNING : DISPLAY variable have to be defined to a valid X server
#           in case it would be a problem, run :
#           xvfb-run make -f /path/to/this/Makefile

version = 1.2-rc1

src := $(shell dirname $(lastword $(MAKEFILE_LIST)))
HGREMOTE ?= https://hg.beremiz.org/
HGROOT ?= $(abspath $(src)/..)
GITROOT := $(HGROOT)
DIST =
CPUS = 8
BLKDEV=/dev/null


CROSS_COMPILE=i686-w64-mingw32
CROSS_COMPILE_LIBS_DIR=$(shell dirname $(shell $(CROSS_COMPILE)-gcc -print-libgcc-file-name))
CC=$(CROSS_COMPILE)-gcc
CXX=$(CROSS_COMPILE)-g++

define get_runtime_libs
	cp $(CROSS_COMPILE_LIBS_DIR)/libgcc_s_sjlj-1.dll $(1)
	cp $(CROSS_COMPILE_LIBS_DIR)/libstdc++-6.dll $(1)
endef

distfiles = $(src)/distfiles
sfmirror = downloads
tmp := $(shell mktemp -d)

define hg_get_archive
test -d $(HGROOT)/`basename $(1)` || hg --cwd $(HGROOT) clone $(HGREMOTE)`basename $(1)`
hg -R $(HGROOT)/`basename $(1)` archive $(2) $(1)
hg -R $(HGROOT)/`basename $(1)` id -i | sed 's/\+//' > $(1)/revision
endef

define get_src_hg
rm -rf $(1)
$(call hg_get_archive, $(1), $(2))
endef

define get_src_git
rm -rf $(1)
mkdir $(1)
(cd $(GITROOT)/`basename $(1)`; git archive --format=tar $(2)) | tar -C $(1) -x
endef

define get_src_http
dld=$(distfiles)/`echo $(2) | tr ' ()' '___'`;( ( [ -f $$dld ] || wget $(1)/$(2) -O $$dld ) && ( [ ! -f $$dld.md5 ] && (cd $(distfiles);md5sum `basename $$dld`) > $$dld.md5 || (cd $(distfiles);md5sum -c `basename $$dld.md5`) ) ) &&
endef

define get_src_pypi
$(call get_src_http,https://pypi.python.org/packages/$(1),$(2))
endef

define get_src_sf
$(call get_src_http,https://$(sfmirror).sourceforge.net/project/$(1),$(2))
endef

all: Beremiz-$(version).exe $(targets_add)


ifneq ("$(DIST)","")
include $(src)/$(DIST).mk
endif

CUSTOM := public
CUSTOM_DIR := $(src)

include $(CUSTOM_DIR)/$(CUSTOM).mk

build:
	rm -rf build
	mkdir -p build

# native toolchain, pre-built
mingwdir=build/mingw

define get_mingw
$(call get_src_sf,mingw/MinGW/Base/$(1),$(2)) tar -C $(mingwdir) -xf $$dld
endef
define get_msys
$(call get_src_sf,mingw/MSYS/Base/$(1),$(2)) tar -C $(mingwdir) -xf $$dld
endef
mingw: |build
	rm -rf $(mingwdir)
	mkdir -p $(mingwdir)
	# windows.h
	$(call get_mingw,w32api/w32api-5.0.1,w32api-5.0.1-mingw32-dev.tar.xz)
	# mingw runtime
	$(call get_mingw,mingwrt/mingwrt-5.0.1,mingwrt-5.0.1-mingw32-dll.tar.xz)
	# mingw headers and lib
	$(call get_mingw,mingwrt/mingwrt-5.0.1,mingwrt-5.0.1-mingw32-dev.tar.xz)
	# binutils
	$(call get_mingw,binutils/binutils-2.28,binutils-2.28-1-mingw32-bin.tar.xz)
	# C compiler
	$(call get_mingw,gcc/Version6/gcc-6.3.0,gcc-core-6.3.0-1-mingw32-bin.tar.xz)
	# dependencies
	$(call get_mingw,gmp/gmp-6.1.2,libgmp-6.1.2-2-mingw32-dll-10.tar.xz)
	$(call get_mingw,mpc/mpc-1.0.3,libmpc-1.0.3-1-mingw32-dll-3.tar.xz)
	$(call get_mingw,mpfr/mpfr-3.1.5,libmpfr-3.1.5-1-mingw32-dll-4.tar.xz)
	$(call get_mingw,gettext/gettext-0.18.3.2-2,libintl-0.18.3.2-2-mingw32-dll-8.tar.xz)
	$(call get_mingw,gettext/gettext-0.18.3.2-2,libgettextpo-0.18.3.2-2-mingw32-dll-0.tar.xz)
	$(call get_mingw,libiconv/libiconv-1.14-3,libiconv-1.14-3-mingw32-dll.tar.lzma)

	# make, bash, and dependencies
	$(call get_msys,bash/bash-3.1.23-1,bash-3.1.23-1-msys-1.0.18-bin.tar.xz)
	$(call get_msys,coreutils/coreutils-5.97-3,coreutils-5.97-3-msys-1.0.13-bin.tar.lzma)
	$(call get_msys,libiconv/libiconv-1.14-1,libiconv-1.14-1-msys-1.0.17-bin.tar.lzma)
	$(call get_msys,libiconv/libiconv-1.14-1,libiconv-1.14-1-msys-1.0.17-dll-2.tar.lzma)
	$(call get_msys,gettext/gettext-0.18.1.1-1,libintl-0.18.1.1-1-msys-1.0.17-dll-8.tar.lzma)
	$(call get_msys,regex/regex-1.20090805-2,libregex-1.20090805-2-msys-1.0.13-dll-1.tar.lzma)
	$(call get_msys,termcap/termcap-0.20050421_1-2,libtermcap-0.20050421_1-2-msys-1.0.13-dll-0.tar.lzma)
	$(call get_msys,make/make-3.81-3,make-3.81-3-msys-1.0.13-bin.tar.lzma) 
	$(call get_msys,msys-core/msys-1.0.19-1,msysCORE-1.0.19-1-msys-1.0.19-bin.tar.xz)
	$(call get_msys,termcap/termcap-0.20050421_1-2,libtermcap-0.20050421_1-2-msys-1.0.13-dll-0.tar.lzma)
	touch $@

msiexec = WINEPREFIX=$(tmp) msiexec
wine = WINEPREFIX=$(tmp) wine
pydir = build/python
pysite = $(pydir)/Lib/site-packages

python: |build
	rm -rf $(pydir)
	mkdir -p $(pydir)

	# Python
	$(call get_src_http,http://www.python.org/ftp/python/2.7.2,python-2.7.2.msi)\
	$(msiexec) /qn /a $$dld TARGETDIR=.\\$(pydir)

	# WxPython (needs running inno unpacker in wine)
	$(call get_src_sf,innounp/innounp/innounp%200.36,innounp036.rar)\
	unrar e $$dld innounp.exe $(tmp)
	$(call get_src_sf,wxpython/wxPython/2.8.12.1,wxPython2.8-win32-unicode-2.8.12.1-py27.exe)\
	$(wine) $(tmp)/innounp.exe -d$(tmp) -x $$dld
	cp -R $(tmp)/\{code_GetPythonDir\}/* $(pydir)
	cp -R $(tmp)/\{app\}/* $(pysite)

	# wxPython fails if VC9.0 bullshit is not fully here.
	$(call get_src_http,http://download.microsoft.com/download/1/1/1/1116b75a-9ec3-481a-a3c8-1777b5381140,vcredist_x86.exe)\
	cp $$dld $(tmp)
	$(wine) $(tmp)/vcredist_x86.exe /qn /a
	cp $(tmp)/drive_c/windows/winsxs/x86_Microsoft.VC90.CRT*/* $(pydir)

	# MathPlotLib
	$(call get_src_http,https://github.com/downloads/matplotlib/matplotlib,matplotlib-1.2.0.win32-py2.7.exe)\
	unzip -d $(tmp)/mathplotlib $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/mathplotlib/PLATLIB/* $(pysite)

	# pywin32
	$(call get_src_sf,pywin32/pywin32/Build216,pywin32-216.win32-py2.7.exe)\
	unzip -d $(tmp)/pw32 $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/pw32/PLATLIB/* $(pysite)

	# zope.interface
	$(call get_src_pypi,9d/2d/beb32519c0bd19bda4ac38c34db417d563ee698518e582f951d0b9e5898b,zope.interface-4.3.2-py2.7-win32.egg)\
	unzip -d $(tmp) $$dld
	cp -R $(tmp)/zope $(pysite)

	# Twisted
	$(call get_src_pypi,2.7/T/Twisted,Twisted-11.0.0.winxp32-py2.7.msi)\
	$(msiexec) /qn /a $$dld TARGETDIR=.\\$(pydir)

	# Nevow
	$(call get_src_pypi,source/N/Nevow,Nevow-0.10.0.tar.gz)\
	tar -C $(tmp) -xzf $$dld
	for i in nevow formless twisted; do cp -R $(tmp)/Nevow-0.10.0/$$i $(pysite); done

	# Numpy
	$(call get_src_pypi,2.7/n/numpy,numpy-1.6.1.win32-py2.7.exe)\
	unzip -d $(tmp)/np $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/np/PLATLIB/* $(pysite)

	# SimpleJson
	$(call get_src_pypi,source/s/simplejson,simplejson-2.2.1.tar.gz)\
	tar -C $(tmp) -xzf $$dld
	cp -R $(tmp)/simplejson-2.2.1/simplejson/ $(pysite)

	# Zeroconf
	$(call get_src_pypi,6b/88/48dbe88b10098f98acef33218763c5630b0081c7fd0849ab4793b1e9b6d3,zeroconf-0.19.1-py2.py3-none-any.whl)\
	unzip -d $(tmp)/zeroconf $$dld
	cp -R $(tmp)/zeroconf/* $(pysite)

	# Enum34
	$(call get_src_pypi,c5/db/e56e6b4bbac7c4a06de1c50de6fe1ef3810018ae11732a50f15f62c7d050,enum34-1.1.6-py2-none-any.whl)\
	unzip -d $(tmp)/enum34 $$dld
	cp -R $(tmp)/enum34/* $(pysite)	

	# netifaces
	$(call get_src_pypi,05/00/c719457bcb8f14f9a7b9244c3c5e203c40d041a364cf784cf554aaef8129,netifaces-0.10.6-py2.7-win32.egg)\
	unzip -d $(tmp)/netifaces $$dld
	cp -R $(tmp)/netifaces/* $(pysite)	

	# Six
	$(call get_src_pypi,67/4b/141a581104b1f6397bfa78ac9d43d8ad29a7ca43ea90a2d863fe3056e86a,six-1.11.0-py2.py3-none-any.whl)\
	unzip -d $(tmp)/six $$dld
	cp -R $(tmp)/six/* $(pysite)	


	# WxGlade
	$(call get_src_http,https://bitbucket.org/wxglade/wxglade/get,034d891cc947.zip)\
	unzip -d $(tmp) $$dld
	mv $(tmp)/wxglade-wxglade-034d891cc947 $(pysite)/wxglade

	# Pyro
	$(call get_src_pypi,source/P/Pyro,Pyro-3.9.1.tar.gz)\
	tar -C $(tmp) -xzf $$dld
	mv $(tmp)/Pyro-3.9.1/Pyro $(pysite)

	# Lxml
	$(call get_src_pypi,2.7/l/lxml,lxml-3.2.3.win32-py2.7.exe)\
	unzip -d $(tmp)/lxml $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/lxml/PLATLIB/* $(pysite)

	touch $@

matiecdir = build/matiec
matiec: |build
	$(call get_src_hg,$(tmp)/matiec)
	cd $(tmp)/matiec ;\
	autoreconf;\
	automake --add-missing;\
	./configure --host=$(CROSS_COMPILE);\
	make -j$(CPUS);
	rm -rf $(matiecdir)
	mkdir -p $(matiecdir)
	mv $(tmp)/matiec/*.exe $(matiecdir)

	# install necessary shared libraries from local cross-compiler
	$(call get_runtime_libs,$(matiecdir))

	mv $(tmp)/matiec/lib $(matiecdir)
	touch $@

examples: |build
	rm -rf  examples
	mkdir -p examples

beremiz: | build examples
	$(call get_src_hg,build/beremiz)
	$(call tweak_beremiz_targets)
	rm -rf examples/canopen_tests
	mkdir -p examples/canopen_tests
	mv build/beremiz/tests/canopen_* examples/canopen_tests
	rm -rf examples/base_tests
	mkdir -p examples/base_tests
	mv build/beremiz/tests/* examples/base_tests
	touch $@

CFbuild = build/CanFestival-3
CFconfig = $(CFbuild)/objdictgen/canfestival_config.py
canfestival: mingw
	rm -rf $(CFbuild)
	$(call get_src_hg,$(CFbuild))
	cd $(CFbuild); \
	./configure --can=tcp_win32 \
				--cc=$(CC) \
				--cxx=$(CXX) \
				--target=win32 \
				--wx=0
	$(MAKE) -C $(CFbuild)
	cd $(CFbuild); find . -name "*.o" -exec rm {} ';' #remove object files only
	touch $@

targets=python mingw matiec beremiz
Beremiz-$(version).exe: $(targets) $(src)/license.txt $(src)/install.nsi $(targets_ex)
	sed -e 's/\$$BVERSION/$(version)/g' $(src)/license.txt > build/license.txt
	sed -e 's/\$$BVERSION/$(version)/g' $(src)/install.nsi |\
	sed -e 's/\$$BEXTENSIONS/$(extensions)/g' |\
        makensis -

clean_installer:
	rm -rf build Beremiz-$(version).exe $(targets) $(targets_ex)


