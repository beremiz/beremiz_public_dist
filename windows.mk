# Windows distribution

main_target: beremiz-windows-installer beremiz-windows-portable

include $(src)/windows_installer.mk

DIST_FROM_SOURCE_PROJECTS=canfestival # Modbus open62541

ide_targets_from_dist: canfestival # Modbus open62541
	touch $@