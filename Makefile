
export DESTDIR

DEB_VERSION:=$(shell dpkg-parsechangelog | sed -n -e 's/Version: //p')
PACKAGES=$(shell dh_listpackages)

XARGS_0_RM=xargs -0 -n 1 --no-run-if-empty 'rm'


help:
	@# In this case we need something that doesn't do anything as
	@# the first target because debhelper calls the Makefile
	@# without a target which executes the first target.
	
	@ echo ""
	@ echo " ## Targets:"
	@ echo ""
	@ echo " make install..................: Install"
	@ echo " make deb .....................: Make Debian packages."
	@ echo " make clean ...................: Remove all generated files"
	@ echo ""
	@ exit 0



clean:
	# Remove Debian packages:
	
	find .. -type f -name 'gemeinschaft_*.dsc'       -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft_*.tar.gz'    -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft_*_*.changes' -print0 | $(XARGS_0_RM)
	
	find .. -type f -name 'gemeinschaft_*_*.deb'     -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft-*_*_*.deb'   -print0 | $(XARGS_0_RM)



deb: _have-dpkg-buildpackage
	@ if ! dpkg-checkbuilddeps 2>>/dev/null; then \
		( \
		echo '##############################################################' ;\
		echo "#  Some build-dependencies are missing." ;\
		echo "#  Please install them." ;\
		echo '##############################################################' ;\
		) >&2 ;\
		dpkg-checkbuilddeps ;\
		exit 1 ;\
	fi
	dpkg-buildpackage -tc -us -uc
	mkdir -p debian/visual-inspection
	find debian/visual-inspection -type f -name '*.txt' -print0 \
		| xargs -0 -n 1 --no-run-if-empty 'rm'
	cat "../gemeinschaft_$(DEB_VERSION).dsc" \
		> debian/visual-inspection/source-info.txt
	tar -tf "../gemeinschaft_$(DEB_VERSION).tar.gz" \
		> debian/visual-inspection/source-contents.txt
	for binpkg in $(PACKAGES); do \
		dpkg --info ../$${binpkg}_$(DEB_VERSION)_*.deb \
			> debian/visual-inspection/binary-info-$${binpkg}.txt ;\
		dpkg --contents ../$${binpkg}_$(DEB_VERSION)_*.deb \
			| sed 's/ [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]/ /' \
			> debian/visual-inspection/binary-contents-$${binpkg}.txt ;\
	done


_have-dpkg-buildpackage:
	@ echo "Checking for dpkg-buildpackage ..."
	@ if [ -z `which dpkg-buildpackage` ]; then \
		( \
		echo '##############################################################' ;\
		echo '#  dpkg-buildpackage not found.                              #' ;\
		) >&2 ;\
		if [ `which aptitude 2>>/dev/null` ]; then \
			( \
			echo '#  Please install dpkg-dev.                                  #' ;\
			echo '#  ( sudo aptitude install dpkg-dev )' ;\
			) >&2 ;\
		else \
			echo "#  Huh? aptitude not found." ;\
			if [ ! -e "/etc/debian_version" ]; then \
				( \
				echo "#  This system doesn't appear to be Debian. It's unlikely    #" ;\
				echo "#  that you will be able to build Debian packages.           #" ;\
				) >&2 ;\
			fi ;\
		fi ;\
		( \
		echo '##############################################################' ;\
		) >&2 ;\
		exit 1 ;\
	fi




# Local Variables:
# mode: unix-shell-script
# coding: utf-8
# indent-tabs-mode: t
# End:

