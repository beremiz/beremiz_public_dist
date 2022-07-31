# Snap distribution

main_target: Snap

OWN_PROJECTS_EX=canfestival

tar_opts=--absolute-names --exclude=.hg --exclude=.git --exclude=.*.pyc --exclude=.*.swp

Snap: snap_built
snap_built: own_sources revisions.txt
	#cp -a $(src)/snap $(src)/revisions.txt sources
	tar -C $(src) $(tar_opts) -c snap revisions.txt | tar -C sources -x
	cd sources;  snapcraft --debug 
	touch $@
