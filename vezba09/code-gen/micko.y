%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "defs.h"
  #include "symtab.h"
  #include "codegen.h"

  int yyparse(void);
  int yylex(void);
  int yyerror(char *s);
  void warning(char *s);

  extern int yylineno;
  int out_lin = 0;
  char char_buffer[CHAR_BUFFER_LENGTH];
  int error_count = 0;
  int warning_count = 0;
  int var_num = 0;
  int fun_idx = -1;
  int fcall_idx = -1;
  int lab_num = -1;
	int switch_literals[100];
	int switch_literal_num=0;
	int switch_var;
	int switch_num=-1;
	int lvl=-1;
  FILE *output;
%}

%union {
  int i;
  char *s;
}

%token <i> _TYPE
%token _IF
%token _ELSE
%token <i> _DIRECTION
%token _RETURN
%token <s> _ID
%token <s> _INT_NUMBER
%token <s> _UINT_NUMBER
%token _LPAREN
%token _STEP
%token _RPAREN
%token _LBRACKET
%token _RBRACKET
%token _ASSIGN
%token _FOR
%token _BREAK
%token _DEFAULT
%token _WHILE
%token _INC
%token _CASE
%token _COLON
%token _SWITCH
%token _SEMICOLON
%token _DO
%token _U
%token _OD
%token _PETLJAJ
%token _U_OPSEGU
%token _PREKID
%token _PRESKOK
%token _NEXT
%token <i> _AROP
%token <i> _RELOP
%type <i> num_exp exp literal 
%type <i> function_call argument rel_exp if_part 

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
        fun_idx = lookup_symbol($2, FUN);
        if(fun_idx == NO_INDEX)
          fun_idx = insert_symbol($2, FUN, $1, NO_ATR, NO_ATR);
        else 
          err("redefinition of function '%s'", $2);

        code("\n%s:", $2);
        code("\n\t\tPUSH\t%%14");
        code("\n\t\tMOV \t%%15,%%14");
      }
    _LPAREN parameter _RPAREN body
      {
        clear_symbols(fun_idx + 1);
        var_num = 0;
        
        code("\n@%s_exit:", $2);
        code("\n\t\tMOV \t%%14,%%15");
        code("\n\t\tPOP \t%%14");
        code("\n\t\tRET");
      }
  ;

parameter
  : /* empty */
      { set_atr1(fun_idx, 0); }

  | _TYPE _ID
      {
        insert_symbol($2, PAR, $1, 1, NO_ATR);
        set_atr1(fun_idx, 1);
        set_atr2(fun_idx, $1);
      }
  ;

body
  : _LBRACKET variable_list
      {
        if(var_num)
          code("\n\t\tSUBS\t%%15,$%d,%%15", 4*var_num);
        code("\n@%s_body:", get_name(fun_idx));
      }
    statement_list _RBRACKET
  ;

variable_list
  : /* empty */
  | variable_list variable
  ;

