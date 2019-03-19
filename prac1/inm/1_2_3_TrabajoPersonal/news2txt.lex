%{
FILE * CatF, *TxtF;
%}
WORD [^,\n ]+
%X CAT BODY
%%
"Newsgroups: "	{BEGIN CAT;}
<CAT>{WORD}	{fprintf(CatF,"%s ",yytext);}
<CAT>.		;
<CAT>\n		{BEGIN 0;}
"Lines:".*\n	{BEGIN BODY;}
<BODY>.*	{fprintf(TxtF,"%s ",yytext);}
<BODY>\n	;
.|\n		;
%%

int yywrap()
{
 return 1;
}

void Help()
{
 printf("news2txt newsfile catfile txtfile\n");
 printf("  newsfile: fichero en formato news origen de los datos\n");
 printf("  catfile: añadirá una línea a este fichero con las categorías\n");
 printf("  txtfile: añadirá una línea a este fero con el texto\n");

 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<=3) Help();
 yyin=fopen(argv[1],"rt");

 CatF=fopen(argv[2],"at");
 TxtF=fopen(argv[3],"at");

 yylex();
 fprintf(CatF,"\n"); 
 fprintf(TxtF,"\n");
 
 return 0;
}

