#! gmake

# This is top level Makefile for beremiz_public_dist

# see also: 
#   build_in_docker.sh : use case example
#   provision_bionic64.sh : prerequisites

all: main_target

DIST ?= win32

src := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
WORKSPACE ?= $(abspath $(src)/..)
CPUS := `cat /proc/cpuinfo | grep -e 'processor\W*:\W*[[:digit:]]*' | nl -n ln | tail -n1 | cut -f1`

distfiles = $(src)/distfiles
sfmirror = downloads
tmp := $(shell rm -rf $${TMPDIR:-/tmp}/beremiz_dist_build_tmp.* ; mktemp -d -t beremiz_dist_build_tmp.XXXXXXXXXX)

define hg_get_archive
	hg -R $(WORKSPACE)/`basename $(1)` archive $(2) $(1);\
	hg -R $(WORKSPACE)/`basename $(1)` id -i | sed 's/\+//' > $(1)/revision;
endef

define get_src_hg
	rm -rf $(1);\
	$(call hg_get_archive, $(1), $(2))
endef

define get_src_git
endef

define get_src_http
	dld=$(distfiles)/`echo $(2) | tr ' ()' '___'`;( ( [ -f $$dld ] || wget $(1)/$(2) -O $$dld ) && ( [ ! -f $$dld.md5 ] && (cd $(distfiles);md5sum `basename $$dld`) > $$dld.md5 || (cd $(distfiles);md5sum -c `basename $$dld.md5`) ) ) &&
endef

ifneq ("$(DIST)","")
include $(src)/$(DIST).mk
endif

FROM_SOURCE_PROJECTS=beremiz matiec $(DIST_FROM_SOURCE_PROJECTS)

define get_revision
$(1)_revision?=$(lastword $(shell grep $(1) $(src)/revisions.txt))
endef
$(foreach project,$(FROM_SOURCE_PROJECTS),$(eval $(call get_revision,$(project))))

tar_opts=--absolute-names --exclude=.hg --exclude=.git --exclude=.*.pyc --exclude=.*.swp --exclude=__pycache__

define get_revisionid
$(1)_revisionid ?=\
	$(if $(filter local, $($(1)_revision)),\
		$(shell tar $(tar_opts) -P -c $(WORKSPACE)/$(1) | sha1sum | cut -d ' ' -f 1),\
		$(1)_revisionid?=$$(shell hg -R $(WORKSPACE)/$(1) id -i -r $($(1)_revision)))
endef
$(foreach project,$(FROM_SOURCE_PROJECTS),$(eval $(call get_revisionid,$(project))))

sources:
	mkdir -p sources

define make_src_rule
sources/$(1)_src: sources/$(1)_$($(1)_revisionid)
	touch $$@

sources/$(1)_$($(1)_revisionid): | sources
	rm -rf sources/$(1)*
ifeq ($($(1)_revision),local)
	echo "Copy local source code for $(1)_$($(1)_revisionid)"
	tar -C $(WORKSPACE) $(tar_opts) -P -c $(1) | tar -C sources -x
else
	echo "Checkout HG source $(1)_$($(1)_revisionid)"
	$(call get_src_hg,sources/$(1),-r $($(1)_revisionid))
endif
	touch $$@
endef
$(foreach project,$(FROM_SOURCE_PROJECTS),$(eval $(call make_src_rule,$(project))))

own_sources: $(foreach project,$(FROM_SOURCE_PROJECTS), sources/$(project)_src)
	touch $@

all_sources: own_sources sources/open62541_src
	touch $@

sources/open62541_src: | sources
	rm -rf sources/open62541
	$(call get_src_http,https://github.com/open62541/open62541/archive/refs/tags,v1.3.7.tar.gz)\
	tar -xzf $$dld
	mv open62541-1.3.7 sources/open62541
	

define show_revision_details
	$(if $(filter local, $($(1)_revision)),\
		echo -n $(1) "state is: "; test -d .hg \
			&& (hg -R $(WORKSPACE)/$(1) id; echo; hg -R $(WORKSPACE)/$(1) st) \
			|| (git -C $(WORKSPACE)/$(1) show --pretty=format:'%P' -s; echo; git -C $(WORKSPACE)/$(1) status --porcelain);,\
		echo -n $(1) "revision is: "; hg -R $(WORKSPACE)/$(1) id -r $($(1)_revisionid); )
endef

revisions.txt: $(src)/revisions.txt own_sources
	echo "Generate revisions.txt"
	echo "\n******* PACKAGE REVISIONS ********\n" > revisions.txt
	(echo -n "beremiz_public_dist revision is: "; test -d .hg && (hg -R $(src) id ; echo; hg -R $(src) st) || (git -C $(src) show --pretty=format:'%P' -s; echo; git -C $(src) status --porcelain)) >> revisions.txt
	($(foreach project,$(FROM_SOURCE_PROJECTS),$(call show_revision_details,$(project)))) >> revisions.txt



