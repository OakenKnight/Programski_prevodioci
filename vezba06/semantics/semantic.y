%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
	int tip=0;
	int ret_cnt=0;
	int lvl=0;
	int case_array[100];
	int switch_type=0;
	int array_len=0;
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _SEMICOLON
%token <i> _AROP
%token <i> _RELOP
%token _PLUSPLUS
%token _COMA
%token _SWITCH
%token _CASE
%token _DEFAULT
%token _BREAK
%token _COLON
%token _DO
%token _FOR

%token _WHILE
%type <i> num_exp exp literal function_call argument rel_exp assigns

%nonassoc ONLY_IF
%nonassoc _ELSE

%%

program
  : function_list
      {  
        if(lookup_symbol("main", FUN) == NO_INDEX)
          err("undefined reference to 'main'");
       }
  ;

function_list
  : function
  | function_list function
  ;

function
  : _TYPE _ID
      {
				lvl=0;
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
				
				if(ret_cnt==0 && (get_type(fun_idx)!=VOID))
					warn("Function should return value");
				
				ret_cnt=0;
				
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
				if($1==VOID){
					err("void greska par");
				}
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;

body
  : _LBRACKET variable_list statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variables
  ;

variables
	: _TYPE 
		{
		 	tip=$1;	
			if($1==VOID)
	    err("variable type void");	
		}
		 id_list _SEMICOLON
	;

id_list
  :  _ID
      {
				int indeks=lookup_symbol($1, VAR|PAR);
        if( indeks == NO_INDEX ||  get_atr2(indeks) != lvl) 
           insert_symbol($1, VAR, tip, ++var_num, lvl);
        else 
           err("redefinition of '%s'", $1);
      }
	| id_list _COMA _ID
			{
				int indeks=lookup_symbol($3, VAR|PAR);
        if(indeks == NO_INDEX || get_atr2(indeks)!=lvl)
           insert_symbol($3, VAR, tip, ++var_num, lvl);
        else 
           err("redefinition of '%s'", $3);
      }
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
	| switch_statement
	|for_statement
  ;
switch_statement
	: _SWITCH _LPAREN _ID 
		{
				int indeks=lookup_symbol($3,VAR|PAR);
				if(indeks==NO_INDEX)
						err("'%s' undeclared", $3);
				switch_type=get_type(lookup_symbol($3, VAR|PAR));
		}
		_RPAREN _LBRACKET case_statements default_statement _RBRACKET
	;
case_statements
	: case_statement
	| case_statements case_statement
	;
case_statement
	:	_CASE literal 
		{
			if(switch_type!=get_type($2))
				err("Nisu istog tipa");
			int i=0;
			int lit=atoi(get_name($2));
			while(i<array_len){
				if(case_array[i]==lit)
					err("Postoji duplikat za %d",lit);
				i++;						
			}

			if(i==array_len)
				{
					case_array[i]=lit;
					array_len++;			
				}
		} _COLON statement break_statement
	;
break_statement
	: /*nista*/
	| _BREAK _SEMICOLON
	;
default_statement
	: /*nista*/
	| _DEFAULT _COLON statement
	;
for_statement
	: _FOR _LPAREN _TYPE _ID _ASSIGN literal 
		{
			lvl++;
			$<i>$ = get_last_element();


			int idx=lookup_symbol($4,VAR|PAR);

			if($3==VOID)
				err("Void tip");
			else if ($3!=get_type($6))
				err("razliciti tipovi");
			if(idx==NO_INDEX || get_atr2(idx)!=lvl)
				insert_symbol($4, VAR, $3, ++var_num, lvl);
			else
				err("redefinition of %s",$4);			
		}
		_SEMICOLON rel_exp _SEMICOLON _ID _PLUSPLUS
		{	
			int idx=lookup_symbol($11, VAR|PAR);
			if(idx==NO_INDEX)
				err("%s undeclared",$11);
			if(idx!=lookup_symbol($4,VAR|PAR))
				err("must be same variables");
		}
		 _RPAREN statement
			{
				lvl--;
				clear_symbols($<i>7+1);
			}
	;
do_statement
	: _DO statement _WHILE _LPAREN _ID _RELOP literal _RPAREN _SEMICOLON
		{
				int indeks=lookup_symbol($5,VAR|PAR);
			if(indeks==NO_INDEX){
				err("'%s' undeclared", $5);
			}else
				if(get_type(indeks)!=get_type($7))
				            err("incompatible types in assignment");
		}
	;


compound_statement
  : _LBRACKET
		{
			lvl++;
			$<i>$ = get_last_element(); //ovo je zato sto nam treba da znamo da ce ta vrednost biti int i da to mozemo da strpamo u $$ i ne bi bas bilo kul da stavim u %type <i> jer to se onda odnosi na ceo compound_statement a ovako samo na akciju na vrednosti tokena $2
		}
		 variable_list statement_list _RBRACKET
		{
			lvl--;
			clear_symbols($<i>2 + 1);		//dvojka je zato sto treba da brisem od poslednjeg elementa pa plus 1 jer je poslednji element vrednost akcije sa tokenom $2 
		}
  ;

assignment_statement
  : assigns num_exp _SEMICOLON
      {
					
          if(get_type($1) != get_type($2))
            err("incompatible types in assignment");
      }
  ;
assigns
	: _ID _ASSIGN
		{
			$$=lookup_symbol($1,VAR|PAR);
			if($$==NO_INDEX)
				err("%s undeclared",$1);
		}
	| assigns _ID _ASSIGN
		{
			if(get_type($1)!=get_type(lookup_symbol($2,VAR|PAR)))
				err("incompatible types in assignment");
	}
	;
num_exp
  : exp
  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation");
      }
  ;

