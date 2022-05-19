# Win32 only distribution

OWN_PROJECTS_EX=CanFestival-3

ide_targets_from_dist: canfestival
	touch $@

CanFestival-3_dir = installer/CanFestival-3
CanFestival-3: $(CanFestival-3_dir)/.stamp
$(CanFestival-3_dir)/.stamp: sources/CanFestival-3_src | installer
canfestival: $(CanFestival-3_dir)/.stamp
	rm -rf $(CanFestival-3_dir)
	cp -a sources/CanFestival-3 $(CanFestival-3_dir)
	cd $(CanFestival-3_dir); \
	./configure --can=tcp_win32 \
				--cc=$(CC) \
				--cxx=$(CXX) \
				--target=win32 \
				--wx=0
	$(MAKE) -C $(CanFestival-3_dir)
	cd $(CanFestival-3_dir); find . -name "*.o" -exec rm {} ';' #remove object files only
	touch $@

