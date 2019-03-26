%{
void TrataWord(char*W);
void FinEjemplo();
%}

WORD [^ \n]+

%%
{WORD}	{TrataWord(yytext);}
" "	;
\n	{FinEjemplo();}
%%
int yywrap()
{
 return 1;
}

#include <string>
#include <set>
using namespace std;

#define MAX_N 16
#define MAX_NGRAMA_LEN 131072

int NEjemplos=0;
int NPalabras=0;

set<string> NGrams;

FILE * NGramF=NULL;
int N=-1;

int NSecWords=0;
char * SecWords[MAX_N];

char * Copia(char* W)
{
 char * C=new char[strlen(W)+1];
 sprintf(C,"%s",W);
 return C;
}


void TrataWord(char* W)
{
 int i;
 NPalabras++;

 if(NSecWords==N) // La secuencia está llena
 {
   free(SecWords[0]);    // Libero la primera palabra de la secuencia
   for(i=0;i<(N-1);i++)  // Quito la primera
     SecWords[i]=SecWords[i+1];
   NSecWords--;
 }
 
 // Inserto la nueva palabra
 SecWords[NSecWords]=Copia(W);
 NSecWords++;
 
 if(NSecWords==N) // Tengo una secuencia llena
 {
  static char ActualNGrama[MAX_NGRAMA_LEN];
  // Creo el NGrama
  ActualNGrama[0]='\0'; // Concateno las palabras al ngrama
  for(i=0;i<N;i++)
    sprintf(ActualNGrama+strlen(ActualNGrama),"%s ",SecWords[i]);
  ActualNGrama[strlen(ActualNGrama)-1]='\0'; // Sustituir el último ' ' por '\0'
  

  // Lo inserto en el conjunto
  string *S=new string(ActualNGrama);
  NGrams.insert(*S);

  delete S; // Libero el string
 }
}

void FinEjemplo()
{
 // Vacío la secuencia de Palabras
 int i;
 for(i=0;i<NSecWords;i++)
   free(SecWords[i]); // Libero las palabras que haya actualmente en la secuencia
 NSecWords=0; // Pongo el contador a 0

 NEjemplos++;
 if(NEjemplos%100==0)
   printf("Ejemplos tratados: %d, Palabras:%d, %dGramas:%d\n",NEjemplos,NPalabras,N,NGrams.size());
}

void EscribeNGramas()
{
 for(set<string>::iterator i=NGrams.begin();i!=NGrams.end();i++)
   fprintf(NGramF,"%s\n",(*i).c_str());
}

void Ayuda()
{
 printf("NGrams TextFile N NGramsFile\n");
 printf(" -TextFile es un fichero que tiene palabras separadas por espacios en blanco.\n");
 printf("   Cada fila será un ejemplo\n");
 printf(" -N es un entero que indica el número de palabras seguidas que forman un ngrama\n");
 printf(" -NGramsFile es el fichero de salida que tendrá en cada línea un N-Grama\n");
 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<4) Ayuda();
 
 yyin=fopen(argv[1],"rt");
 N=atoi(argv[2]);
 
 yylex();
 
 fclose(yyin);
 
 NGramF=fopen(argv[3],"wt");
 EscribeNGramas();
 fclose(NGramF);
 
 return 0;
}

