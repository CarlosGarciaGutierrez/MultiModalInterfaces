#include "WordVector.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

using namespace std;


#define MAX_WORD_LENGTH 128

WordVector::WordVector(char* FName,bool checkNorm)
{
 // Create the word-(number,vector) att map
 Words=new VocMap;
 
 // Copy the file name
 VocFile=new char[strlen(FName)+1];
 strcpy(VocFile,FName);
 printf("Reading vocabulary from '%s'\n",VocFile);

 FILE * F= fopen(VocFile,"a+t"); // Create if not exists
 if(!F){
   printf("ERROR: Can not open for writting or reading file: '%s'\n",VocFile);
   exit(1);
 }
 
 // getting the max line length
 int maxLineLength=lineLength(F);
 // DEBUG 
 printf("Max line length=%d\n",maxLineLength);
 

 // Read, store and number the words and vectors
 char buff[maxLineLength];
 char word[MAX_WORD_LENGTH];
 double *vector;
 NWords=0;
 VectorLen=0;
 fgets(buff,maxLineLength,F); // First element
 while(!feof(F)) // while not end
 {
  buff[strlen(buff)-1]='\0'; // Remove the last \n

  // Read the vector
  int currVecLen=0;
  vector=scanLine(buff,word,&currVecLen,false);
  if(VectorLen==0) VectorLen=currVecLen;
  else if(VectorLen!=currVecLen){
    printf("ERROR: vector %d of dimension %d where previous vectors are dimension %d\n",
      NWords+1,currVecLen,VectorLen);
    exit(1);
  }
  
  // Store the word with the pair (index,vector)
  NWords++;
  WaV *nVec=new pair<int,double*>;
  nVec->first=NWords;
  nVec->second=vector;
  pair<string,WaV* > * P=new pair<string,WaV* >(string(word),nVec);
  Words->insert(*P);
 
  printf("Insert '%s' as %d\n",word,NWords); // DEBUG
  
  fgets(buff,maxLineLength,F); // Next element
 }
 
 fclose(F);
 printf("Readed %d words. Vectors lenght=%d\n",NWords,VectorLen);
}

// Returns the length of the vector associated to each Word
// All vectors must have the same length
int WordVector::getVectorLen(){
  return VectorLen;
}


// Number of words
int WordVector::getNumWords(){
  return Words->size();
}

// Returns the maximum length of the text file lines
int WordVector::lineLength(FILE * F){
  int maxLL=0;
  char c=fgetc(F);
  int LL=0;
  while(!feof(F)){  
    if(c=='\n'){
      if(maxLL<LL) maxLL=LL;
      LL=0;
    }
  
   LL++;
   c=fgetc(F);
  }
  rewind(F);
  return maxLL+1+1; // To store the \n and \0
}


// Get the S position after the first character c, or eol if there is not any
char * WordVector::skipChar(char * S,char c){
  if(!S) return S;
  char * sc=S;
  while(*sc && (*sc)!=c) sc++;
  if((*sc)==c) sc++;
  return sc;
}


// Given a line with the pattern 'Word Number*' gets the Word and the vector of Numbers
// buff    : the line to parse
// word    : where to store the word
// vecLen  : length of the vector readed, could be 0 if no numbers found
// chckNorm: if true checks that is a narmalized vector (|v|=1)
// returns : an array with the values' numbers or null if there anre not numbers
double * WordVector::scanLine(char * buff,char * word,int* vecLen,bool checkNorm){
  // Get the Word
  // printf("buff:'%s'\n",buff); // DEBUG
  sscanf(buff,"%s",word);
  // printf("word:'%s'",word); // DEBUG
  
  // Get the vector
  double * v=NULL;
  *vecLen=0;
  // count the Numbers
  for(char * i=buff;*i;i++)
    if((*i)==' ') (*vecLen)++;
  if(*vecLen==0) return v; // No vector
  
  double vSumSq=0.0l;
  v=new double[*vecLen]; // Allocate memory
  // Read the Numbers
  char * bi=skipChar(buff,' '); // To first 
  int vi=0;
  while(*bi!='\0'){ // not eol
    sscanf(bi,"%lf",&(v[vi]));
    vSumSq+=v[vi]*v[vi];
    bi=skipChar(bi,' ');
    vi++;
  }
 
  if(checkNorm)
  if(vSumSq<(1-1e-10) || vSumSq>(1+1e-10)){
    printf("ERROR: No normalized vector: word '%s' sum(vector.^2)=%lf\n",word,vSumSq);
    exit(2);
  }  
 
  //printf("\nv="); for(int i=0;i<*vecLen;i++) printf(" %lf",v[i]); printf("\n"); // DEBUG
  //printf(" sum(vector.^2)=%lf\n",vSumSq); // DEBUG
 
  return v;
}


int WordVector::getNumber(char* Word,double * Vector){
  // DEBUG
  printf("getNumber(%s)\n",Word);
 
  VocMap::iterator Pos=Words->find(string(Word));
  if(Pos==Words->end()) // if not founded
  { 
   // DEBUG
   printf("Not found in voc\n");
  
   return notFoundWord(Word,Vector);
  }    
  else{ // founded
    double * vw=Pos->second->second;
    // DEBUG
    printf("Found in vectors. VectorLen=%d (Vector[0]=%lf\n",VectorLen,vw[0]);
  
    for(int i=0;i<VectorLen;i++)
      Vector[i]=vw[i];
      
    return Pos->second->first;
  }
}

