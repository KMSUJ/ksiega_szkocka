PDFLATEX = pdflatex

TEX_PAGES = $(wildcard segregator_szkocki_*.tex)
PDF_PAGES = $(TEX_PAGES:.tex=.pdf)

BOOK = segregator_szkocki.pdf
BOOK_INCLUDES = .pages.tex

all: book pages

book: $(BOOK)
$(BOOK): $(BOOK_INCLUDES)
$(BOOK_INCLUDES): $(PDF_PAGES)
	echo > $(BOOK_INCLUDES)
	$(MAKE) $(PDF_PAGES:%=_include_%)

_include_%: %
	echo "\\includepdf{$<}" >> $(BOOK_INCLUDES)

pages: $(PDF_PAGES)

%.pdf: %.tex
	$(PDFLATEX) $<
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	$(RM) *.log *.dvi *.pdf *.aux $(BOOK_INCLUDES)
