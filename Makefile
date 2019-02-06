TEXS = $(shell find . -type f -name '*.tex') 
BIBS = $(shell find . -type f -name '*.bib') 
STYS = $(shell find . -type f -name '*.sty') 
OUTDIR = OUT

all: main.pdf draft.pdf

draft.pdf : $(OUTDIR)/draft.pdf
	cp $(OUTDIR)/draft.pdf draft.pdf

$(OUTDIR)/draft.pdf :  $(TEXS) $(BIBS) $(STYS)
	sed 's/CommentEditsfalse/CommentEditstrue/g' main.tex > draft.tex
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -bibtex -outdir=$(OUTDIR) -use-make draft.tex
	rm draft.tex

main.pdf : $(OUTDIR)/main.pdf
	cp $(OUTDIR)/main.pdf main.pdf

$(OUTDIR)/main.pdf :  $(TEXS) $(BIBS) $(STYS)
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -bibtex -outdir=$(OUTDIR) -use-make main.tex

$(TEXS) $(BIBS) $(STYS):

.PHONY: clean

clean:
	rm -rf $(OUTDIR)
	rm main.pdf
	rm draft.pdf
