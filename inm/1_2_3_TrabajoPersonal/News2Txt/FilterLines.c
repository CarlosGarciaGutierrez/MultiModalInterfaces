#include "stdio.h"

#define MAX_LINE 1024
#define MAX_TXT 202400

unsigned int ReadLine(FILE * F)
{
 static char Buf[MAX_LINE];
 fgets(Buf,MAX_LINE,F);
 unsigned int L;
 sscanf(Buf,"%d",&L);
 return L;
}

int main(int argc,char* argv[])
{
 FILE* FTXT=fopen(argv[1],"rt");
 FILE* FLIN=fopen(argv[2],"rt");
 unsigned int LineN=ReadLine(FLIN);
 
 static char Buf[MAX_TXT];
 
 unsigned int i=0;
 while(!feof(FLIN))
 {
  fgets(Buf,MAX_TXT,FTXT);
  i++;
  if(i==LineN)
  {
   printf("%s",Buf);
   LineN=ReadLine(FLIN);
  }
 }
 
 fclose(FLIN);
 fclose(FTXT);
}