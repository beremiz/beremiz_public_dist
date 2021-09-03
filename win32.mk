# Win32 only distribution

OWN_PROJECTS_EX=CanFestival-3

ide_targets_from_dist: canfestival
	touch $@

CFbuild = installer/CanFestival-3
canfestival: $(msysdir)/.stamp
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

