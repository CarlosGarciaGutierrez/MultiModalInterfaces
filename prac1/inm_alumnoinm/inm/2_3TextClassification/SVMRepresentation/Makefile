
cc=g++
cf=-c -O2
lk=g++
lf=-o
lex=flex

all	: SVMRep
	@echo SVMRep OK

clean	:
	rm -f SVMRep.cpp  SVMRep.o SVMRep
	@echo CLEAN OK

build	: clean all
	@echo BUILD OK

SVMRep	: SVMRep.o
	$(lk) $(lf) SVMRep SVMRep.o

SVMRep.o	: SVMRep.cpp
		$(cc) $(cf) SVMRep.cpp

SVMRep.cpp	: SVMRep.lex
		$(lex) -oSVMRep.cpp SVMRep.lex

