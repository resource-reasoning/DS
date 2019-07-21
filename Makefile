DRAFTTEX = .draft.tex
TEXS = $(filter-out $(DRAFTTEX), $(shell find * -type f -name '*.tex'))
BIBS = $(shell find * -type f -name '*.bib') 
STYS = $(shell find * -type f -name '*.sty') 
OUTDIR = output
DRAFTDIR = $(OUTDIR)/draft
SOURCES = $(TEXS) $(BIBS) $(STYS)
LATEXMK=latexmk -pdf -bibtex 

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
	 $(LATEXMK) -outdir=$(OUTDIR) main.tex

draft : draft.pdf

draft.pdf : $(DRAFTDIR)/.draft.pdf
	cp $< $@

# switch on the CommentEdits flag in the tex 
$(DRAFTDIR)/.draft.pdf : $(SOURCES) $(DRAFTDIR) $(DRAFTTEX)
	$(LATEXMK) -outdir=$(DRAFTDIR) $(DRAFTTEX) 

# a quick run
once : $(SOURCES) $(DRAFTDIR) $(DRAFTTEX)
	$(LATEXMK) -outdir=$(DRAFTDIR) $(DRAFTTEX) 
	cp $(DRAFTDIR)/.draft.pdf draft.pdf

$(OUTDIR) :
	mkdir -p $@

$(DRAFTDIR) :
	mkdir -p $@

$(DRAFTTEX): main.tex 
	sed 's/CommentEditsfalse/CommentEditstrue/g' $< > $@

stat : .statistic

# the  run-statistic.sh will generate .statistic
.statistic : $(SOURCES) run-statistic.sh statistic.py
	./run-statistic.sh $@

clean:
	rm -rf $(OUTDIR)
	rm main.pdf
	rm draft.pdf
	rm .statistic
	rm $(DRAFTTEX)
