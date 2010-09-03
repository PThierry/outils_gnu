#
# Makefile for textemplate in /cygdrive/z/Programs/msysgit/msysgit/home/phil/dev/latex_utils/doc
#
# Made by t0090690
# Login   <t0090690@fr.thalesgroup.com>
#
# Started on  Wed Nov 18 14:29:46 2009 t0090690
# Last update Wed Nov 18 14:29:46 2009 t0090690
#


#############################################################################
## basic macros
#############################################################################

LATEX=pdflatex
LATEXOPT=-shell-escape
BIBTEX=bibtex

RM=rm
RMFLAGS=-rf
MAKE=make

#############################################################################
## project's source and generated files
#############################################################################
TARGET	     = cours_outils-gnu
SOURCE	     = document.tex
SOURCE_PREFIX= document
OBJS	     = $(SOURCE:.tex=.aux) $(SOURCE:.tex=.log) $(SOURCE:.tex=.out) $(SOURCE:.tex=.toc) \
               $(SOURCE:.tex=.ist) $(SOURCE:.tex=.glo) $(SOURCE:.tex=.idx) $(SOURCE:.tex=.lof) \
               $(SOURCE:.tex=.brf) $(SOURCE:.tex=.bmt) $(SOURCE:.tex=.ind) $(SOURCE:.tex=.ilg) \
	       $(SOURCE:.tex=.lot) *.ps *.mlf* *.mlt* *.mtc* document-fig*.tex *.log document-fig*.pdf tmp.inputs
TODEL	     = tags *~ .*.swp
LANG	     = $(shell cat config/config.tex|grep "newcommand.*lang"|sed -re "s:.*\{([fe][rn])\}.*:\1:")

#############################################################################
## rules
#############################################################################

help :
	@echo "- all 		: this help message"
	@echo "- pdf		: compile the document"
	@echo "- view		: display the compiled document if present"
	@echo "- clean		: cleanup temporary files"
	@echo "- distclean 	: cleanup all files but sources"
	@echo "- install	: install the document"

images:
	if [ ! -d images ]; then mkdir images; fi; for file in *-fig*.ps; do convert -trim +repage $$file images/$${file%%.ps}.png; done


all : help

pdf :
	$(LATEX) $(LATEXOPT) $(LATEXOPT) $(SOURCE)
#	$(BIBTEX) $(SOURCE_PREFIX)
	makeindex $(SOURCE:.tex=.idx)
	while [ `cat $(SOURCE:.tex=.log) | grep 'may have changed.' | wc -l` -ge 1 ]; do $(LATEX) $(LATEXOPT) $(LATEXOPT) $(SOURCE); done
	mv $(SOURCE:.tex=.pdf) $(TARGET)_$(LANG).pdf

clean : 
	$(RM) $(RMFLAGS) $(OBJS) $(TODEL)

distclean : clean
	$(RM) $(RMFLAGS) $(TARGET)

dist : distclean
	$(TAR) $(TARFLAGS) $(DISTTARGET) .

install : $(TARGET)
	@echo you must be root to install

view:
	if [ ! -f $(TARGET) ]; then make all; fi
	acroread $(TARGET)_$(LANG).pdf

