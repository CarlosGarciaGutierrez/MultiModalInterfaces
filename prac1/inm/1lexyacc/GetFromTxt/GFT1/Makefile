
cc=g++
cf=-c
lk=g++
lf=-o
lex=flex
yacc=bison

all	: GFT
	@echo GFT OK

clean	:
	rm -f GFTlex.cpp GFT.cpp GFT.o GFT
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

GFT	: GFT.o
	$(lk) $(lf) GFT GFT.o

GFT.o	: GFT.cpp GFTlex.cpp
	$(cc) $(cf) GFT.cpp

GFT.cpp	: GFT.y
	$(yacc) -oGFT.cpp GFT.y

GFTlex.cpp	: GFT.lex
		$(lex) -oGFTlex.cpp GFT.lex

