%{
  #include <stdio.h>
  #include "defs.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  extern int yylineno;
%}

%token _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token _ID
%token _INT_NUMBER
%token _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token _COMA
%token _AROP
%token _RELOP
%token _LOGOP
%token _DO
%token _INC
%token _WHILE
%token _STEP
%token _NEXT
%token _DIR
%token _FOR
%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
  ;

function_list
  : function
  | function_list function
  ;

function
  : type _ID _LPAREN parameter _RPAREN body
  ;

type
  : _TYPE
  ;

parameter
  : /* empty */
  | type _ID
  ;

body
  : _LBRACKET variable_list statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variables
  ;

variables
  : type variable _SEMICOLON
  ;

variable
  : _ID
	| variable _COMA _ID
  ;

statement_list
  : /* empty */
  | statement_list statement
  ;

statement
  : compound_statement
  | assignment_statement
  | if_statement
  | return_statement
	| do_statement
	| inkrement
	| for_statement
  ;
for_deo
	:	_FOR _ID _ASSIGN literal _DIR literal 
	|	for_deo _STEP literal
	;

for_statement
	: for_deo statement _NEXT _ID 
	;
compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
  ;

num_exp
  : exp
  | num_exp _AROP exp
  ;

exp
  : literal
  | _ID
	| _ID _INC 
  | function_call
  | _LPAREN num_exp _RPAREN 
  ;
inkrement
	:_ID _INC _SEMICOLON
	;
literal
  : _INT_NUMBER
  | _UINT_NUMBER
  ;

function_call
  : _ID _LPAREN argument _RPAREN
  ;

argument
  : /* empty */
  | num_exp
  ;

if_statement
  : if_part %prec ONLY_IF //privremena kao idk
  | if_part _ELSE statement
  ;

if_part
  : _IF _LPAREN log_exp _RPAREN statement
  ;
do_statement
	:_DO statement_list _WHILE _LPAREN rel_exp _RPAREN _SEMICOLON
	;
log_exp
	:	rel_exp
	| log_exp _LOGOP rel_exp
	;
rel_exp
  : num_exp _RELOP num_exp
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  return 0;
}

int main() {
  return yyparse();
}