exp
  : literal
  | _ID
      {
        $$ = lookup_symbol($1, VAR|PAR);
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
      }
	| _ID _PLUSPLUS
			{
				$$ = lookup_symbol($1, VAR|PAR); //pored toga sto pojedinacni tokeni mogu imati svoje vrenodsti tako mogu i sama praivia, tako %type sugerise da pravila ta i ta su pravila koja nose vrednost
        if($$ == NO_INDEX)
          err("'%s' undeclared", $1);
			}
  | function_call
  | _LPAREN num_exp _RPAREN
      { $$ = $2; }
  ;

literal
  : _INT_NUMBER
      { $$ = insert_literal($1, INT); }

  | _UINT_NUMBER
      { $$ = insert_literal($1, UINT); }
  ;

function_call
  : _ID 
      {
        fcall_idx = lookup_symbol($1, FUN);
        if(fcall_idx == NO_INDEX)
          err("'%s' is not a function", $1);
      }
    _LPAREN argument _RPAREN
      {
        if(get_atr1(fcall_idx) != $4)
          err("wrong number of args to function '%s'", 
              get_name(fcall_idx));
        set_type(FUN_REG, get_type(fcall_idx));
        $$ = FUN_REG;
      }
  ;

argument
  : /* empty */
    { $$ = 0; }

  | num_exp
    { 
      if(get_atr2(fcall_idx) != get_type($1))
        err("incompatible type for argument in '%s'",
            get_name(fcall_idx));
      $$ = 1;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
  | if_part _ELSE statement
  ;

if_part
  : _IF _LPAREN rel_exp _RPAREN statement
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
      }
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
      {
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
				if (get_type(fun_idx) == VOID)
					err("void nema povratnu vrednost");
				ret_cnt++;
      }
	| _RETURN _SEMICOLON
		{
			if (get_type(fun_idx) != VOID)
					warn("fja nije void pa treba da ima povratnu vrednost");
			ret_cnt++;		
		}
  ;

%%

int yyerror(char *s) {
  fprintf(stderr, "\nline %d: ERROR: %s", yylineno, s);
  error_count++;
  return 0;
}

void warning(char *s) {
  fprintf(stderr, "\nline %d: WARNING: %s", yylineno, s);
  warning_count++;
}

int main() {
  int synerr;
  init_symtab();

  synerr = yyparse();

  clear_symtab();
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count)
    printf("\n%d error(s).\n", error_count);

  if(synerr)
    return -1; //syntax error
  else
    return error_count; //semantic errors
}

