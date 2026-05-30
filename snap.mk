# Snap distribution

main_target: snap_amd64 snap_arm64

DIST_FROM_SOURCE_PROJECTS=canfestival Modbus

snap_sources: all_sources $(src)/snap/snapcraft.yaml | revisions.txt  # revisions.txt is regenated even if no changes
	rm -rf sources/snap
	tar -C $(src) $(tar_opts) -c snap | tar -C sources -x
	cp revisions.txt sources
	touch $@

# Assume building on intel/amd architecture
snap_amd64: snap_sources
	cd sources; snapcraft clean ; snapcraft pack
	mv sources/beremiz_`python3 $(VERSIONPY)`_amd64.snap .
	touch $@

# Assume snapcraft is allowed to remote-build
snap_arm64: snap_sources
	cd sources; git init . ; snapcraft remote-build --launchpad-accept-public-upload --build-for arm64
	mv sources/beremiz_`python3 $(VERSIONPY)`_arm64.snap .
	touch $@
