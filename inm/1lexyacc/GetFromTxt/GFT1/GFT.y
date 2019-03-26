%{
// Get From Text
#include <stdio.h>

void yyerror(char* msg);

struct LValue
{
 char * Word;
 char RelPos;
 LValue * NextRelPos;
 
 LValue(char * word)
 {
  Word=word;
  RelPos='\0';
  NextRelPos=NULL;
 }
 
 void Print()
 {
  if (RelPos=='A')
    printf("AFTER ");
  else if(RelPos=='B')
    printf("BEFORE ");
  else printf("NEVER WRITE THIS ERROR ");
  printf("%s ",Word);
  
  if(NextRelPos)
  {
   printf("AND ");
   NextRelPos->Print();
  }
  else printf("\n");
 }
};
typedef LValue * PLValue;

#define YYSTYPE PLValue

extern int yylex();
%}

%token AND BEFORE AFTER LIMIT
%%
Input		: Question {$1->Print();}
		;
		
Question	: RelativePos {$$=$1;}
		| Question AND RelativePos {$$=$3;$$->NextRelPos=$1;}
		;

RelativePos	: BEFORE LIMIT {$$=$2; $$->RelPos='B';}
		| AFTER LIMIT  {$$=$2; $$->RelPos='A';}
		;
%%
#include <stdio.h>
#include <stdlib.h>

#include "GFTlex.cpp"

void yyerror(char* msg)
{
 printf("Syntactic error:%s\n",msg);
 exit(2);
}

int main()
{
 yyparse();
}

