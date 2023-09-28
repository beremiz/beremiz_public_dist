
installer:
	mkdir -p installer
	cp $(src)/winpaths.py installer


CURDIR:=$(shell pwd)
PACMANPFX=$(CURDIR)/pacman
MSYS_DIR=msys64
MSYS_ENV_DIR=ucrt64
MSYS_ENV=mingw-w64-ucrt-x86_64
MSYS_ROOT=$(CURDIR)/$(MSYS_DIR)

XVFBRUN ?= xvfb-run -a

msysfinaldir=installer/$(MSYS_DIR)

pacman-6.0.0/src.stamp:
	rm -rf pacman pacman-6.0.0
	$(call get_src_http,https://sources.archlinux.org/other/pacman,pacman-6.0.0.tar.xz)\
	tar -xJf $$dld
	touch $@

pacman-6.0.0/patched.stamp: pacman-6.0.0/src.stamp
	cd pacman-6.0.0 ;\
	patch -p1 < $(src)/pacman-6.0.0-nogpg-relative_conf.patch ;
	touch $@

pacman/.stamp: pacman-6.0.0/patched.stamp
	cd pacman-6.0.0 ;\
	meson -Droot-dir=$(MSYS_ROOT) -Dsysconfdir=$(MSYS_ROOT)/etc -Dlocalstatedir=$(MSYS_ROOT)/var build ;\
	DESTDIR=$(PACMANPFX) ninja -C build install
	touch $@

define pacman_call
LD_LIBRARY_PATH=$(PACMANPFX)/usr/lib/x86_64-linux-gnu/ fakeroot pacman/usr/bin/pacman $(1)
endef

pacman_update=$(call pacman_call, -Sy --noconfirm --cachedir $(distfiles));
pacman_install_ming=$(call pacman_call, -S $(1) --arch x86_64 --noconfirm --cachedir $(distfiles));
pacman_install_msys=$(call pacman_call, -S $(1) --noconfirm --cachedir $(distfiles));

# First part are python packages requested by our app and available in msys
# Second part are dependencies of packages to be later installed with pip
# Third part : neede for cross-install operation
#    -> all those packages are installed with pacman, ignoring version given in requirements.txt
define MSYS_PY_PACKAGES
	brotli
	click
	fonttools
	lxml
	matplotlib
	msgpack
	pycountry
	u-msgpack
	zeroconf
	twisted
	
	cryptography
	aiosqlite
	pytz
	sortedcontainers

	pip
endef

define MSYS_PACKAGES_NAMES
	gcc
	make
	wxPython
	$(foreach package, $(MSYS_PY_PACKAGES), python-$(package))
endef

MSYS_PACKAGES=$(foreach package, $(MSYS_PACKAGES_NAMES), $(MSYS_ENV)-$(package))

$(MSYS_DIR)/.stamp: pacman/.stamp 
	rm -rf $(MSYS_DIR)

	$(call get_src_http,https://repo.msys2.org/distrib/x86_64,msys2-base-x86_64-20230718.tar.xz)\
	tar -xJf $$dld

	# Do NOT update package lists to make build reproducible
	# All packages version are as given in base image.
	## $(pacman_update)	

	$(call pacman_install_ming,$(MSYS_PACKAGES))
	touch $@

# filter-out all python packages already installed by pacman
filtered_requirements.txt: $(MSYS_DIR)/.stamp sources/beremiz_src
	grep sources/beremiz/requirements.txt -i -v \
		`$(call pacman_call, -Qqs 'python-.*') | sed -e 's/$(MSYS_ENV)-python-/ -e /'` \
		-e wxPython \
		$(foreach package, $(MSYS_PY_PACKAGES), -e $(package)) > filtered_requirements.txt

# download remaining pip packages separtately with local python
# workaround msys2's git crashing when launched from pip on wine
# bug: https://bugs.winehq.org/show_bug.cgi?id=40528
pip_downloads/.stamp: filtered_requirements.txt
	rm -rf pip_downloads
	# python3 -m pip download --no-deps -r filtered_requirements.txt -d pip_downloads
	python3 -m pip wheel --no-deps -r filtered_requirements.txt -w pip_downloads
	touch $@

# install downloaded .whl files with wine
# TODO: find a less convoluited way instead of wine to unpack wheels
#       but still populating __pycache__ for this particular python version
winpythonbin = $(MSYS_ROOT)/$(MSYS_ENV_DIR)/bin/python.exe
wine = WINEPREFIX=$(tmp) $(XVFBRUN) wine
pip.stamp: pip_downloads/.stamp
	cd pip_downloads; $(wine) $(winpythonbin) -m pip install --no-deps *
	touch $@

$(msysfinaldir)/.stamp: pip.stamp | installer
	rm -rf $(msysfinaldir)
	cp -a $(MSYS_DIR) $(msysfinaldir)
	touch $@

CROSS_COMPILE=x86_64-w64-mingw32
CROSS_COMPILE_LIBS_DIR=$(shell dirname $(shell $(CROSS_COMPILE)-gcc -print-libgcc-file-name))

matiecdir = installer/matiec
matiec: $(matiecdir)/.stamp
$(matiecdir)/.stamp: sources/matiec_src | installer
	cp -a sources/matiec $(tmp);\
	cd $(tmp)/matiec;\
	autoreconf ;\
	automake --add-missing ;\
	LDFLAGS=-lstdc++ ./configure --host=$(CROSS_COMPILE);\
	$(MAKE) -j$(CPUS);
	rm -rf $(matiecdir)
	mkdir -p $(matiecdir)
	mv $(tmp)/matiec/*.exe $(matiecdir)
	
	# install necessary shared libraries from local cross-compiler
	cp $(CROSS_COMPILE_LIBS_DIR)/libgcc_s_seh-1.dll $(matiecdir)
	cp $(CROSS_COMPILE_LIBS_DIR)/libstdc++-6.dll $(matiecdir)
	
	mv $(tmp)/matiec/lib $(matiecdir)
	touch $@

beremizdir = installer/beremiz

beremiz: $(beremizdir)/.stamp
$(beremizdir)/.stamp:  sources/beremiz_src | installer
	rm -rf $(beremizdir);\
	cp -a sources/beremiz $(beremizdir);\
	# populate __pycache__'s .pyc files
	cd $(beremizdir) ;\
		find . -name "*.py" | grep -v \
			-e \./etherlab \
			-e .*/web_settings.py \
			-e \./tests \
			-e \./exemples \
			> tocompile.lst ;\
		$(wine) $(winpythonbin) -m compileall -i tocompile.lst
	rm $(beremizdir)/tocompile.lst
	touch $@

ide_revisions = installer/revisions.txt
$(ide_revisions): revisions.txt
	cp $< $@ 

Beremiz-windows-build: $(msysfinaldir)/.stamp pip.stamp $(matiecdir)/.stamp $(beremizdir)/.stamp ide_targets_from_dist $(ide_revisions)
	touch $@

Beremiz-portable.zip: Beremiz-windows-build
	rm -f $@
	cd installer; zip -r -q ../$@ .

VERSIONPY=sources/beremiz/version.py

Beremiz-nsis-installer.exe: Beremiz-windows-build $(src)/license.txt $(src)/install.nsi 
	export BVERSION=`python3 $(VERSIONPY)` ;\
	sed -e "s/\$$BVERSION/$$BVERSION/g" $(src)/license.txt > installer/license.txt ;\
	sed -e "s/\$$BVERSION/$$BVERSION/g" $(src)/install.nsi |\
	sed -e "s#\$$MSYS_DIR#$(MSYS_DIR)#g" |\
	sed -e "s#\$$MSYS_ENV_DIR#$(MSYS_ENV_DIR)#g" > install.nsi
	makensis install.nsi


