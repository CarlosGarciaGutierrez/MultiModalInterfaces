
cc=g++
cf=-c -Wno-deprecated-declarations
lk=g++
lf=

all	: CACalculator
	@echo CACalculator OK

delete	:
	rm -f CACalculator.o WordRepre.o WordVector.o
	@echo delete OK
	
build	: delete all
	@echo build OK

CACalculator	: CACalculator.o WordRepre.o WordVector.o
		$(lk) $(lf) -o CACalculator CACalculator.o WordRepre.o WordVector.o

CACalculator.o	: CACalculator.cpp WordVector.h WordRepre.h
		$(cc) $(cf) CACalculator.cpp
		
WordVector.o	: WordVector.cpp WordVector.h
		$(cc) $(cf) WordVector.cpp
		
WordRepre.o	: WordRepre.cpp WordRepre.h
		$(cc) $(cf) WordRepre.cpp		

