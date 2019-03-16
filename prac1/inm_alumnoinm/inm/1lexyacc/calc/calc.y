%{
#include <stdio.h>

void yyerror(char* msg);

#define YYSTYPE int
int IntDiv(int a,int b);
%}

%token INT PA PC
%left MAS MEN POR DIV

%%
inst	: expr	{printf("%d\n",$1);}
	;

expr	: factor	{$$=$1;}
	| expr MAS expr	{$$=$1+$3;}
	| expr MEN expr	{$$=$1-$3;}
	| MEN expr	{$$=-$1;}
	;
	
factor	: INT			{$$=$1;}
	| PA expr PC		{$$=$2;}
	| factor POR factor	{$$=$1*$3;}
	| factor DIV factor	{$$=IntDiv($1,$3);}
	;
%%
#include <stdio.h>
#include <stdlib.h>

void yyerror(char* msg)
{
 printf("Syntactic error:%s\n",msg);
 exit(2);
}

int IntDiv(int a,int b)
{
 if(b==0)
 {
  printf("ERROR: division by 0\n");
  exit(1);
 }
 return a/b;
}

int main()
{
 yyparse();
}

