%{
void TrataWord(char*W);
void FinCates();
%}

WORD [^ \n]+

%%
{WORD}	{TrataWord(yytext);}
" "	;
\n	{FinCates();}
%%
int yywrap()
{
 return 1;
}


int NEjemplos=0;
int NUnos=0;

FILE* AttSVM=NULL;
char* OneCat=NULL;
FILE* SVMF=NULL;

int HayCate=0; 

void TrataWord(char* W)
{
 if(!strcmp(W,OneCat))
   HayCate=1;
}

void FinCates()
{
 if(HayCate) // Escribiendo la categoría
 {  
   fprintf(SVMF,"1");
   NUnos++;
 }
 else
   fprintf(SVMF,"-1");
 HayCate=0;
 
 // Concatenando los atributos de este documento
 char c; 
 do
 {
  c=(char)fgetc(AttSVM);
  fputc(c,SVMF);
 }while(c!='\n');
   
 NEjemplos++;
 if(NEjemplos%100==0)
   printf("Ejemplos tratados: %d , de categoría %s: %d\n",NEjemplos,OneCat,NUnos);
}

void Ayuda()
{
 printf("OneLabelSVM Categories AttSVM OneCategory SVMFile\n");
 printf("-Categories: fichero que contiene en cada línea las categorías de cada documento\n");
 printf("-AttSVM: el fichero que contiene en cada línea los atributos de cada documento\n");
 printf("   en formato SVM\n");
 printf("-OneCategory: si el documento tiene esta categoría será de calse 1 si no 0\n");
 printf("-SVMFile: fichero donde se escribirán los documentos y las clases de una\n");
 printf("   categoría\n");

 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<5) Ayuda();
 
 yyin=fopen(argv[1],"rt");
 AttSVM=fopen(argv[2],"rt");
 OneCat=argv[3];
 SVMF=fopen(argv[4],"wt");
 
 yylex();
 printf("TOTAL: Ejemplos tratados: %d , de categoría %s: %d\n",NEjemplos,OneCat,NUnos);
 
 fclose(SVMF);
 fclose(AttSVM);
 fclose(yyin);
 
 return 0;
}

