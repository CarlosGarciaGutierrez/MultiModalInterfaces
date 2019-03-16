%{
#include "calc_tok.h"

int ReadInt(char* Cad);
void LexError(char* ErrChar);
%}

DIG [0-9]
INT {DIG}+
SEP [ \t]
%%
{INT}	{yylval=ReadInt(yytext); return INT;}
"("	return PA;
")"	return PC;
"+"	return MAS;
"-"	return MEN;
"*"	return POR;
"/"	return DIV;
{SEP}	;
.	{LexError(yytext);}
%%
int yywrap()
{
 return 1;
}

int ReadInt(char* Cad)
{
 int v;
 sscanf(Cad,"%d",&v);
 return v;
}

void LexError(char* ErrChar)
{ 
 printf("Lexical error: '%s' is not a valid character\n",ErrChar);
 exit(1);
}

