#ifndef WORDREPRE_H
#define WORDREPRE_H

#include "WordVector.h"

class WordRepre : public WordVector{
  public:
  WordRepre(char* FName,WordVector* WV);

 
  int getNumWordVector(){return WV->getNumWords();}
  
  protected:
 // Method called when a Word is not founded when called to getNumber
 // Same parameters as getNumber
 virtual int notFoundWord(char* Word,double * Vector);
 
 private:
 WordVector * WV;
 
 double calculaSimil(double* V1,double* V2,int Len);
};

#endif
