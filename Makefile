#! gmake

# This is top level Makefile for beremiz_public_dist

# see also: 
#   build_in_docker.sh : use case example
#   provision_bionic64.sh : prerequisites

all: Beremiz-installer

DIST ?= win32

src := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
HGREMOTE ?= REMOTE_HG_DISABLED
HGROOT ?= $(abspath $(src)/..)
GITROOT := $(HGROOT)
CPUS := `cat /proc/cpuinfo | grep -e 'processor\W*:\W*[[:digit:]]*' | nl -n ln | tail -n1 | cut -f1`
BLKDEV=/dev/null

XVFBRUN ?= xvfb-run

distfiles = $(src)/distfiles
sfmirror = downloads
tmp := $(shell rm -rf $${TMPDIR:-/tmp}/beremiz_dist_build_tmp.* ; mktemp -d -t beremiz_dist_build_tmp.XXXXXXXXXX)

define hg_get_archive
	test -d $(HGROOT)/`basename $(1)` || hg --cwd $(HGROOT) clone $(HGREMOTE)`basename $(1)`;\
	hg -R $(HGROOT)/`basename $(1)` archive $(2) $(1);\
	hg -R $(HGROOT)/`basename $(1)` id -i | sed 's/\+//' > $(1)/revision;
endef

define get_src_hg
	rm -rf $(1);\
	$(call hg_get_archive, $(1), $(2))
endef

define get_src_git
	rm -rf $(1)
	test -d $(GITROOT)/`basename $(1)` || git clone $(3) $(GITROOT)/`basename $(1)`
	mkdir $(1)
	(cd $(GITROOT)/`basename $(1)`; git archive --format=tar $(2)) | tar -C $(1) -x
endef

define get_src_http
	dld=$(distfiles)/`echo $(2) | tr ' ()' '___'`;( ( [ -f $$dld ] || wget $(1)/$(2) -O $$dld ) && ( [ ! -f $$dld.md5 ] && (cd $(distfiles);md5sum `basename $$dld`) > $$dld.md5 || (cd $(distfiles);md5sum -c `basename $$dld.md5`) ) ) &&
endef

get_src_pypi=$(call get_src_http,https://pypi.python.org/packages/$(1),$(2))

get_src_sf=$(call get_src_http,https://$(sfmirror).sourceforge.net/project/$(1),$(2))

include $(src)/windows_installer.mk

ifneq ("$(DIST)","")
include $(src)/$(DIST).mk
endif

OWN_PROJECTS=beremiz matiec $(OWN_PROJECTS_EX)

define get_revision
$(1)_revision?=$(lastword $(shell grep $(1) $(src)/revisions.txt))
endef
$(foreach project,$(OWN_PROJECTS),$(eval $(call get_revision,$(project))))

define get_revisionid
$(1)_revisionid?=$(shell hg -R $(HGROOT)/$(1) id -i -r $($(1)_revision))
endef
$(foreach project,$(OWN_PROJECTS),$(eval $(call get_revisionid,$(project))))

sources:
	mkdir -p sources

define make_src_rule
sources/$(1)_src: sources/$(1)_$($(1)_revisionid)
	touch $$@

sources/$(1)_$($(1)_revisionid): | sources
	echo "Checkout HG source $(1)_$($(1)_revisionid)"
	env
	rm -rf sources/$(1)*
	$(call get_src_hg,sources/$(1),-r $($(1)_revisionid))
	touch $$@
endef
$(foreach project,$(OWN_PROJECTS),$(eval $(call make_src_rule,$(project))))

own_sources: $(foreach project,$(OWN_PROJECTS), sources/$(project)_src)
	touch $@

define show_revision_details
echo -n $(1) "revision is: "; hg -R $(HGROOT)/$(1) id -r $($(1)_revisionid);
endef

revisions.txt: $(src)/revisions.txt own_sources
	echo "Generate revisions.txt"
	echo "\n******* PACKAGE REVISIONS ********\n" > revisions.txt
	(echo -n "beremiz_dist revision is: "; hg -R $(src) id;) >> revisions.txt
	($(foreach project,$(OWN_PROJECTS),$(call show_revision_details,$(project)))) >> revisions.txt
	bash -c 'hg -R $(src) st | ( if read ; then echo -e "\n******* MODIFIED LPCDISTRO ********\n" ; hg -R $(src) st ; fi ) >> revisions.txt'



