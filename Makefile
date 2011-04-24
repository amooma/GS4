
export DESTDIR


help:
	@ echo ""
	@ echo " ## Targets:"
	@ echo ""
	@ echo " make install..................: Install"
	@ echo " make deb .....................: Make Debian packages."
	@ echo " make clean ...................: Remove all generated files"
	@ echo ""


#all:


#install:
#	@echo "HELLO WORLD"
#	#$(INSTALL) -m 644 ...... "$(DESTDIR)/foobar"


install:
	#git status | grep -q 'nothing to commit (working directory clean)'
	#bundle install
	#bundle install --path .
	#bundle install --deployment
	#bundle check
	# package gems into vendor/cache/
	bundle package
	#bundle install --local --deployment


clean:
	@# called by debian/rules clean
	# remove stuff that we don't want in the Debian package
	find . -type f -name .DS_Store -print0 | xargs -0 -n 1 --no-run-if-empty rm


deb: _have-dpkg-buildpackage
	@#dpkg-checkbuilddeps
	dpkg-buildpackage -b -tc -us -uc

_have-dpkg-buildpackage:
	@ echo "Checking for dpkg-buildpackage ..."
	@ if [ -z `which dpkg-buildpackage` ]; then \
		echo '##############################################################' ;\
		echo '#  dpkg-buildpackage not found.                              #' ;\
		if [ `which aptitude 2>>/dev/null` ]; then \
			echo '#  Please install dpkg-dev.                                  #' ;\
			echo '#  ( sudo aptitude install dpkg-dev )' ;\
		else \
			echo "#  Huh? aptitude not found." ;\
			if [ ! -e "/etc/debian_version" ]; then \
				echo "#  This system doesn't appear to be Debian. It's unlikely    #" ;\
				echo "#  that you will be able to build Debian packages.           #" ;\
			fi ;\
		fi ;\
		echo '##############################################################' ;\
		exit 1 ;\
	fi


