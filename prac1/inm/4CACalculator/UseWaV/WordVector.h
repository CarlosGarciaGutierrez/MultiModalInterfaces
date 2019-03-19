#ifndef WORDVECTOR_H
#define WORDVECTOR_H

using namespace std;

#include <map>
#include <string>

class WordVector
{
 public:
 // Constructs a WordVector reading the vectors from a file
 // FName     : file's path
 // checkNorm : if true checks that is a narmalized vector (|v|=1)
 WordVector(char* FName,bool checkNorm=true);


  // Gets the index (Number) and vector asociated to the Word
  // Word   : text to find
  // Vector : pointer to getVectorLen() length array. If exists the word this vector will be filled with the vectors value
  // Returns: the Word index or -1 if not exists  
  int getNumber(char* Word,double * Vector);  
  
 
 // Returns the length of the vector associated to each Word
 // All vectors must have the same length
 int getVectorLen();
 
 // Number of words
 int getNumWords();
 
 typedef pair<int,double*> WaV;
 typedef map<string,WaV*> VocMap;
 
 VocMap * getWords(){return Words;}
  
 protected:
 // Method called when a Word is not founded when called to getNumber
 // Same parameters as getNumber
 virtual int notFoundWord(char* Word,double * Vector){return -1;}
 

 
 VocMap * Words;
 int NWords;
 int VectorLen; 
 char *VocFile;

 int lineLength(FILE * F);
 double * scanLine(char * buff,char * word,int* vecLen,bool checkNorm=true);
 char * skipChar(char * S,char c);
};

#endif
