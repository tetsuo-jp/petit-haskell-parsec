ifeq ($(OSTYPE),cygwin)
 EXT = .exe
else
 EXT =
endif

ALLSRC = Makefile Petit.hs html

all: petit$(EXT) html/Main.html

petit: Petit.hs
	ghc -O2 --make -o $@ $^

clean:
	$(RM) -r Petit.hi Petit.o html

veryclean: clean
	$(RM) petit$(EXT)

srccopy:
	cp $(ALLSRC) ../$(PACKAGE)-$(VER)/src/

html/Main.html: Petit.hs
	haddock -html -o html --ignore-all-exports Petit.hs
