
cc=g++
cf=-c -O2
lk=g++
lf=-o
lex=flex

all	: OneLabelSVM
	@echo OneLabelSVM OK

clean	:
	rm -f OneLabelSVM.cpp  OneLabelSVM.o OneLabelSVM
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

OneLabelSVM	: OneLabelSVM.o
		$(lk) $(lf) OneLabelSVM OneLabelSVM.o

OneLabelSVM.o	: OneLabelSVM.cpp
		$(cc) $(cf) OneLabelSVM.cpp

OneLabelSVM.cpp	: OneLabelSVM.lex
		$(lex) -oOneLabelSVM.cpp OneLabelSVM.lex

