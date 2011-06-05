# Author: Philipp Kempgen
# License: GNU GPL v.2

xmllint = $(shell which xmllint)
xsltproc = $(shell which xsltproc)
tidy = $(shell which tidy)
docbook2odf = $(shell which docbook2odf)
docbook_schema_file="/usr/share/xml/docbook/schema/rng/5.0/docbookxi.rng"
docbook_xsl_path="/usr/share/xml/docbook/stylesheet/docbook-xsl"
docbook2html = $(shell which docbook2html)
docbook_sources = $(wildcard docbook/*.dbk docbook/*.xml)
docbook_index_file="docbook/index.xml"


help:
	@ echo ""
	@ echo " ### Output formats:"
	@ echo ""
#	@ echo " make odt .....................: Generate OpenOffice text file"
	@ echo " make html-onefile ............: Generate (X)HTML (one page)"
#	@ echo " make html-chunk...............: Generate (X)HTML pages"
	@ echo ""
	@ echo " ### Other make targets:"
	@ echo ""
	@ echo " make clean ...................: Remove all generated files"
	@ echo " make validate ................: Validate DocBook sources"
	@ echo "                                 (always before commit!)"
	@ echo ""


tmp:
	mkdir -p tmp
	sleep 1

tmp/_tmp_dir-stamp: tmp
	date '+%Y-%m-%d %H:%M:00 %z' > tmp/_tmp_dir-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-xmllint-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for xmllint ..."
	@ if [ -z "$(xmllint)" ]; then \
		echo '############################################################'; \
		echo '#  xmllint not found.                                      #'; \
		echo '#  Please install libxml2-utils.                           #'; \
		if [ `which aptitude 2>>/dev/null` ]; then \
			echo '#  ( sudo aptitude install libxml2-utils )'; \
		else \
		if [ `which apt-get 2>>/dev/null` ]; then \
			echo '#  ( sudo apt-get install libxml2-utils )'; \
		fi; fi; \
		echo '############################################################'; \
		exit 1; \
	fi
	date > tmp/_have-xmllint-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-xsltproc-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for xsltproc ..."
	@ if [ -z "$(xsltproc)" ]; then \
		echo '############################################################'; \
		echo '#  xsltproc not found.                                     #'; \
		echo '#  Please install xsltproc.                                #'; \
		if [ `which aptitude 2>>/dev/null` ]; then \
			echo '#  ( sudo aptitude install xsltproc )'; \
		else \
		if [ `which apt-get 2>>/dev/null` ]; then \
			echo '#  ( sudo apt-get install xsltproc )'; \
		fi; fi; \
		echo '############################################################'; \
		exit 1; \
	fi
	date > tmp/_have-xsltproc-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-tidy-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for tidy ..."
	@ if [ -z "$(tidy)" ]; then \
		echo '############################################################'; \
		echo '#  tidy not found.                                         #'; \
		echo '#  Please install Tidy.                                    #'; \
		if [ `which aptitude 2>>/dev/null` ]; then \
			echo '#  ( sudo aptitude install tidy )'; \
		else \
		if [ `which apt-get 2>>/dev/null` ]; then \
			echo '#  ( sudo apt-get install tidy )'; \
		fi; fi; \
		echo '############################################################'; \
		exit 1; \
	fi
	date > tmp/_have-tidy-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-docbook2odf-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for docbook2odf ..."
	@ if [ -z "$(docbook2odf)" ]; then \
		echo '############################################################'; \
		echo '#  docbook2odf not found.                                  #'; \
		echo '#  Please install docbook2odf.                             #'; \
		if [ `which aptitude 2>>/dev/null` ]; then \
			echo '#  ( sudo aptitude install docbook2odf )'; \
		else \
		if [ `which apt-get 2>>/dev/null` ]; then \
			echo '#  ( sudo apt-get install docbook2odf )'; \
		fi; fi; \
		echo '############################################################'; \
		exit 1; \
	fi
	date > tmp/_have-docbook2odf-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-docbook-schema-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for DocBook schema ..."
	@ if [ ! -f "$(docbook_schema_file)" ]; then \
		if [ ! -f "docbook-schema/docbookxi.rng" ]; then \
			echo '############################################################'; \
			echo '#  DocBook schema not found.                               #'; \
			echo '#  Please install docbook5-xml.                            #'; \
			if [ `which aptitude 2>>/dev/null` ]; then \
				echo '#  ( sudo aptitude install docbook5-xml )'; \
			else \
			if [ `which apt-get 2>>/dev/null` ]; then \
				echo '#  ( sudo apt-get install docbook5-xml )'; \
			fi; fi; \
			echo '############################################################'; \
			exit 1; \
		fi ;\
	fi
	date > tmp/_have-docbook-schema-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp


tmp/_have-docbook-xsl-stamp: tmp/_tmp_dir-stamp
	@ echo "Checking for DocBook XSL ..."
	@ if [ ! -d "$(docbook_xsl_path)/." ]; then \
		if [ ! -d "docbook-xsl/." ]; then \
			echo '############################################################'; \
			echo '#  DocBook XSL not found.                                  #'; \
			echo '#  Please install docbook-xsl.                             #'; \
			if [ `which aptitude 2>>/dev/null` ]; then \
				echo '#  ( sudo aptitude install docbook-xsl )'; \
			else \
			if [ `which apt-get 2>>/dev/null` ]; then \
				echo '#  ( sudo apt-get install docbook-xsl )'; \
			fi; fi; \
			echo '############################################################'; \
			exit 1; \
		fi ;\
	fi
	date > tmp/_have-docbook-xsl-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp



tmp/_docbook-valid-stamp: $(docbook_sources) tmp/_have-xmllint-stamp tmp/_have-docbook-schema-stamp
	@ echo '############################################################';
	@ echo '#  Validating DocBook sources ...                          #';
	@ echo '############################################################';
#	$(xmllint) --xinclude --postvalid --noout \
#		--dtdvalidfpi "-//OASIS//DTD DocBook XML 5.0//EN" \
#		docbook/index.xml \
#		; ERR=$$? ; echo "$$ERR" > tmp/_docbook-valid-err
	
	if [ -f "docbook-schema/docbookxi.rng" ]; then \
		the_schema_file="docbook-schema/docbookxi.rng" ;\
	elif [ -f "$(docbook_schema_file)" ]; then \
		the_schema_file="$(docbook_schema_file)" ;\
	else \
		exit 1 ;\
	fi ;\
	$(xmllint) --dropdtd --noout \
		--relaxng "$$the_schema_file" \
		$(docbook_index_file)
	
	@ echo '############################################################';
	@ echo '#  DocBook sources are valid.                              #';
	@ echo '############################################################';
	date > tmp/_docbook-valid-stamp
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp
	

validate: tmp/_docbook-valid-stamp


tmp/docbook-one-file.dbk: $(docbook_sources) tmp/_docbook-valid-stamp tmp/_have-xmllint-stamp
	@ echo "Resolving XIncludes in $(docbook_index_file) ..."
	$(xmllint) \
		--xinclude --nonet \
		--output "tmp/docbook-one-file.dbk" \
		$(docbook_index_file)
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp
	@ echo "tmp/docbook-one-file.dbk DONE"

tmp/docbook-one-file-no-ns.dbk: tmp/docbook-one-file.dbk
	@ echo "Removing DocBook namespace from tmp/docbook-one-file.dbk ..."
	sed -e 's/xmlns=["][^"]*["]/ /' \
	  tmp/docbook-one-file.dbk \
	  > tmp/docbook-one-file-no-ns.dbk
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp
	@ echo "tmp/docbook-one-file-no-ns.dbk DONE"


#odt: out.odt
#
#out.odt: tmp/docbook-one-file-no-ns.dbk tmp/_have-docbook2odf-stamp
#	docbook2odf "tmp/docbook-one-file-no-ns.dbk" -o "out.odt" -f -v -d


#roundtrip: tmp/docbook-one-file-no-ns.dbk tmp/_docbook-valid-stamp tmp/_have-xsltproc-stamp tmp/_have-docbook-xsl-stamp
#	mkdir -p roundtrip
#	$(xsltproc) \
#		--xinclude \
#		--novalid \
#		--stringparam 'current.docid' 'foo' \
#		-o "roundtrip/contents.xml" \
#		"/usr/share/xml/docbook/stylesheet/docbook-xsl/roundtrip/dbk2ooo.xsl" \
#		"tmp/docbook-one-file-no-ns.dbk"
	


html-onefile: html-onefile-xsl

html-onefile-xsl: html-onefile/index.html

html-onefile/index.html: $(docbook_sources) Makefile tmp/_docbook-valid-stamp tmp/_have-xsltproc-stamp tmp/_have-docbook-xsl-stamp tmp/_have-tidy-stamp
	@ echo '############################################################';
	@ echo '#  Making HTML (onefile via XSLT) ...                         #';
	@ echo '############################################################';
	@ echo "Transforming to HTML ..."
	mkdir -p html-onefile
	
	if [ -d "docbook-xsl/." ]; then \
		the_docbook_xsl_path="docbook-xsl" ;\
	elif [ -d "$(docbook_xsl_path)/." ]; then \
		the_docbook_xsl_path="$(docbook_xsl_path)" ;\
	else \
		exit 1 ;\
	fi ;\
	$(xsltproc) \
		--xinclude \
		--novalid \
		--stringparam 'current.docid' 'foo' \
		--stringparam 'html.stylesheet' 'style.css' \
		--stringparam 'img.src.path' 'img/' \
		--stringparam 'generate.section.toc.level' '4' \
		--stringparam 'toc.section.depth' '2' \
		--stringparam 'section.autolabel' '1' \
		--stringparam 'section.autolabel.max.depth' '4' \
		--stringparam 'html.cellspacing' '0' \
		-o "html-onefile/" \
		"$$the_docbook_xsl_path/xhtml/onechunk.xsl" \
		$(docbook_index_file)
	
	#touch -d "`cat tmp/_tmp_dir-stamp`" tmp
	touch -r tmp/_tmp_dir-stamp tmp
	@ echo '############################################################';
	@ echo '#  HTML (onefile via XSLT) done.                           #';
	@ echo '############################################################';
	@ echo "Tidying HTML ..."
	for html_file in `ls html-onefile/*.html`; do \
		echo "Tidying `basename $$html_file` ..." ;\
		$(tidy) \
			--add-xml-decl no --assume-xml-procins yes --doctype auto \
			--input-xml no --output-xhtml yes \
			--join-classes no --logical-emphasis no --merge-divs no \
			--ncr yes --numeric-entities no \
			--quote-marks yes --quote-nbsp yes \
			--show-errors 100 --show-warnings yes \
			--indent-spaces 2 --tab-size 2 --vertical-space no \
			--markup yes \
			--wrap 180 --wrap-attributes no \
			--wrap-asp no --wrap-php no --wrap-script-literals no --wrap-sections no \
			--char-encoding utf8 --input-encoding utf8 --output-encoding utf8 --output-bom no \
			--tidy-mark no \
			-quiet -asxhtml -indent -access 0 \
			--indent auto \
			-output $$html_file.tidied \
			$$html_file \
			; e=$$? ; [ ".$$e" = ".0" -o ".$$e" = ".1" ] || exit 1 ;\
		mv $$html_file.tidied $$html_file ;\
	done
	@# --merge-spans no
	@# --sort-attributes none
	@ echo '############################################################';
	@ echo '#  HTML (onefile, tidy) done.                              #';
	@ echo '############################################################';
	
	mkdir -p html-onefile/img/
	cp -a docbook/*.png html-onefile/img/



clean:
	[ ! -e "tmp" ] || rm -rf "tmp"
	[ ! -f "out.odt" ] || rm -f "out.odt"
	[ ! -f "html-onefile/index.html" ] || rm -f "html-onefile/index.html"


.PHONY: help clean odt validate



# Local Variables:
# mode: unix-shell-script
# coding: utf-8
# indent-tabs-mode: t
# tab-width: 4
# End:
