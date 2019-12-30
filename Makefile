MAINTEX=main.tex
STY=$(wildcard *.sty)
OUTPUTDIR=output

SOURCETEX=$(filter-out $(MACROTEX) $(MAINTEX), $(wildcard *.tex) $(wildcard **/*.tex) )

LATEX=latexmk -outdir=$(OUTPUTDIR) -bibtex 
FLAG=-pdf -interaction=nonstopmode -halt-on-error -file-line-error
SOURCEDIR=$(addprefix $(OUTPUTDIR)/,$(sort $(dir $(SOURCETEX))))

.PHONY: all clean

all: main

main: $(MAINTEX) $(STY) $(SOURCETEX) $(SOURCEDIR)
	$(LATEX) $(FLAG) $<
	cp $(OUTPUTDIR)/$(MAINTEX:.tex=.pdf) $(MAINTEX:.tex=.pdf)

$(SOURCEDIR): %: 
	mkdir -p $@

clean:
	$(LATEX) -CA
	rm -f $(MACROTEX:.tex=.pdf) 
	rm -f $(MAINTEX:.tex=.pdf) 
