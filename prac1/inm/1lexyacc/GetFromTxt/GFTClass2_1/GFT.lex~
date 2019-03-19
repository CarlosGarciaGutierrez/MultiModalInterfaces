%{
#define MAX_WORD_LEN 128

int Token(char* yytext);
char * DuplicateStr(char * yytext);
%}
CHAR [A-Za-z]
WORD {CHAR}+
%%
{WORD}		{int Tok=Token(yytext); if(Tok>0) return Tok;}
\"{WORD}\"	{yylval= new Word(DuplicateStr(yytext)); return LIMIT;}
.|\n		; 
%%
int yywrap()
{
 return 1;
}

#include <string.h>

static char Buffer[MAX_WORD_LEN];
static void ToBuffer(char * yytext)
{
 // Check the length 
 int Len=strlen(yytext);
 if(Len>=MAX_WORD_LEN)
 {
  printf("ERROR: word larger than %d\n",MAX_WORD_LEN);
  exit(-1);
 }
 
 // To uppercase and store in buffer
 int i;
 for(i=0;i<strlen(yytext);i++)
   {
    char c=yytext[i]; // Get the character
    if(c>='a' && c<='z')
      c=c-'a'+'A';
    Buffer[i]=c;
   }
 Buffer[i]='\0'; 
}

int Token(char* yytext)
{
 ToBuffer(yytext);
   
 // Chek if it is a token
 if(strcmp(Buffer,"AND")==0)
   return AND;
 else if (strcmp(Buffer,"AFTER")==0)
   return AFTER;
 else if (strcmp(Buffer,"BEFORE")==0)
   return BEFORE;
 else return 0;   // It is not a informative word (ignore it)
}

char * DuplicateStr(char * yytext)
{
 ToBuffer(yytext+1); // Remove the first '"
 Buffer[strlen(Buffer)-1]='\0'; // Remove the last '"
 
 // Create a copy
 char * Limit=(char*)malloc(strlen(Buffer+1));
 strcpy(Limit,Buffer);
 
 return Limit;
}