variable
  : _TYPE _ID _SEMICOLON
      {
        if(lookup_symbol($2, VAR|PAR) == NO_INDEX)
           insert_symbol($2, VAR, $1, ++var_num, NO_ATR);
        else 
           err("redefinition of '%s'", $2);
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
	|	for_stmt 
	| while_statement
	| switch_statement
	| petljaj_statement
	| basic_for
  ;
basic_for
	: _FOR _ID _ASSIGN literal 
		{
			lab_num++;
			$<i>$ = lab_num;
			int idx=lookup_symbol($2, VAR|PAR);
			if(idx==NO_INDEX)
				err("%s undeclared",$2);
			else
				if(get_type(idx)!=get_type($4))
					err("wrong types in assingment");
			code("\npocetak%d:",lab_num);
			gen_mov($4,idx);
		}_DIRECTION literal 
		{
			int idx=lookup_symbol($2, VAR|PAR);
			if(get_type($4)!=get_type($7))
				err("incompatible types in smth");

		
			code("\npetlja%d:",$<i>5);
			if($6==_TO){

				if(atoi(get_name($4))>atoi(get_name($7)))
					err("wrong direction");
				else	if(get_type($4)==INT){

					code("\n\t\tCMPS\t");
					gen_sym_name(idx);
					code(",$%d",atoi(get_name($7)));
					code("\n\t\tJGES\texit%d",$<i>5);
				}else if(get_type($4)==UINT){
					code("\n\t\tCMPU\t");
					gen_sym_name(idx);
					code(",$%d",atoi(get_name($7)));
					code("\n\t\tJGEU\texit%d",$<i>5);
				}
			}else{

				if(atoi(get_name($4))<atoi(get_name($7)))
					err("wrong direction");
				else if(get_type($4)==INT){

					code("\n\t\tCMPS\t");
					gen_sym_name(idx);
					code(",$%d",atoi(get_name($7)));
					code("\n\t\tJLES\texit%d",$<i>5);
				}else if(get_type($4)==UINT){
					code("\n\t\tCMPU\t");
					gen_sym_name(idx);
					code(",$%d",atoi(get_name($7)));
					code("\n\t\tJLEU\texit%d",$<i>5);
				}
			}
		}maybe_step statement 
		{			int idx=lookup_symbol($2, VAR|PAR);
				if($6==_TO){
				if(get_type($4)==INT){

					code("\n\t\tADDS\t");
					gen_sym_name(idx);
					code(",$%d,",$<i>9);
					gen_sym_name(idx);

				}else if(get_type($4)==UINT){
					code("\n\t\tADDU\t");
					gen_sym_name(idx);
					code(",$%d,",$<i>9);
					gen_sym_name(idx);
				}
			}else{
					if(get_type($4)==INT){

					code("\n\t\tSUBS\t");
					gen_sym_name(idx);
					code(",$%d,",$<i>9);
					gen_sym_name(idx);
				} else if(get_type($4)==UINT){
					code("\n\t\tSUBU\t");
					gen_sym_name(idx);
					code(",$%d,",$<i>9);
					gen_sym_name(idx);
				}
			}	
		}_NEXT 
		{
			code("\n\t\tJMP\tpetlja%d",$<i>5);
			code("\nexit%d:",$<i>5);
		}_SEMICOLON;
;
maybe_step
	: {$<i>$=1;}
	| _STEP literal
		{
			$<i>$=atoi(get_name($2));
		}
	;
petljaj_statement
	: _PETLJAJ _ID {
			lab_num++;
			int idx=lookup_symbol($2, VAR|PAR);
			if(idx==NO_INDEX)
				err("%s undeclared",$2);
			$<i>$=lab_num;
		}_U_OPSEGU _OD literal _DO literal {
			int idx=lookup_symbol($2, VAR|PAR);
			if(get_type(idx)!=get_type($6) || get_type(idx)!=get_type($8) || atoi(get_name($6))>atoi(get_name($8)))
				err("error in types or second smaller than first literal");
			code("\npriprema%d:",$<i>3);
			gen_mov($6,idx);
			code("\npetljaj%d:", $<i>3);
			if(get_type($6)==INT){
				code("\n\t\tCMPS\t");
				gen_sym_name(idx);
				code(",");
				gen_sym_name($8);
				code("\n\t\tJGES\texit%d",$<i>3);
			}else{

				code("\n\t\tCMPU\t");
				gen_sym_name(idx);
				code(",");
				gen_sym_name(idx);
				code("\n\t\tJGEU\texit%d",$<i>3);
			}

		}_COLON statement 
		{			int idx=lookup_symbol($2, VAR|PAR);
				if(get_type($6)==INT){
				code("\n\t\tADDS\t");
				gen_sym_name(idx);
				code(",$1,");
				gen_sym_name(idx);
			}else{

				code("\n\t\tADDU\t");
				gen_sym_name(idx);
				code(",$1,");
				gen_sym_name($8);
			}
	
			code("\n\t\tJMP\tpetljaj%d",$<i>3);
			code("\nexit%d:",$<i>3);
		}
	;

switch_statement
	: _SWITCH
	{
		switch_num++;
		code("\nswitch%d:",switch_num);
		switch_literal_num=0;
		code("\n\t\tJMP\tswitches%d",switch_num);
	} _LPAREN _ID 
	{

		int idx = lookup_symbol($4, VAR|PAR);
        if(idx == NO_INDEX)
          err("'%s' is undeclared", $4);
		switch_var=idx;

	}_RPAREN _LBRACKET cases
	{
		code("\ndefault%d:",switch_num);
	} default _RBRACKET
	{
		code("\n\t\tJMP\texit%d",switch_num);
		code("\n\t\tswitches%d:",switch_num);
		int i;
		for(i=0;i<switch_literal_num;i++){
			gen_cmp(switch_literals[i],switch_var);
			code("\n\t\tJEQ\tcase%s",get_name(switch_literals[i]));
		}	

		code("\n\t\tJMP\tdefault%d",switch_num);


		code("\nexit%d:",switch_num);
	}
	;
cases
	: case
	|	cases case
	;
case
	: _CASE literal
		{
			if(get_type($2)!=get_type(switch_var))
			  err("incompatible types in assignment");
			int i;
			for(i=0;i<switch_literal_num;i++){
				if($2==switch_literals[i])
					err("values in case not unique");		
			}
		
			switch_literals[switch_literal_num++]=$2;
			code("\ncase%s:",get_name($2));
		} _COLON statement break
	;
break
	:
	| _BREAK _SEMICOLON
		{
			code("\n\t\tJMP\texit%d",switch_num);		
		}
	;
default
	:
	| _DEFAULT _COLON statement
	;	
while_statement
	: _WHILE 
		{
			lab_num++;
			$<i>$=lab_num;
			code("\nwhile%d:",lab_num);
		}
		_LPAREN rel_exp _LBRACKET
		{
			code("\n\t\t%s\texit%d",opp_jumps[$4],$<i>2);
		}
		_RPAREN statement _ID _INC _SEMICOLON _RBRACKET
		{
			int idx = lookup_symbol($9, VAR|PAR);
        if(idx == NO_INDEX)
          err("'%s' is undeclared", $9);

			code("\n\t\t%s\t$1,",ar_instructions[(get_type(idx)-1)*AROP_NUMBER]);
			gen_sym_name(idx);
      code(",");
			gen_sym_name(idx);
      code("\n\t\tJMP\twhile%d",$<i>2);
			code("\nexit%d:",$<i>2);
		}
	;

for_stmt
	: _FOR _LPAREN _TYPE _ID
		{	
			lvl++;
			int idx = lookup_symbol($4, VAR|PAR);
        if(idx == NO_INDEX || get_atr2(idx)!=lvl)
					{
           insert_symbol($4, VAR, $3, ++var_num,lvl);
					}
		$<i>$=get_last_element();

		}_ASSIGN literal 
		{
			lab_num++;
			$<i>$=lab_num;
			int idx = lookup_symbol($4, VAR|PAR);
					if(get_type(idx) != get_type($7))
            err("incompatible types in assignment");

			code("\npriprema%d:",lab_num);
			gen_mov($7,idx);
			code("\nfor%d:",lab_num);
		}
		_SEMICOLON rel_exp _SEMICOLON _ID 
		{
			code("\n\t\t%s\texit%d",opp_jumps[$10],$<i>8);

			int idx = lookup_symbol($12, VAR|PAR);
      if(idx == NO_INDEX)
        err("'%s' is undeclared", $12);
			else		
				if(idx!=lookup_symbol($4, VAR|PAR))
					err("id1 and id2 not same id");		
			
			$<i>$=idx;
		}
			_INC	_RPAREN statement
		{

			code("\n\t\t%s\t$1,",ar_instructions[(get_type(lookup_symbol($12,VAR|PAR))-1)* AROP_NUMBER]);

			gen_sym_name($<i>13);
			code(",");
			gen_sym_name($<i>13);
			code("\n\t\tJMP\tfor%d",$<i>8);
			code("\nexit%d:",$<i>8);
				lvl--;

				clear_symbols($<i>5+1);

		}
	;
compound_statement
  : _LBRACKET statement_list _RBRACKET
  ;

assignment_statement
  : _ID _ASSIGN num_exp _SEMICOLON
      {
        int idx = lookup_symbol($1, VAR|PAR);
        if(idx == NO_INDEX)
          err("invalid lvalue '%s' in assignment", $1);
        else
          if(get_type(idx) != get_type($3))
            err("incompatible types in assignment");
        gen_mov($3, idx);
      }
  ;

num_exp
  : exp

  | num_exp _AROP exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: arithmetic operation");
        int t1 = get_type($1);    
        code("\n\t\t%s\t", ar_instructions[$2 + (t1 - 1) * AROP_NUMBER]);
        gen_sym_name($1);
        code(",");
        gen_sym_name($3);
        code(",");
        free_if_reg($3);
        free_if_reg($1);
        $$ = take_reg();
        gen_sym_name($$);
        set_type($$, t1);
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

  | function_call
      {
        $$ = take_reg();
        gen_mov(FUN_REG, $$);
      }
  
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
          err("wrong number of arguments");
        code("\n\t\t\tCALL\t%s", get_name(fcall_idx));
        if($4 > 0)
          code("\n\t\t\tADDS\t%%15,$%d,%%15", $4 * 4);
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
        err("incompatible type for argument");
      free_if_reg($1);
      code("\n\t\t\tPUSH\t");
      gen_sym_name($1);
      $$ = 1;
    }
  ;

