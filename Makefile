PDFLATEX = pdflatex

TEX_PAGES = $(wildcard segregator_szkocki_*.tex)
PDF_PAGES = $(TEX_PAGES:.tex=.pdf)
PNG_PAGES = $(TEX_PAGES:.tex=.png)

BOOK = segregator_szkocki.pdf
BOOK_INCLUDES = .pages.tex

SSH_USER = webadm
SSH_HOST = omega.im.uj.edu.pl
SSH_BASE_DIR = htdocs

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

%.png: %.pdf
	convert -density 300 $< -background white -flatten $@

%.pdf: %.tex
	$(PDFLATEX) $<
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	$(RM) *.log *.dvi *.pdf *.aux *.png $(BOOK_INCLUDES)

upload: $(BOOK)
	scp $< $(SSH_USER)@$(SSH_HOST):$(SSH_BASE_DIR)/$<

help:
	@echo "all: book pages"
	@echo "pages: create separate problem pages"
	@echo "book: merge pages into book"
	@echo "png: convert pages to png"
	@echo "upload: publish it on http://kmsuj.im.uj.edu.pl/segregator_szkocki.pdf"

.PHONY: all book pages png help upload
