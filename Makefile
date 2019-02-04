TEXS = $(shell find . -type f -name '*.tex') 
BIBS = $(shell find . -type f -name '*.bib') 
STYS = $(shell find . -type f -name '*.sty') 

main.pdf :  $(TEXS) $(BIBS) $(STYS)
	latexmk -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make main.tex

$(TEXS) $(BIBS) $(STYS):
