DRAFTTEX = .draft.tex
TEXS = $(filter-out $(DRAFTTEX), $(shell find * -type f -name '*.tex'))
BIBS = $(shell find * -type f -name '*.bib') 
STYS = $(shell find * -type f -name '*.sty') 
OUTDIR = .temp
DRAFTDIR = $(OUTDIR)/draft
SOURCES = $(TEXS) $(BIBS) $(STYS)
PDFLATEX=pdflatex -interaction=nonstopmode -halt-on-error -file-line-error -no-shell-escape 
LATEXMK=latexmk -pdf -pdflatex="$(PDFLATEX)" -bibtex -use-make

# all : default; generate main.tex and draft.tex
# main : generate main.tex
# draft : generate draft.tex by replacing 
# 		  CommentEditsfalse with CommentEditstrue
# once : compile only once to generate main.pdf
# 		 useful to check syntax error
# stat : run the  run-statistic.sh to generate .statistic
# clean : clean everything
.PHONY: all main draft once stat clean 
 
all: main draft

main : main.pdf

main.pdf : $(OUTDIR)/main.pdf
	cp $< $@

$(OUTDIR)/main.pdf : $(SOURCES) $(OUTDIR)
	 $(LATEXMK) -output-directory=$(OUTDIR) main.tex

$(OUTDIR)/main.bbl : $(SOURCES)
	cp *.bib $(OUTDIR)
	cd $(OUTDIR)
	bibtex main
	cd ..

draft : draft.pdf

draft.pdf : $(DRAFTDIR)/.draft.pdf
	cp $< $@

# switch on the CommentEdits flag in the tex 
$(DRAFTDIR)/.draft.pdf : $(SOURCES) $(DRAFTDIR) $(DRAFTTEX)
	$(LATEXMK) -output-directory=$(DRAFTDIR) $(DRAFTTEX) 

# generate draft.bbl or copy from main.bbl
$(DRAFTDIR)/.draft.bbl : $(OUTDIR)/main.bbl
	cp $< $@

# a quick run
once : $(SOURCES) $(DRAFTDIR) $(DRAFTTEX)
	$(PDFLATEX) -output-directory=$(DRAFTDIR) $(DRAFTTEX) 
	cp $(DRAFTDIR)/.draft.pdf draft.pdf

$(OUTDIR) :
	mkdir -p $@

$(DRAFTDIR) :
	mkdir -p $@

$(SOURCES):

$(DRAFTTEX): main.tex 
	sed 's/CommentEditsfalse/CommentEditstrue/g' $< > $@

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
	rm $(DRAFTTEX)
