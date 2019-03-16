#include "Vocabulary.h"

#include <string.h>
#include <stdio.h>

Vocabulary::Vocabulary(char* FName)
{
 // Create the word-number att map
 Words=new VocMap;
 
 // Copy the file name
 VocFile=new char[strlen(FName)+1];
 strcpy(VocFile,FName);
 
 FILE * F= fopen(VocFile,"a+t"); // Create if not exists

 // Read, store and number the words
 static char Buff[MAX_WORD_LEN];
 NWords=0;
 fgets(Buff,MAX_WORD_LEN,F); // First element
 while(!feof(F)) // while no end
 {
  Buff[strlen(Buff)-1]='\0'; // Remove the last \n
  NWords++;
  Words->insert(pair<string,int>(string(Buff),NWords));
 
  printf("Insert '%s' as %d\n",Buff,NWords); // DEBUG
  
  fgets(Buff,MAX_WORD_LEN,F); // Next element
 }
 
 fclose(F);
}

int Vocabulary::getNumber(char* Word)
{
 VocMap::iterator Pos=Words->find(string(Word));
 if(Pos==Words->end()) // if not founded
 { 
  // Insert a new word in the map
  NWords++;
  Words->insert(pair<string,int>(string(Word),NWords));
  
  // Insert a new word in the file
  FILE * F= fopen(VocFile,"at"); // appending
  fprintf(F,"%s\n",Word);
  fclose(F);
  
  return NWords;
 }
 else // if founded
   return Pos->second;
}


