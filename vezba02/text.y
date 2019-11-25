%{
  #include <stdio.h>
  int yylex(void);
	int i=0;
	int p=0;
	int uz=0;
	int up=0;
  int yyparse(void);
  int yyerror(char *);
  extern int yylineno;
%}

%token  _DOT
%token  _CAPITAL_WORD
%token  _WORD
%token  _EMARK
%token  _QMARK
%token  _COMA
%token  _NL
%%

text 
  : paragraph _NL{p++;}
	| _NL
  | text paragraph _NL{p++;} 
  ;

paragraph
	:sentence 
	|paragraph sentence
;
kraj
	: _DOT {i++;}
	| _EMARK {uz++;}
	| _QMARK {up++;}
	;      
sentence 
  : _CAPITAL_WORD words kraj
  ;

words 
	:/*nista*/
	| words _COMA _WORD
	| words _WORD
  | words _COMA _CAPITAL_WORD    
  | words _CAPITAL_WORD    
  ;

%%

int main() {
  yyparse();
	printf("Ima %d,%d,%d,%d izjavnih,upitnih,uzvicnih,pasusa",i,up,uz,p);
}

int yyerror(char *s) {
  fprintf(stderr, "line %d: SYNTAX ERROR %s\n", yylineno, s);
} 

