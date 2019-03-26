#include <stdio.h>
#include <stdlib.h>
#include <set>
#include <string.h>

#include "WordVector.h"
#include "WordRepre.h"

#define MAX_LINE 2000000

// SVM Category of the operations
#define SUM 1
#define SUB 2
#define PRO 3
#define DIV 4

// Operator's text
const char *OpeText[4]={"+","-","*","/"};

void GetSVMRepNumbers(char* Line,WordRepre* WR,char * SVMRep,int* N1,int* N2)
{
 static char Word[MAX_LINE];
 
 int repVectorLen=WR->getNumWordVector();
 
 // DEBUG
 printf("Word representation length=%d\n",repVectorLen);
 
 static double * WordVector=new double[repVectorLen]; 
 
 double * SentenceVector=new double[repVectorLen]; 
 for(int i=0;i<repVectorLen;i++) SentenceVector[i]=0.0;
 
 sscanf(Line,"%s",Word);  // Read the first word
 typedef set<int> setint;
 setint Atts; // Attributes
 int * PN=N1;
 int N;
 *N1=*N2=0; // Inicialization
 while(*Line && Word[0])
 {
  if(sscanf(Word,"%d",&N)) // is a number
  {
   if(PN) // If there is a operand to asign
   {
    (*PN)=N; // asign the operand
    
    // Next operand
    if(PN==N1) PN=N2;
    else if(PN==N2) PN=NULL;
   }
  }
  else // it is a Word
  {  
   int WordNum=WR->getNumber(Word,WordVector);
   printf("Word='%s' Number=%d\n",Word,WordNum); // Debug
   // Atts.insert(WordNum); // Old version
   // Sentence=Sentence+Word
   for(int i=0;i<WR->getNumWordVector();i++) SentenceVector[i]=SentenceVector[i]+WordVector[i];
  }
  
  while(*Line && (*Line)!=' ') Line++; // Seach for the end of word
  while((*Line)==' ') Line++;          // Skip all ' '
  sscanf(Line,"%s",Word);              // read the next word
 }
 
 // Generate SVMRep
 SVMRep[0]='\0';

 /*
 for(setint::iterator i=Atts.begin();i!=Atts.end();i++)
   sprintf(SVMRep+strlen(SVMRep)," %d:1",*i);
*/
 
 for(int i=0;i<WR->getNumWordVector();i++){
   sprintf(SVMRep+strlen(SVMRep)," %d:%lf",i+1,SentenceVector[i]);
 }  
   
 printf("N1=%d N2=%d\n",*N1,*N2);
 //printf("%s\n",SVMRep); // Debug
}

int PredictOpe(char* SVMTrainFile,char* SVMRep)
{
 // Check if train file exists
 FILE * F=fopen(SVMTrainFile,"rt");
 if(!F) // If not exists
   return SUM; // return any operator
 else
   fclose(F);  
 // train file exists
 
 // Generate model file (training)
 static char Inst[1024];
 sprintf(Inst,"train -q %s %s.model",SVMTrainFile,SVMTrainFile);
 printf("%s\n",Inst);
 system(Inst); 
 
 // Generate testing file and evaluate it (testing)
 char * TestFile=Inst;
 sprintf(TestFile,"%s.test",SVMTrainFile); // Generating testing file
 F=fopen(TestFile,"wt");
 fprintf(F,"0%s\n",SVMRep); // Use 0 category for testing (it is not known)
 fclose(F);
 
 // Evaluating
 sprintf(Inst,"predict %s.test %s.model %s.eval",SVMTrainFile,SVMTrainFile,SVMTrainFile);
 printf("%s\n",Inst);
 system(Inst);
 
 // Reading the evaluation
 sprintf(TestFile,"%s.eval",SVMTrainFile);
 F=fopen(TestFile,"rt");
 int Ope=0;
 fscanf(F,"%d",&Ope); // Checking error needed
 fclose(F);
 
 printf("Prediction=%d\n",Ope);
 return Ope;
}

int ConfirmOpe(char* SVMTrainFile,char* SVMRep,int Ope)
{
 // User confirmation of the operator
 printf("Operator is:%s , press enter to confirm or indicate the correct one (+ - * /):",OpeText[Ope-1]);
 static char ope[10];
 gets(ope);
 if(ope[0]) // Error, new operator
   switch(ope[0])
   {
    case '+' : Ope=SUM; break;
    case '-' : Ope=SUB; break;
    case '*' : Ope=PRO; break;
    case '/' : Ope=DIV; break;
   }
 printf("Operator confirmated: %s\n",OpeText[Ope-1]);
 
 // Insert this new example in train file
 FILE * F=fopen(SVMTrainFile,"at"); // Append
 fprintf(F,"%d%s\n",Ope,SVMRep);
 fclose(F);
 
 return Ope;
}

void MakeOperation(int Ope,int N1,int N2)
{
 int Res;
 switch(Ope)
 {
  case SUM: Res=N1+N2; break;
  case SUB: Res=N1-N2; break;
  case PRO: Res=N1*N2; break;
  case DIV: Res=N1/N2; break;
 }
 printf("%d%s%d=%d\n",N1,OpeText[Ope-1],N2,Res);
}

void CA(WordRepre * WR,char * SVMTrainFile)
{
 bool Exit=false;
 printf("Welcome to Conversational Agent: Calculator. Tell me a binary(+,-,*,/) operation\n");
 printf("Write words sparated by blank space\n");
 printf("Write 'exit' to exit\n");

 char Buff[MAX_LINE];
 char SVMRep[MAX_LINE];
 printf("> "); gets(Buff);
 while(strcmp(Buff,"exit"))
 {
   int N1,N2;
   GetSVMRepNumbers(Buff,WR,SVMRep,&N1,&N2);
   int Ope=PredictOpe(SVMTrainFile,SVMRep);
   Ope=ConfirmOpe(SVMTrainFile,SVMRep,Ope);
   MakeOperation(Ope,N1,N2); 
   
   printf("> "); gets(Buff);
 }
 
}

void Help()
{
 printf("CACalculator VocabularyFile WordsAsVectorsFile SVMTrainFile\n");
 printf("Conversational Agent Calculator\n");
 printf("- VocabularyFile: a text file with a word and its vector in each line\n");
 printf("- WordsAsVectorsFile: a text file containg (all) Words as Vectors\n");
 printf("- SVMTrainFile: a libsvm train file. Each line is a bag-of-word representation\n");
 printf("    of a user sentence. Its category will be 1 to 4 corresponding to + - * /\n");

 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<4) Help();
 
 WordVector * WV=new WordVector(argv[2]); // Precalculated vector for each Word
 WordRepre  * WR=new WordRepre(argv[1],WV); // Representation on each Word
 CA(WR,argv[3]);
 
 return 0;
}

