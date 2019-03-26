
cc=gcc
cf=-c
lk=gcc
lf=-o
lex=flex
yacc=bison

all	: calc
	@echo calc OK

clean	:
	rm -f calclex.c calc.c calc_tok.h calclex.o calc.o calc
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

calc	: calclex.o calc.o
	$(lk) $(lf) calc calclex.o calc.o

calc.o	: calc.c
	$(cc) $(cf) calc.c

calc.c calc_tok.h	: calc.y
			$(yacc) -ocalc.c --defines=calc_tok.h calc.y

calclex.o	: calclex.c calc_tok.h
		$(cc) $(cf) calclex.c

calclex.c	: calc.lex
		$(lex) -ocalclex.c calc.lex

