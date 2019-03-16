
cc=gcc
cf=-c
lk=gcc
lf=

all	: PorterStemmer
	@echo PorterStemmer OK

delete	:
	rm -f PorterStemmer.o
	@echo delete OK
	
build	: delete all
	@echo build OK
	
PorterStemmer	: PorterStemmer.o
		$(lk) $(lf) -o PorterStemmer PorterStemmer.o
		
PorterStemmer.o	: PorterStemmer.c
		$(cc) $(cf) PorterStemmer.c
