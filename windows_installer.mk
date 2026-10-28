
installer:
	mkdir -p installer

CURDIR:=$(shell pwd)
MSYS_DIR=msys64
MSYSTEM=UCRT64
MSYS_ENV_DIR=ucrt64
MSYS_ENV=mingw-w64-ucrt-x86_64
MSYS_ROOT=$(CURDIR)/$(MSYS_DIR)

XVFBRUN ?= xvfb-run -a

msysfinaldir=installer/$(MSYS_DIR)

# path of a linux file as seen by MSYS2 programs run in wine (Z: is linux root)
msyspath = /z$(abspath $(1))

# MSYS2's own pacman, run in wine, using build-time configuration
define pacman_call
WINEPATH="$$(winepath -w $(MSYS_ROOT)/usr/bin)" $(wine) $(MSYS_ROOT)/usr/bin/pacman.exe --config $(call msyspath,pacman.conf) $(1)
endef

pacman_update=$(call pacman_call, -Sy --noconfirm);
pacman_install=$(call pacman_call, -S $(1) --noconfirm --cachedir $(call msyspath,$(distfiles)));

# First part are python packages requested by our app and available in msys
# Second part are dependencies of packages to be later installed with pip
# Third part : neede for cross-install operation
#    -> all those packages are installed with pacman, ignoring version given in requirements.txt
define MINGW_PY_PACKAGES
	brotli
	cffi
	click
	fonttools
	lxml
	matplotlib
	msgpack
	pycountry
	u-msgpack
	zeroconf
	twisted
	pyopenssl
	pyasn1
	
	cryptography
	aiosqlite
	pytz
	sortedcontainers
	psutil

	pip
endef

define MINGW_PACKAGES_NAMES
	gcc
	make
	wxPython
	7zip
	$(foreach package, $(MINGW_PY_PACKAGES), python-$(package))
endef

define PIP_EXTRA_PACKAGES
	pip-system-certs
	service_identity
	cbor2==5.9.0
endef

define PIP_ENV
	AUTOBAHN_USE_NVX=0
endef

MINGW_PACKAGES=$(foreach package, $(MINGW_PACKAGES_NAMES), $(MSYS_ENV)-$(package))

define MSYS_PACKAGES
	git
endef

