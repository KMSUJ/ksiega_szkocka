PDFLATEX = pdflatex

TEX_PAGES = $(wildcard segregator_szkocki_*.tex)
PDF_PAGES = $(TEX_PAGES:.tex=.pdf)
PNG_PAGES = $(TEX_PAGES:.tex=.png)

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

png: $(PNG_PAGES)

help:
	@echo "all: book pages"
	@echo "pages: create separate problem pages"
	@echo "book: merge pages into book"
	@echo "png: convert pages to png"

%.png: %.pdf
	convert -density 300 $< -background white -flatten $@

%.pdf: %.tex
	$(PDFLATEX) $<
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	$(RM) *.log *.dvi *.pdf *.aux *.png $(BOOK_INCLUDES)

.PHONY: all book pages png help
