
cc=gcc
cf=-c
lk=gcc
lf=-o
lex=flex

all	: XML2MLText
	@echo XML2MLText OK

clean	:
	rm -f XML2MLText.c  XML2MLText.o XML2MLText
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

XML2MLText	: XML2MLText XML2MLText.o
		$(lk) $(lf) XML2MLText XML2MLText.o

XML2MLText.o	: XML2MLText.c
		$(cc) $(cf) XML2MLText.c

XML2MLText.c	: XML2MLText.lex
		$(lex) -oXML2MLText.c XML2MLText.lex

