
cc=gcc
cf=-c
lk=gcc
lf=-o
lex=flex

all	: news2txt FilterLines
	@echo news2txt OK

clean	:
	rm -f news2txt.c  news2txt.o news2txt
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

news2txt	: news2txt.o
		$(lk) $(lf) news2txt news2txt.o

news2txt.o	: news2txt.c
		$(cc) $(cf) news2txt.c

news2txt.c	: news2txt.lex
		$(lex) -onews2txt.c news2txt.lex

FilterLines	: FilterLines.o
		$(lk) $(lf) FilterLines FilterLines.o

FilterLines.o	: FilterLines.c
		$(cc) $(cf) FilterLines.c
