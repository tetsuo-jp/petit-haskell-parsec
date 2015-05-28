all: petit.pdf

petit.aux:
	platex petit || ($(RM) petit.aux petit.dvi ; false)

petit.dvi:
	platex petit || ($(RM) petit.aux petit.dvi ; false)

petit.bbl: petit.aux petit.bib
	pbibtex petit

petit.dvi: petit.bbl

petit.aux petit.dvi: petit.tex

petit.ps: petit.dvi
	dvips -o $@ $<

petit.pdf: petit.dvi
	dvipdfmx $<

clean:
	$(RM) petit.aux petit.dvi petit.ps petit.bbl petit.log petit.blg petit.ps

veryclean: clean
	$(RM) petit.pdf
