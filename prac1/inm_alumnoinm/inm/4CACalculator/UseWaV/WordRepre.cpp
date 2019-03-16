#include <stdio.h>

#include "WordRepre.h"

WordRepre::WordRepre(char* FName,WordVector* WV):WordVector(FName,false){
  this->WV=WV;
  VectorLen=WV->getNumWords();
}

int WordRepre::notFoundWord(char* Word,double * Vector){
  // Search Word in WV
  // DEBUG
  printf("Not found in voc\n");
  
  // Look for the word in Vectors
  static double * WordVector=new double[WV->getVectorLen()];
  int wi=WV->getNumber(Word,WordVector);
  if(wi==-1){ // if not founded

    // DEBUG
    printf("Not found in vectors\n");
    
    for(int i=0;i<WV->getVectorLen();i++)
      WordVector[i]=0.0l;
  
  }    
  else{ // founded
    // DEBUG
    printf("Found in vectors.\n");
  }
  // DEBUG
  printf("WordVector Created\n");
  
  // Calculate the similarity with all the words
  
  double MaxSim=-1.0; // DEBUG
  
  int iv=0;
  int WVLen=WV->getVectorLen();
  
  // DEBUG
  printf("Simil vectors len %d \n",WVLen);
  
  for(VocMap::iterator i=WV->getWords()->begin();i!=WV->getWords()->end();i++){
    double Sim=calculaSimil(WordVector,i->second->second,WVLen);
    Vector[iv]=Sim;
    
    // DEBUG
    if(Vector[iv]>MaxSim){
    	printf("cos(%s,%s)=%0.6f (%d/%d)\n",Word,i->first.c_str(),Vector[iv],iv+1,WV->getNumWords());
        MaxSim=Vector[iv];
    }
    
    iv++;
  }
  
  // Insert a new word in the map
  NWords++;
  // Make a vector copy
  double * CVector=new double[VectorLen];
  for(int i=0;i<VectorLen;i++) CVector[i]=Vector[i];
  
  Words->insert(pair<string,WaV*>(string(Word),new WaV(NWords,CVector)));
  
  // Insert a new word and vector in the file
  FILE * F= fopen(VocFile,"at"); // appending
  fprintf(F,"%s",Word);
  for(int i=0;i<getNumWordVector();i++)
    fprintf(F," %lf",Vector[i]);
  fprintf(F,"\n");
  fclose(F);
  
  return NWords;
    
}


// Cosine similiraty : vectors are supposed to be normal
double WordRepre::calculaSimil(double* V1,double* V2,int Len){
 double Sim=0.0;
 for(int i=0;i<Len;i++)
   Sim=Sim+V1[i]*V2[i];
 return Sim;  
}

