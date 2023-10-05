# Win32 only distribution

main_target: Beremiz-nsis-installer.exe Beremiz-portable.zip

include $(src)/windows_installer.mk

ide_targets_from_dist:
	touch $@

# TODO CANFESTIVAL
# TODO MODBUS
# TODO OPCUA

# DIST_FROM_SOURCE_PROJECTS=canfestival Modbus open62541

# ide_targets_from_dist: canfestival Modbus open62541
# 	touch $@


# canfestival_dir = installer/canfestival
# canfestival: $(canfestival_dir)/.stamp
# $(canfestival_dir)/.stamp: sources/canfestival_src | installer
# canfestival: $(canfestival_dir)/.stamp
# 	rm -rf $(canfestival_dir)
# 	cp -a sources/canfestival $(canfestival_dir)
# 	cd $(canfestival_dir); \
# 	./configure --can=tcp_win32 \
# 				--cc=$(CC) \
# 				--cxx=$(CXX) \
# 				--target=win32 \
# 				--wx=0
# 	$(MAKE) -C $(canfestival_dir)
# 	cd $(canfestival_dir); find . -name "*.o" -exec rm {} ';' #remove object files only
# 	touch $@

