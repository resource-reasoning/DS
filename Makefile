TEXS = $(shell find . -type f -name '*.tex') 
BIBS = $(shell find . -type f -name '*.bib') 
STYS = $(shell find . -type f -name '*.sty') 
OUTDIR = .temp
DRAFTTEX = .draft.tex

.PHONY: all clean try stat
 
all:  main.pdf draft.pdf

main.pdf : $(OUTDIR)/main.pdf
	cp $(OUTDIR)/main.pdf main.pdf

$(OUTDIR)/main.pdf : $(TEXS) $(BIBS) $(STYS)
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode -halt-on-error" -bibtex -outdir=$(OUTDIR) -use-make main.tex

draft.pdf : $(OUTDIR)/.draft.pdf
	cp $(OUTDIR)/.draft.pdf draft.pdf

$(OUTDIR)/main.bbl :
	cp *.bib $(OUTDIR)
	cd $(OUTDIR)
	bibtex main
	cd ..

$(OUTDIR)/.draft.pdf :  $(TEXS) $(BIBS) $(STYS)
	sed 's/CommentEditsfalse/CommentEditstrue/g' main.tex > $(DRAFTTEX)
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode -halt-on-error" -bibtex -outdir=$(OUTDIR) -use-make $(DRAFTTEX)
	rm $(DRAFTTEX)

$(OUTDIR)/.draft.bbl :
	cd $(OUTDIR)
	cp main.bbl .draft.bbl
	cd ..


try : $(TEXS) $(BIBS) $(STYS) 
	latexmk  -pdf -pdflatex="pdflatex -halt-on-error" -outdir=$(OUTDIR) -bibtex- main.tex

stat : .statistic

.statistic : $(TEXS) $(BIBS) $(STYS) run-statistic.sh statistic.py
	./run-statistic.sh

run-statistic.sh statistic.py :

$(TEXS) $(BIBS) $(STYS):

clean:
	rm -rf $(OUTDIR)
	rm main.pdf
	rm draft.pdf