if_statement
  : if_part %prec ONLY_IF
      { code("\n@exit%d:", $1); }

  | if_part _ELSE statement
      { code("\n@exit%d:", $1); }
  ;

if_part
  : _IF _LPAREN
      {
        $<i>$ = ++lab_num;
        code("\n@if%d:", lab_num);
      }
    rel_exp
      {
        code("\n\t\t%s\t@false%d", opp_jumps[$4], $<i>3);
        code("\n@true%d:", $<i>3);
      }
    _RPAREN statement
      {
        code("\n\t\tJMP \t@exit%d", $<i>3);
        code("\n@false%d:", $<i>3);
        $$ = $<i>3;
      }
  ;

rel_exp
  : num_exp _RELOP num_exp
      {
        if(get_type($1) != get_type($3))
          err("invalid operands: relational operator");
        $$ = $2 + ((get_type($1) - 1) * RELOP_NUMBER);
        gen_cmp($1, $3);
      }
  ;

return_statement
  : _RETURN num_exp _SEMICOLON
      {
        if(get_type(fun_idx) != get_type($2))
          err("incompatible types in return");
        gen_mov($2, FUN_REG);
        code("\n\t\tJMP \t@%s_exit", get_name(fun_idx));        
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
  output = fopen("output.asm", "w+");

  synerr = yyparse();

  clear_symtab();
  fclose(output);
  
  if(warning_count)
    printf("\n%d warning(s).\n", warning_count);

  if(error_count) {
    remove("output.asm");
    printf("\n%d error(s).\n", error_count);
  }

  if(synerr)
    return -1;  //syntax error
  else if(error_count)
    return error_count & 127; //semantic errors
  else if(warning_count)
    return (warning_count & 127) + 127; //warnings
  else
    return 0; //OK
}