$(MSYS_DIR)/.stamp:
	rm -rf $(MSYS_DIR)

	$(call get_src_http,https://repo.msys2.org/distrib/x86_64,msys2-base-x86_64-20260322.tar.xz)\
	tar -xJf $$dld

	# Build-time pacman configuration derived from MSYS2's one :
	#  - no signature check, keyring would need pacman-key --init (slow in wine,
	#    and private key must not be shipped), so only main mirror is used
	#  - no man pages or docs, useless in installer and very slow to extract in
	#    wine (thousands of files in a single directory)
	sed -e 's/^SigLevel .*/SigLevel = Never/' \
	    -e 's|^Include = /etc/pacman.d/mirrorlist.mingw|Server = https://repo.msys2.org/mingw/$$repo/|' \
	    -e 's|^Include = /etc/pacman.d/mirrorlist.msys|Server = https://repo.msys2.org/msys/$$arch/|' \
	    -e 's|^#NoExtract .*|NoExtract = */share/man/* */share/doc/* */share/info/*|' \
	    $(MSYS_DIR)/etc/pacman.conf > pacman.conf

	# Do NOT update package lists to make build reproducible
	# All packages version are as given in base image.
	## $(pacman_update)	

	$(call pacman_install,$(MINGW_PACKAGES) $(MSYS_PACKAGES))
	touch $@

# filter-out all python-* packages already installed by pacman,
filtered_requirements.txt: $(MSYS_DIR)/.stamp sources/beremiz_src
	grep sources/beremiz/requirements_pinned.txt -i -v \
		`$(call pacman_call, -Qqs 'python-.*') | sed -e 's/$(MSYS_ENV)-python-/ -e /'` \
		`# python packages not matching the python-* naming` \
		-e wxPython \
		\
		`# and packages replaced by windows specific version` \
		-e cbor2 \
		> filtered_requirements.txt

# windows or msys2 specific packages
# cbor2 6.x needs Rust to build, 5.x has a pure python fallback
extended_requirements.txt: filtered_requirements.txt
	cp $< $@
	($(foreach package, $(PIP_EXTRA_PACKAGES), echo $(package);)) >> $@

extended_requirements.md5: extended_requirements.txt
	md5sum $< > $@.tmp
	cmp -s $@ $@.tmp && rm $@.tmp || mv $@.tmp $@

winpythonbin = $(MSYS_ROOT)/$(MSYS_ENV_DIR)/bin/python.exe
wine = WINEPREFIX=$(tmp) wine
# MSYSTEM is NOT set : MSYS2's python would use '/' as os.sep, and symlinks
# extracted from sdists (i.e. autobahn) would then be broken in wine
pip.stamp: $(MSYS_DIR)/.stamp extended_requirements.md5
	WINEPATH="`winepath -w $(MSYS_ROOT)/$(MSYS_ENV_DIR)/bin`;`winepath -w $(MSYS_ROOT)/usr/bin`" \
	$(PIP_ENV) \
	$(wine) $(winpythonbin) -m pip install --no-deps --break-system-packages -r `winepath -w extended_requirements.txt`
	touch $@

# final patching step once MSYS2 directory is in place
$(msysfinaldir)/.stamp: pip.stamp | installer
	rm -rf $(msysfinaldir)
	cp -a $(MSYS_DIR) $(msysfinaldir)

	# Ensure that app's home directory is set to in Beremiz's AppData
	sed -i '/^db_home:/c\db_home: /%H/AppData/Roaming/Beremiz' $(msysfinaldir)/etc/nsswitch.conf

	# Neutralize wxPython's svg module, broken in MSYS2 
	# and that matplotlib tries to import, causing a crash.
	sed -i 's/^/# /' $(msysfinaldir)/$(MSYS_ENV_DIR)/lib/python3.*/site-packages/wx/svg/__init__.py
	
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

# CAN drivers cross-built into canfestival for Windows (CMake list, ';'-separated).
# peak_windows is omitted: it needs the proprietary PEAK PCANLight SDK headers + import lib.
CANFESTIVAL_WINDOWS_CAN_DRIVERS = virtual

canfestivaldir = installer/canfestival
canfestival: $(canfestivaldir)/.stamp
$(canfestivaldir)/.stamp: sources/canfestival_src | installer
	rm -rf $(canfestivaldir)
	cp -a sources/canfestival $(canfestivaldir)
	cd $(canfestivaldir);\
	cmake -S . -B build -G "Unix Makefiles" \
		-DCMAKE_SYSTEM_NAME=Windows \
		-DCMAKE_C_COMPILER=$(CROSS_COMPILE)-gcc \
		-DCMAKE_RC_COMPILER=$(CROSS_COMPILE)-windres \
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON \
		-DCMAKE_SHARED_LINKER_FLAGS="-static -static-libgcc" \
		-DCF_TARGET=windows \
		-DCF_TIMERS_DRIVER=windows \
		-DCF_ENABLE_DLL_DRIVERS=ON \
		-DCF_CAN_DRIVER="$(CANFESTIVAL_WINDOWS_CAN_DRIVERS)" ;\
	$(MAKE) -C build -j$(CPUS)
	touch $@

beremizdir = installer/beremiz

beremiz: $(beremizdir)/.stamp
$(beremizdir)/.stamp:  sources/beremiz_src | installer
	rm -rf $(beremizdir);\
	cp -a sources/beremiz $(beremizdir);
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

beremiz-windows-build: $(src)/license.txt \
                       $(src)/beremiz_ide.cmd \
					   $(src)/plcopen_editor.cmd \
					   $(src)/winpaths.py \
					   $(msysfinaldir)/.stamp \
					   pip.stamp \
					   $(matiecdir)/.stamp \
					   $(beremizdir)/.stamp \
					   ide_targets_from_dist \
					   | $(ide_revisions) # revisions.txt is regenated even if no changes
	
	export BVERSION=`python3 $(VERSIONPY)` ;\
	sed -e "s/\$$BVERSION/$$BVERSION/g" $(src)/license.txt > installer/license.txt
	
	sed -e "s#\$$MSYS_DIR#$(MSYS_DIR)#g" $(src)/beremiz_ide.cmd |\
	sed -e "s#\$$MSYSTEM#$(MSYSTEM)#g" |\
	sed -e "s#\$$MSYS_ENV_DIR#$(MSYS_ENV_DIR)#g" > installer/beremiz_ide.cmd
	
	sed -e "s#\$$MSYS_DIR#$(MSYS_DIR)#g" $(src)/beremiz_select_sdk.cmd |\
	sed -e "s#\$$MSYSTEM#$(MSYSTEM)#g" |\
	sed -e "s#\$$MSYS_ENV_DIR#$(MSYS_ENV_DIR)#g" > installer/beremiz_select_sdk.cmd
	
	sed -e "s#\$$MSYS_DIR#$(MSYS_DIR)#g" $(src)/plcopen_editor.cmd |\
	sed -e "s#\$$MSYSTEM#$(MSYSTEM)#g" |\
	sed -e "s#\$$MSYS_ENV_DIR#$(MSYS_ENV_DIR)#g" > installer/plcopen_editor.cmd
    
	sed -e "s#\$$MSYS_DIR#$(MSYS_DIR)#g" $(src)/winpaths.py |\
	sed -e "s#\$$MSYS_ENV_DIR#$(MSYS_ENV_DIR)#g" > installer/winpaths.py

	touch $@

beremiz-windows-portable: beremiz-windows-build
	export BVERSION=`python3 $(VERSIONPY)` ;\
	rm -f beremiz-windows-portable_$${BVERSION}_amd64.zip ;\
	cd installer; zip -r -q ../beremiz-windows-portable_$${BVERSION}_amd64.zip .
	touch $@

beremiz-windows-installer: beremiz-windows-build $(src)/install.nsi 
	export BVERSION=`python3 $(VERSIONPY)` ;\
	rm -f beremiz-windows-installer_$${BVERSION}_amd64.zip ;\
	sed -e "s/\$$BVERSION/$$BVERSION/g" $(src)/install.nsi > install.nsi
	makensis install.nsi
	touch $@


