%{
// Get From Text
#include <stdio.h>

void yyerror(char* msg);

class Nodo{
 public:
 virtual void print()=0; 
};
typedef Nodo * PNodo;

class Word : public Nodo{
  public:
  char * WordVal;
  Word(char* Nombre){WordVal=Nombre;}

  virtual void print(){
    if(WordVal)  
      printf("%s ",WordVal);
  }
};
typedef Word * PWord;

class RelPos : public Nodo{
  public:
  Word * W;
  char RP;
  RelPos(char _RP,Word * _W){RP=_RP;W=_W;}

  virtual void print(){
    if(RP=='A')
    printf("AFTER ");
    else if(RP=='B')
      printf("BEFORE ");
    else printf("NEVER WRITE THIS ERROR ");
    W->print();
  }
};
typedef RelPos * PRelPos;

class ListRelPos : public Nodo{
  public:
  ListRelPos * Next;
  RelPos * RP;
  ListRelPos(RelPos * _RP){
    RP=_RP;
    Next=NULL;
  }

  virtual void print(){
    if(RP) RP->print();
    if(Next) {
      printf(" AND ");
      Next->print();
    }
  }
};
typedef ListRelPos * PListRelPos;

class ListConj : public Nodo{
  public:
  ListRelPos * LRP;
  ListConj * Next;
  ListConj(ListRelPos * _LRP){
    LRP=_LRP;
    Next=NULL;
  }

  virtual void print(){
    printf("(");
    if(LRP) LRP->print();
    if(Next) {
      printf(") OR (");
      Next->print();
    }
    printf(")");
  }
};
typedef ListConj * PListConj;

#define YYSTYPE PNodo

extern int yylex();
%}

%token AND BEFORE AFTER LIMIT OR
%%
Input		: Disyun {$1->print(); printf("\n");}
		;

Disyun		: Conjun {$$=new ListConj(PListRelPos($1));}
		| Disyun OR Conjun {$$=new ListConj(PListRelPos($3));
                                    PListConj($$)->Next=PListConj($1);}
		;
	
Conjun		: RelativePos {$$=new ListRelPos(PRelPos($1));}
		| Conjun AND RelativePos {$$=new ListRelPos(PRelPos($3));
                                          PListRelPos($$)->Next=PListRelPos($1);}
		;

RelativePos	: BEFORE LIMIT {$$=new RelPos('B',PWord($2));}
		| AFTER LIMIT  {$$=new RelPos('A',PWord($2));}
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

