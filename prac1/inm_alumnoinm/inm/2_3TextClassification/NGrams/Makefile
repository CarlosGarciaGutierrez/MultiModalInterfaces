
cc=g++
cf=-c -O2
lk=g++
lf=-o
lex=flex

all	: NGrams
	@echo NGrams OK

clean	:
	rm -f NGrams.cpp  NGrams.o NGrams
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

NGrams	: NGrams.o
	$(lk) $(lf) NGrams NGrams.o

NGrams.o	: NGrams.cpp
		$(cc) $(cf) NGrams.cpp

NGrams.cpp	: NGrams.lex
		$(lex) -oNGrams.cpp NGrams.lex

