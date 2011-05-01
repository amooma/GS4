
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
	@ echo " make local-apt-repo ..........: Create a local APT repository"
	@ echo ""
	@ exit 0



clean:
	# Remove Debian packages:
	
	find .. -type f -name 'gemeinschaft_*.dsc'       -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft_*.tar.gz'    -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft_*_*.changes' -print0 | $(XARGS_0_RM)
	
	find .. -type f -name 'gemeinschaft_*_*.deb'     -print0 | $(XARGS_0_RM)
	find .. -type f -name 'gemeinschaft-*_*_*.deb'   -print0 | $(XARGS_0_RM)
	
	[ ! -f ../Packages.gz ] || rm ../Packages.gz
	
	# Remove .bundle/config to make bundle forget the
	# --path argument:
	[ ! -e .bundle/config ] || rm .bundle/config


../Packages.gz: ../*.deb
	cd .. && dpkg-scanpackages -m . | gzip -9 > Packages.gz

local-apt-repo: ../Packages.gz
	@ if [ "$(shell id -u)." = "0." ]; then \
		echo "deb  file:$(PWD)/..  /" \
		  > /etc/apt/sources.list.d/tmp-local-gemeinschaft.list ;\
		aptitude update ;\
		echo 'aptitude search gemeinschaft' ;\
		aptitude search gemeinschaft ;\
	else \
		echo '##############################################################' ;\
		echo "#  Created ../Packages.gz." ;\
		echo "#  Please add the APT repository (as root user):" ;\
		echo '   echo "deb  file:'$(PWD)'/..  /" \\' ;\
		echo '     > /etc/apt/sources.list.d/tmp-local-gemeinschaft.list' ;\
		echo '   aptitude update' ;\
		echo '   aptitude search gemeinschaft' ;\
		echo '##############################################################' ;\
	fi


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
			| grep -vEe '^\s*size\s*[0-9]+\s*b' \
			> debian/visual-inspection/binary-info-$${binpkg}.txt ;\
		dpkg --contents ../$${binpkg}_$(DEB_VERSION)_*.deb \
			| sed 's/ [0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9] [0-9][0-9]:[0-9][0-9]/ /' \
			> debian/visual-inspection/binary-contents-$${binpkg}.txt ;\
	done
	
	@ echo "Checking if there are views that we didn't include in the package ..."
	@ for view_file in `ls -1 app/views/*/*.erb app/views/*/*/*.erb` ; do \
		pkg="gemeinschaft-common" ;\
		if ! grep -q -F "/opt/gemeinschaft/$$view_file" "debian/visual-inspection/binary-contents-$$pkg.txt" ; then \
			( \
			echo '##############################################################' ;\
			echo "#  Package $$pkg does not contain view \"$$view_file\"!" ;\
			echo '##############################################################' ;\
			) >&2 ;\
			exit 1 ;\
		fi ;\
	done
	
	@ echo "Checking if there are Ruby Gems that we didn't include in the package ..."
	@ for gem in `ls -1 vendor/cache/*.gem` ; do \
		gem=`basename "$$gem" | sed -e 's/\.gem//'` ;\
		\
		pkg="gemeinschaft-ruby-gems-native-target-compile" ;\
		found="0" ;\
		grep -q -F "/opt/gemeinschaft/vendor/cache/$$gem.gem" "debian/visual-inspection/binary-contents-$$pkg.txt" && found="1" ;\
		if [ "$$found." != "1." ]; then \
			( \
			echo '##############################################################' ;\
			echo "#  Ruby Gem \"$$gem\" not found in package" ;\
			echo "#  $$pkg" ;\
			echo '##############################################################' ;\
			) >&2 ;\
			exit 1 ;\
		fi ;\
		\
		pkg1="gemeinschaft-ruby-gems" ;\
		pkg2="gemeinschaft-ruby-gems-native" ;\
		found="0" ;\
		grep -q -F "/opt/gemeinschaft/vendor/bundle/ruby/1.9.1/gems/$$gem/" "debian/visual-inspection/binary-contents-$$pkg1.txt" && found="1" ;\
		grep -q -F "/opt/gemeinschaft/vendor/bundle/ruby/1.9.1/gems/$$gem/" "debian/visual-inspection/binary-contents-$$pkg2.txt" && found="1" ;\
		if [ "$$found." != "1." ]; then \
			( \
			echo '##############################################################' ;\
			echo "#  Ruby Gem \"$$gem\" not found in package" ;\
			echo "#  $$pkg1 or $$pkg2" ;\
			echo '##############################################################' ;\
			) >&2 ;\
			exit 1 ;\
		fi ;\
	done
	
	@ ( \
	echo '##############################################################' ;\
	echo "#  Done." ;\
	echo "#  Find the Debian packages in \"../\"." ;\
	echo "#  You may want to run 'make local-apt-repo' as root to" ;\
	echo "#  create a local APT repository and have it added to your" ;\
	echo "#  APT sources." ;\
	echo '##############################################################' ;\
	)


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

