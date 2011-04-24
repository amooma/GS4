
help:
	@# In this case we need something that doesn't do anything as
	@# the first target because debhelper calls the Makefile
	@# without a target which executes the first target.
	
	@ echo ""
	@ echo " ## Targets:"
	@ echo ""
	@ echo " make deb .............: Make Debian package."
	@ echo " make deb-install .....: Make Debian package & install."
	@ echo ""
	@ exit 0

deb:
	dpkg-buildpackage -b -tc -us -uc

deb-install: deb
	@ if [ "$(shell id -u)." != "0." ]; then \
		echo "Need root privileges." ;\
		exit 1 ;\
	fi
	aptitude install -R dpkg-dev
	cd .. && dpkg-scanpackages -m . | gzip -9 > Packages.gz
	aptitude markauto dpkg-dev
	echo "deb file:$(PWD)/.. /" \
	  > /etc/apt/sources.list.d/tmp-local-ruby-sane.list
	aptitude update
	aptitude install --allow-untrusted ruby-sane ruby-sane-dev
	rm /etc/apt/sources.list.d/tmp-local-ruby-sane.list
	rm ../Packages.gz
	ruby -v

