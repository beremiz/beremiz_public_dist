#! gmake

# This is Makefile for Beremiz installer
# invoke with "make" on a linux box having those packages installed :
#  - wine
#  - mingw32
#  - tar
#  - unrar
#  - wget
#  - nsis

version = 1.03

HGROOT := ~/src
CPUS = 8

src := $(shell dirname $(lastword $(MAKEFILE_LIST)))
distfiles = $(src)/distfiles
sfmirror = ovh
tmp := $(shell mktemp -d)

define get_src_hg
hg -R $(HGROOT)/`basename $(1)` archive $(tmp)/`basename $(1)`.tar.bz2
mkdir $(1)
tar --strip-components=1 -C $(1) -xvjf $(tmp)/`basename $(1)`.tar.bz2
endef

define get_src_http
dld=$(distfiles)/$(2);[ -f $$dld ] && echo "Exists :" $(2) || wget $(1)/$(2) -O $$dld;
endef

define get_src_pypi
$(call get_src_http,http://pypi.python.org/packages/$(1),$(2))
endef

define get_src_sf
$(call get_src_http,http://$(sfmirror).dl.sourceforge.net/project/$(1),$(2))
endef

all: Beremiz-$(version).exe

mingwdir=build/mingw
mingw: 
	mkdir -p $(mingwdir)
	# windows.h
	$(call get_src_sf,mingw/MinGW/BaseSystem/RuntimeLibrary/Win32-API/w32api-3.17,w32api-3.17-2-mingw32-dev.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	# mingw runtime
	$(call get_src_sf,mingw/MinGW/BaseSystem/RuntimeLibrary/MinGW-RT/mingwrt-3.20,mingwrt-3.20-mingw32-dll.tar.gz)\
	tar -C $(mingwdir) -xvzf $$dld
	# mingw headers and lib
	$(call get_src_sf,mingw/MinGW/BaseSystem/RuntimeLibrary/MinGW-RT/mingwrt-3.20,mingwrt-3.20-mingw32-dev.tar.gz)\
	tar -C $(mingwdir) -xvzf $$dld
	# binutils
	$(call get_src_sf,mingw/MinGW/BaseSystem/GNU-Binutils/binutils-2.21.53,binutils-2.21.53-1-mingw32-bin.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	# C compiler
	$(call get_src_sf,mingw/MinGW/BaseSystem/GCC/Version4/gcc-4.6.1-2,gcc-core-4.6.1-2-mingw32-bin.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	# C++ compiler
	#$(call get_src_sf,mingw/MinGW/BaseSystem/GCC/Version4/gcc-4.6.1-2,gcc-c++-4.6.1-2-mingw32-bin.tar.lzma)\
	#tar -C $(mingwdir) --lzma -xvf $$dld
	# dependencies
	$(call get_src_sf,mingw/MinGW/gmp/gmp-5.0.1-1,libgmp-5.0.1-1-mingw32-dll-10.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	$(call get_src_sf,mingw/MinGW/mpc/mpc-0.8.1-1,libmpc-0.8.1-1-mingw32-dll-2.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	$(call get_src_sf,mingw/MinGW/mpfr/mpfr-2.4.1-1,libmpfr-2.4.1-1-mingw32-dll-1.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	#$(call get_src_sf,mingw/MinGW/pthreads-w32/pthreads-w32-2.9.0-pre-20110507-2,libpthreadgc-2.9.0-mingw32-pre-20110507-2-dll-2.tar.lzma)\
	#tar -C $(mingwdir) --lzma -xvf $$dld
	#$(call get_src_sf,mingw/MinGW/pthreads-w32/pthreads-w32-2.9.0-pre-20110507-2,pthreads-w32-2.9.0-mingw32-pre-20110507-2-dev.tar.lzma)\
	#tar -C $(mingwdir) --lzma -xvf $$dld
	$(call get_src_sf,mingw/MinGW/gettext/gettext-0.17-1,libintl-0.17-1-mingw32-dll-8.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	$(call get_src_sf,mingw/MinGW/gettext/gettext-0.17-1,libgettextpo-0.17-1-mingw32-dll-0.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	$(call get_src_sf,mingw/MinGW/libiconv/libiconv-1.13.1-1,libiconv-1.13.1-1-mingw32-dll-2.tar.lzma)\
	tar -C $(mingwdir) --lzma -xvf $$dld
	
	touch mingw

# a directory to collect binaries that must be in the path
bin_collect_dir = $(mingwdir)/bin
$(bin_collect_dir): mingw

msiexec = WINEPREFIX=$(tmp) msiexec
wine = WINEPREFIX=$(tmp) wine
pydir = build/python
pysite = $(pydir)/Lib/site-packages

python: $(bin_collect_dir)
	# Python
	$(call get_src_http,http://www.python.org/ftp/python/2.7.2,python-2.7.2.msi)\
	$(msiexec) /qn /a $$dld TARGETDIR=.\\$(pydir)
	cp $(tmp)/drive_c/windows/system32/msvcr71.dll $(bin_collect_dir)
	cp $(pydir)/python27.dll $(bin_collect_dir)
	
	# WxPython (needs running inno unpacker in wine)
	$(call get_src_sf,innounp/innounp/innounp%200.36,innounp036.rar)\
	unrar e $$dld innounp.exe $(tmp)
	$(call get_src_sf,wxpython/wxPython/2.8.12.1,wxPython2.8-win32-unicode-2.8.12.1-py27.exe)\
	$(wine) $(tmp)/innounp.exe -d$(tmp) -x $$dld
	cp -R $(tmp)/\{code_GetPythonDir\}/* $(pydir)
	cp -R $(tmp)/\{app\}/* $(pysite)
	
	# pywin32
	$(call get_src_sf,pywin32/pywin32/Build216,pywin32-216.win32-py2.7.exe)\
	unzip -d $(tmp)/pw32 $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/pw32/PLATLIB/* $(pysite)
	cp $(pysite)/pywin32_system32/*.dll $(bin_collect_dir)
	
	# Twisted
	$(call get_src_pypi,2.7/T/Twisted,Twisted-11.0.0.winxp32-py2.7.msi)\
	$(msiexec) /qn /a $$dld TARGETDIR=.\\$(pydir)
	
	# Nevow
	$(call get_src_pypi,source/N/Nevow,Nevow-0.10.0.tar.gz)\
	tar -C $(tmp) -xvzf $$dld
	for i in nevow formless twisted; do cp -R $(tmp)/Nevow-0.10.0/$$i $(pysite); done
	
	# Numpy
	$(call get_src_pypi,2.7/n/numpy,numpy-1.6.1.win32-py2.7.exe)\
	unzip -d $(tmp)/np $$dld ; [ $$? -eq 1 ] #silence error unziping .exe
	cp -R $(tmp)/np/PLATLIB/* $(pysite)
	
	# SimpleJson
	$(call get_src_pypi,source/s/simplejson,simplejson-2.2.1.tar.gz)\
	tar -C $(tmp) -xvzf $$dld
	cp -R $(tmp)/simplejson-2.2.1/simplejson/ $(pysite)
	
	# WxGlade
	$(call get_src_http,https://bitbucket.org/agriggio/wxglade/get,b0247325407e.zip)\
	unzip -d $(tmp) $$dld 
	mv $(tmp)/agriggio-wxglade-b0247325407e $(pysite)/wxglade
	
	# Pyro
	$(call get_src_pypi,source/P/Pyro,Pyro-3.15.tar.gz)\
	tar -C $(tmp) -xvzf $$dld
	mv $(tmp)/Pyro-3.15/Pyro $(pysite)
	
	touch python

matiecdir = build/matiec
matiec: 
	$(call get_src_hg,$(tmp)/matiec)
	cd $(tmp)/matiec ;\
	./configure --host=i586-mingw32msvc;\
	make -j$(CPUS);
	mkdir $(matiecdir)
	mv $(tmp)/matiec/*.exe $(matiecdir)
	mv $(tmp)/matiec/lib $(matiecdir)
	touch matiec
	
plcopeneditor:
	$(call get_src_hg,build/plcopeneditor)
	touch plcopeneditor

beremiz:
	$(call get_src_hg,build/beremiz)
	touch beremiz

Beremiz-$(version).exe: python mingw matiec plcopeneditor beremiz
	sed -e 's/\$$BVERSION/$(version)/g' $(src)/license.txt > build/license.txt
	sed -e 's/\$$BVERSION/$(version)/g' $(src)/install.nsi | makensis - 
	

