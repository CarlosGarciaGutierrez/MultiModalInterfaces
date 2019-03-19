#ifndef VOCABULARY_H
#define VOCABULARY_H

#define MAX_WORD_LEN 128

using namespace std;

#include <map>
#include <string>

class Vocabulary
{
 public:
 Vocabulary(char* FName);
 
 int getNumber(char* Word);
 
 private:
 typedef map<string,int> VocMap;
 
 VocMap * Words;
 int NWords;
 
 char *VocFile;
};

#endif
