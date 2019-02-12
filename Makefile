TEXS = $(shell find . -type f -name '*.tex') 
BIBS = $(shell find . -type f -name '*.bib') 
STYS = $(shell find . -type f -name '*.sty') 
OUTDIR = .temp
SOURCES = $(TEXS) $(BIBS) $(STYS) $(OUTDIR) 
DRAFTTEX = .draft.tex
PDFLATEX=pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -no-shell-escape -output-directory=$(OUTDIR) 
LATEXMK=latexmk -pdf -pdflatex="$(PDFLATEX)" -bibtex -output-directory=$(OUTDIR) -use-make

# all : default; generate main.tex and draft.tex
# main : generate main.tex
# draft : generate draft.tex by replacing 
# 		  CommentEditsfalse with CommentEditstrue
# once : compile only once to generate main.pdf
# 		 useful to check syntax error
# stat : run the  run-statistic.sh to generate .statistic
# clean : clean everything
.PHONY: all main draft once stat clean 
 
all:  main draft

main : main.pdf

main.pdf : $(OUTDIR)/main.pdf
	cp $< $@

$(OUTDIR)/main.pdf : $(SOURCES)
	 $(LATEXMK) main.tex

$(OUTDIR)/main.bbl : $(OUTDIR)/main.aux
	cp *.bib $(OUTDIR)
	cd $(OUTDIR)
	bibtex main
	cd ..

draft : draft.pdf

draft.pdf : $(OUTDIR)/.draft.pdf
	cp $< $@

# switch on the CommentEdits flag in the tex 
$(OUTDIR)/.draft.pdf : $(SOURCES)
	sed 's/CommentEditsfalse/CommentEditstrue/g' main.tex > $(DRAFTTEX)
	$(LATEXMK) $(DRAFTTEX)
	rm $(DRAFTTEX)

# generate draft.bbl or copy from main.bbl
$(OUTDIR)/.draft.bbl : $(OUTDIR)/draft.aux
	ifeq ($(wildcard $(OUTDIR)/main.bbl), )
		cp *.bib $(OUTDIR)
		cd $(OUTDIR)
		bibtex draft
		cd ..
	else
		cp $(OUTDIR)/main.bbl $@
	endfi

# a quick run
once : $(SOURCES) 
	sed 's/CommentEditsfalse/CommentEditstrue/g' main.tex > $(DRAFTTEX)
	$(PDFLATEX) $(DRAFTTEX) 
	cp $(OUTDIR)/.draft.pdf draft.pdf
	rm $(DRAFTTEX)

$(OUTDIR) :
	mkdir $(OUTDIR)

$(SOURCES):

*.aux: 

stat : .statistic

# the  run-statistic.sh will generate .statistic
.statistic : $(SOURCES) run-statistic.sh statistic.py
	./run-statistic.sh $@

run-statistic.sh statistic.py :


clean:
	rm -rf $(OUTDIR)
	rm main.pdf
	rm draft.pdf
	rm .statistic
