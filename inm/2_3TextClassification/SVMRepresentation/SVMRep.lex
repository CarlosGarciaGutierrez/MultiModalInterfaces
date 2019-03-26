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
#include <map>
using namespace std;

#define MAX_N 16
#define MAX_NGRAMA_LEN 131072

int NEjemplos=0;
int NPalabras=0;

map<string,int> NGrams;

FILE * SVMF=NULL;
int N=-1;
char AttValue='\0';

int NSecWords=0;
char * SecWords[MAX_N];
char ActualNGrama[MAX_NGRAMA_LEN];

int A=0; // Nº atributos = Nº ngramas
int *ACount=NULL; // Contador de repeticiones de ngramas en documento

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
  // Creo el NGrama
  ActualNGrama[0]='\0'; // Concateno las palabras al ngrama
  for(i=0;i<N;i++)
    sprintf(ActualNGrama+strlen(ActualNGrama),"%s ",SecWords[i]);
  ActualNGrama[strlen(ActualNGrama)-1]='\0'; // Sustituir el último ' ' por '\0'
  
  //printf("Busco NGrama:\'%s\'",ActualNGrama);

  // Busco el ngrama en el map para obtener el atributo
  static string S;
  S=ActualNGrama;
  map<string,int>::iterator it=NGrams.find(S);
  if(it!=NGrams.end()) // Encontrado
    ACount[it->second]++; // Incremento el contador de ese ngrama
 }
}

void FinEjemplo()
{
 // Vacío la secuencia de Palabras
 int i;
 for(i=0;i<NSecWords;i++)
   free(SecWords[i]); // Libero las palabras que haya actualmente en la secuencia
 NSecWords=0; // Pongo el contador a 0

 // Imprimo el ejemplo
 int ExaNGr=0;    // Contador del número de ngramas 
 if(AttValue=='p')
   for(int i=1;i<A;i++)
      if(ACount[i])
        ExaNGr+=ACount[i];
        
 for(int i=1;i<A;i++)
   if(ACount[i]>0)
     {
      fprintf(SVMF," %d:",i);
      switch(AttValue)
       {
        case 'b': fprintf(SVMF,"1"); break;
        case 'c': fprintf(SVMF,"%d",ACount[i]); break;
        case 'p': fprintf(SVMF,"%g",float(ACount[i])/ExaNGr); break;
       }
     }
 fprintf(SVMF,"\n");  
 
 // Reinicio el contador de ngramas
 for(int i=1;i<A;i++)
   ACount[i]=0;
   
 NEjemplos++;
 if(NEjemplos%100==0)
   printf("Ejemplos tratados: %d, Palabras:%d\n",NEjemplos,NPalabras);
}

void LeeNGrams(char* NGramsFile)
{
 FILE * NGramsF=fopen(NGramsFile,"rt");
 
 // Primer elemento
 char* ReadOK=fgets(ActualNGrama,MAX_NGRAMA_LEN-1,NGramsF);
 A=1; // Atributo
 while(!feof(NGramsF)) // Mientras no final
 {
  // Tratar elemento
  ActualNGrama[strlen(ActualNGrama)-1]='\0'; // Sustituir el último '\n' por '\0'
  string *S=new string(ActualNGrama);
  NGrams.insert(pair<string,int>(*S,A));
  
  // Siguiente elemento
  ReadOK=fgets(ActualNGrama,MAX_NGRAMA_LEN-1,NGramsF);
  A++;  
 }
 
 fclose(NGramsF);
 
 printf("NGramas leidos: %d\n",A-1);
 
 // Crear el array de contadores de ngramas
 ACount=new int[A];
 for(int i=0;i<A;i++) // Inicializar array
   ACount[i]=0;
}

void Ayuda()
{
 printf("SVMRep TextFile N NGramsFile SVMFile AttValue\n");
 printf(" -TextFile es un fichero que tiene palabras separadas por espacios en blanco.\n");
 printf("   Cada fila será un ejemplo\n");
 printf(" -N es un entero que indica el número de palabras seguidas que forman un ngrama\n");
 printf(" -NGramsFile es el fichero que tendrá en cada línea un N-Grama (ver NGrams)\n");
 printf(" -SVMFile es el fichero donde se escribirá TextFile en formato SVM usando\n");
 printf("   los NGrams como atributos\n");
 printf(" -AttValue indica cual será el valor del atributo:\n");
 printf("   bin  : binario, 1 si existe el ngrama, 0 si no\n");
 printf("   count: conteo, número de veces que se repite el ngrama en el documento\n");
 printf("   prop : proprocion, proporción de ocurrencias del ngrama entre los ngramas del\n");
 printf("           documento\n");
 exit(1);
}

int main(int argc,char* argv[])
{
 if(argc<6) Ayuda();
 
 yyin=fopen(argv[1],"rt");
 N=atoi(argv[2]);
 LeeNGrams(argv[3]);
 SVMF=fopen(argv[4],"wt");
 AttValue=argv[5][0]; // (b)in (c)ount (p)rop
 
 yylex();
 
 fclose(SVMF);
 fclose(yyin);
 
 return 0;
}

