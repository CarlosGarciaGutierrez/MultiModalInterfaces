%{
void IniTopic();
void TrataTopic(char*);
void FinTopics();
void IniBody();
void TrataBody(char*);
void TrataBodyNL();
void FinBody();
%}

TOP "<D>"[^<\n]+"</D>"
BODYLINE [^\n]+

%x TOPICS BODY
%%
"<TOPICS>"		{IniTopic(); BEGIN(TOPICS);}
<TOPICS>{TOP}		{TrataTopic(yytext);}
<TOPICS>"</TOPICS>"	{FinTopics(); BEGIN(0);}
"<BODY>"		{IniBody(); BEGIN(BODY);}
<BODY>"</BODY>"		{FinBody(); BEGIN(0);}
<BODY>.			{TrataBody(yytext);}
<BODY>\n		{TrataBodyNL();}
.|\n			;
%%
int yywrap()
{
 return 1;
}

#include <string.h>

#define MAX_TAGS 16384
#define MAX_ALL_TAGS_LEN 1024
#define MAX_TAG_LEN 128

int NTopics=0;
int HayTopics=0;
FILE * CatF=NULL;
FILE * TextF=NULL;
FILE * TagF=NULL;
char TagBuff[MAX_ALL_TAGS_LEN];
unsigned NTags=0;
char *Tags[MAX_TAGS];

void IniTopic()
{
 NTopics++;
 HayTopics=0;
 TagBuff[0]='\0';
}

void AlmacenaTag(char * Tag)
{
 // Buscar el Tag
 unsigned i;
 for(i=0;i<NTags;i++)
   if(!strcmp(Tag,Tags[i])) return; // Si ya está no se hace nada
   
 // Insertar Tag
 Tags[NTags]=(char*)malloc(strlen(Tag)+1);
 strcpy(Tags[NTags],Tag);
 NTags++;
}

void TrataTopic(char* t)
{
 static char Tag[MAX_TAG_LEN];
 HayTopics=1;
 
 sprintf(Tag,"%s",t+3);
 Tag[strlen(Tag)-4]='\0';
 AlmacenaTag(Tag);
 sprintf(TagBuff+strlen(TagBuff),"%s ",Tag);
}
void FinTopics()
{
}
void IniBody()
{
 // if(HayTopics) 	fprintf(TextF,"(%d)",NTopics);
}
void FinBody()
{
 if(HayTopics)
  {
	 fprintf(TextF,"\n");
	 fprintf(CatF,"%s\n",TagBuff);
  }
}
void TrataBody(char* l)
{
 if(HayTopics)
	 fprintf(TextF,"%s",l);
}
void TrataBodyNL()
{
 if(HayTopics)
 	fprintf(TextF," ");
}

void EscribeTags()
{
 unsigned i;
 for(i=0;i<NTags;i++)
   fprintf(TagF,"%s\n",Tags[i]);
}

void Ayuda()
{
 printf("XML2MLText XMLFile CategoryFile TextFile TagsFile\n");
 printf("Dado un fichero XML añade por cada documento, una línea en CategoryFile con los tags y otra en TextFile con el cuerpo del documento.\n");
 printf("Al final del proceso escribe en TagsFile el conjunto de tags de todos los documentos\n"); 
 
 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<5) Ayuda();
 
 yyin=fopen(argv[1],"rt");
 CatF=fopen(argv[2],"wt");
 TextF=fopen(argv[3],"wt");
 TagF=fopen(argv[4],"wt");
 
 yylex();
 EscribeTags();
 
 fclose(yyin);
 fclose(CatF);
 fclose(TextF);
 fclose(TagF);
 
 return 0;
}

