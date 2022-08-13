TIMESTAMP=$(shell date '+%y.%m.%d')

CROSS_COMPILE=i686-w64-mingw32
CROSS_COMPILE_LIBS_DIR=$(shell dirname $(shell $(CROSS_COMPILE)-gcc -print-libgcc-file-name))
CC=$(CROSS_COMPILE)-gcc
CXX=$(CROSS_COMPILE)-g++

installer:
	mkdir -p installer


CURDIR:=$(shell pwd)
PACMANPFX=$(CURDIR)/pacman
msysdir=msys32
MSYS_ROOT=$(CURDIR)/$(msysdir)

XVFBRUN ?= xvfb-run -a

mingw32dir=$(msysdir)/mingw32
mingw32finaldir=installer/mingw32

pacman/.stamp:
	rm -rf pacman pacman-6.0.0
	$(call get_src_http,https://sources.archlinux.org/other/pacman,pacman-6.0.0.tar.xz)\
	tar -xJf $$dld
	cd pacman-6.0.0 ;\
	patch -p1 < $(src)/pacman-6.0.0-nogpg-relative_conf.patch ;\
	meson -Droot-dir=$(MSYS_ROOT) -Dsysconfdir=$(MSYS_ROOT)/etc -Dlocalstatedir=$(MSYS_ROOT)/var build ;\
	DESTDIR=$(PACMANPFX) ninja -C build install
	touch $@

define pacman_install
LD_LIBRARY_PATH=$(PACMANPFX)/usr/lib/x86_64-linux-gnu/ fakeroot pacman/usr/bin/pacman -S $(1) --arch i686 --noconfirm --cachedir $(distfiles)
endef

$(msysdir)/.stamp: pacman/.stamp 
	rm -rf $(msysdir)
	$(call get_src_http,http://repo.msys2.org/distrib/i686,msys2-base-i686-20210705.tar.xz)\
	tar -xJf $$dld
	touch $@

$(mingw32dir)/.stamp: $(msysdir)/.stamp 
	$(call pacman_install, mingw-w64-i686-gcc)
	touch $@

# this takes just a fraction of msys2, but for now only this is needed
$(mingw32finaldir): $(mingw32dir)/.stamp | installer
	rm -rf $(mingw32finaldir)
	cp -a $(mingw32dir) $(mingw32finaldir)

msiexec = WINEPREFIX=$(tmp) $(XVFBRUN) msiexec
wine = WINEPREFIX=$(tmp) $(XVFBRUN) wine
pydir = installer/python
pysite = $(pydir)/Lib/site-packages

python: $(pydir)/.stamp
$(pydir)/.stamp: | installer
	rm -rf $(pydir)
	mkdir -p $(pydir)
	
	# Python
	$(call get_src_http,http://www.python.org/ftp/python/2.7.13,python-2.7.13.msi)\
	$(msiexec) /qn /i $$dld TARGETDIR=.\\$(pydir)
	
	# # wxPython fails if VC9.0 redistribuable is not fully here.
	# $(call get_src_http,http://download.microsoft.com/download/1/1/1/1116b75a-9ec3-481a-a3c8-1777b5381140,vcredist_x86.exe)\
	# cp $$dld $(tmp)
	# $(wine) $(tmp)/vcredist_x86.exe /qn /i
	# cp -fu $(tmp)/drive_c/windows/winsxs/x86_microsoft.vc90*/* $(pydir)
	
	$(wine) $(pydir)/python.exe -m pip install --only-binary :all: --cache-dir $(distfiles) \
        wxPython            \
        future              \
        matplotlib          \
        pywin32             \
        twisted             \
        pyOpenSSL           \
        Nevow               \
        autobahn            \
        msgpack_python      \
        u-msgpack-python    \
        zeroconf-py2compat  \
        lxml                \
        sslpsk              \
        pycountry           \
        fonttools           \
        Brotli
	
	$(wine) $(pydir)/python.exe -m pip install --cache-dir $(distfiles) \
        Pyro                \
        gnosis              
	
	# # FIXME : this uses 'some' binaries of openssl that forces us to stick to python 2.7.13
	# # FIXME : (from here : https://www.npcglib.org/~stathis/blog/precompiled-openssl/)
	# # FIXME : build it, and use openssl binaries from https://github.com/python/cpython-bin-deps/tree/openssl-bin-1.0.2k
	# WxGlade
	$(call get_src_http,https://github.com/wxGlade/wxGlade/archive,v0.8.3.zip)\
	unzip -d $(tmp) $$dld
	mv $(tmp)/wxGlade-0.8.3 $(pysite)/wxglade
	
	touch $@

matiecdir = installer/matiec
matiec: $(matiecdir)/.stamp
$(matiecdir)/.stamp: sources/matiec_src | installer
	cp -a sources/matiec $(tmp);\
	cd $(tmp)/matiec;\
	autoreconf;\
	automake --add-missing;\
	./configure --host=$(CROSS_COMPILE);\
	make -j$(CPUS);
	rm -rf $(matiecdir)
	mkdir -p $(matiecdir)
	mv $(tmp)/matiec/*.exe $(matiecdir)
	
	# install necessary shared libraries from local cross-compiler
	cp $(CROSS_COMPILE_LIBS_DIR)/libgcc_s_sjlj-1.dll $(matiecdir)
	cp $(CROSS_COMPILE_LIBS_DIR)/libstdc++-6.dll $(matiecdir)
	
	mv $(tmp)/matiec/lib $(matiecdir)
	touch $@

beremizdir = installer/beremiz

beremiz: $(beremizdir)/.stamp
$(beremizdir)/.stamp:  sources/beremiz_src | installer
	rm -rf $(beremizdir);\
	cp -a sources/beremiz $(beremizdir);\
	touch $@

ide_revisions = installer/revisions.txt
$(ide_revisions): revisions.txt
	cp $< $@ 

Beremiz-build: Beremiz-$(TIMESTAMP)_build
Beremiz-$(TIMESTAMP)_build: $(mingw32finaldir) $(pydir)/.stamp $(matiecdir)/.stamp $(beremizdir)/.stamp ide_targets_from_dist $(ide_revisions)
	touch $@

Beremiz-archive: Beremiz-$(TIMESTAMP).zip

Beremiz-installer: Beremiz-$(TIMESTAMP).exe

Beremiz-$(TIMESTAMP).zip: Beremiz-$(TIMESTAMP)_build
	rm -f $@
	cd installer; zip -r -q ../$@ .

Beremiz-$(TIMESTAMP).exe: Beremiz-$(TIMESTAMP)_build $(src)/license.txt $(src)/install.nsi 
	sed -e 's/\$$BVERSION/$(TIMESTAMP)/g' $(src)/license.txt > installer/license.txt
	sed -e 's/\$$BVERSION/$(TIMESTAMP)/g' $(src)/install.nsi |\
	makensis -



