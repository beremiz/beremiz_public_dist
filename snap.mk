# Snap distribution

main_target: Snap

tar_opts=--absolute-names --exclude=.hg --exclude=.git --exclude=.*.pyc --exclude=.*.swp

Snap: snap_built
snap_built: all_sources revisions.txt
	tar -C $(src) $(tar_opts) -c snap | tar -C sources -x
	cp revisions.txt sources
	cd sources;  snapcraft --debug 
	touch $@
