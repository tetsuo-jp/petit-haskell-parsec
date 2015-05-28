export PACKAGE = petit
export VER = `date +%Y%m%d`
DATE := $(shell date)
OSTYPE := $(shell bash ./getostype.sh)

ifeq ($(OSTYPE),cygwin)
 EXT = .exe
else
 EXT =
endif

all: bin/petit$(EXT) doc/petit.dvi doc/petit.ps doc/petit.pdf

FORCE:

src/petit$(EXT): src/%: FORCE
	+cd src && $(MAKE) $*

bin/petit$(EXT): bin/%: src/%
	cp src/$* bin/
	strip bin/$*

doc/petit.dvi doc/petit.ps doc/petit.pdf: doc/%: FORCE
	cd doc && $(MAKE) $*

update-tests: bin/$(PACKAGE)$(EXT)
	cd bin && ./updatetest test01.p
	cd bin && ./updatetest test02.p
	cd bin && ./updatetest test03.p
	cd bin && ./updatetest test04.p
	cd bin && ./updatetest sum.p

tests: bin/$(PACKAGE)$(EXT)
	cd bin && ./test test01.p
	cd bin && ./test test02.p
	cd bin && ./test test03.p
	cd bin && ./test test04.p
	cd bin && ./test sum.p

clean: rmsrcdir
	(cd src ; $(MAKE) clean)
	(cd doc ; $(MAKE) clean)
	$(RM) core gmon.out *~ #*#

veryclean:
	rm -f bin/petit
	(cd src ; $(MAKE) veryclean)

# distclean: clean
#	rm -rf dists

srcdir:
	if [ ! -d dists ]; then mkdir dists; fi
	mkdir $(PACKAGE)-$(VER)
	mkdir $(PACKAGE)-$(VER)/src
	cd src ; $(MAKE) srccopy ; cd ..
	cp Makefile $(PACKAGE)-$(VER)/
	cp getostype.sh $(PACKAGE)-$(VER)/
	cp README $(PACKAGE)-$(VER)/
	mkdir $(PACKAGE)-$(VER)/bin
	cp bin/$(PACKAGE) $(PACKAGE)-$(VER)/bin/
	cp bin/runtest $(PACKAGE)-$(VER)/bin/
	cp bin/updatetest $(PACKAGE)-$(VER)/bin/
	cp bin/test $(PACKAGE)-$(VER)/bin/
	mkdir $(PACKAGE)-$(VER)/examples
	cp -R examples/*.p $(PACKAGE)-$(VER)/examples/
	cp -R examples/*.output $(PACKAGE)-$(VER)/examples/
	mkdir $(PACKAGE)-$(VER)/doc
	cp doc/$(PACKAGE).tex $(PACKAGE)-$(VER)/doc/
	cp doc/$(PACKAGE).bib $(PACKAGE)-$(VER)/doc/
	cp doc/Makefile $(PACKAGE)-$(VER)/doc/

srctargz:
	tar -cvf - $(PACKAGE)-$(VER) | gzip -9 > dists/$(PACKAGE)-$(VER)-src.tar.gz

srczip:
	zip -9 $(PACKAGE)-$(VER).zip $(PACKAGE)-$(VER)

rmsrcdir:
	$(RM) -r $(PACKAGE)-$(VER)

srcdist: srcdir srctargz rmsrcdir
