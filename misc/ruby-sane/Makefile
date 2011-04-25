
XARGS_0_RM=xargs -0 -n 1 --no-run-if-empty 'rm'

help:
	@# In this case we need something that doesn't do anything as
	@# the first target because debhelper calls the Makefile
	@# without a target which executes the first target.
	
	@ echo ""
	@ echo " ## Targets:"
	@ echo ""
	@ echo " make deb .............: Make Debian packages (../)."
	@ echo " make deb-install .....: Make Debian packages & install."
	@ echo " make clean ...........: Remove Debian packages."
	@ echo ""
	@ exit 0

deb:
	@ ( \
	echo '##############################################################' ;\
	echo "#  Building Debian packages ..." ;\
	echo '##############################################################' ;\
	)
	dpkg-buildpackage -b -tc -us -uc
	@ ( \
	echo '##############################################################' ;\
	echo "#  Find the packages in ../ :" ;\
	echo '##############################################################' ;\
	)
	ls -lF --color ..

deb-install: deb
	@ if [ "$(shell id -u)." != "0." ]; then \
		echo "Need root privileges." ;\
		exit 1 ;\
	fi
	@ ( \
	echo '##############################################################' ;\
	echo "#  Installing Debian packages ..." ;\
	echo '##############################################################' ;\
	)
	#aptitude install -R dpkg-dev
	cd .. && dpkg-scanpackages -m . | gzip -9 > Packages.gz
	#aptitude markauto dpkg-dev
	echo "deb file:$(PWD)/.. /" \
	  > /etc/apt/sources.list.d/tmp-local-ruby-sane.list
	aptitude update
	aptitude install --allow-untrusted ruby-sane1.9.1 ruby-sane1.9.1-dev
	rm /etc/apt/sources.list.d/tmp-local-ruby-sane.list
	rm ../Packages.gz
	$(MAKE) clean
	ruby -v

clean:
	find .. -type f -name 'ruby-sane_*.dsc'       -print0 | $(XARGS_0_RM)
	find .. -type f -name 'ruby-sane_*.tar.gz'    -print0 | $(XARGS_0_RM)
	find .. -type f -name 'ruby-sane_*_*.changes' -print0 | $(XARGS_0_RM)
	
	find .. -type f -name 'ruby-sane*_*_*.deb'    -print0 | $(XARGS_0_RM)
	find .. -type f -name 'ruby-sane*-*_*_*.deb'  -print0 | $(XARGS_0_RM)
	
	[ ! -f ../Packages.gz ] || rm ../Packages.gz


# Local Variables:
# mode: unix-shell-script
# coding: utf-8
# indent-tabs-mode: t
# End:

