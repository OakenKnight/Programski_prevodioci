%option noyywrap yylineno
%{
  #include <string.h>
  #include "syntax.tab.h"
  #include "defs.h"
%}

%%

[ \t\n]+             { /* skip */ }

"int"                { return _TYPE; }
"unsigned"           { return _TYPE; }
"if"                 { return _IF; }
"else"               { return _ELSE; }
"return"             { return _RETURN; }
"do"								{return _DO;}
"while" 						{return _WHILE;}
"next" 							{return _NEXT;}
"step" 							{return _STEP;}
"to" 								{return _DIR;}
"downto" 								{return _DIR;}
"for"									{return _FOR;}
"("                  { return _LPAREN; }
")"                  { return _RPAREN; }
"{"                  { return _LBRACKET; }
"}"                  { return _RBRACKET; }
";"                  { return _SEMICOLON; }
","                  { return _COMA; }
"="                  { return _ASSIGN; }
"++"									{return _INC;}
"+"                  { return _AROP; }
"-"                  { return _AROP; }
"&&"								{return _LOGOP;}
"||"								{return _LOGOP;}

"<"                  { return _RELOP; }
">"                  { return _RELOP; }
"<="                 { return _RELOP; }
">="                 { return _RELOP; }
"=="                 { return _RELOP; }
"!="                 { return _RELOP; }

[a-zA-Z][a-zA-Z0-9]* { return _ID; }
[+-]?[0-9]{1,10}     { return _INT_NUMBER;}
[0-9]{1,10}[uU]      { return _UINT_NUMBER;}

\/\/.*               { /* skip */ }
.                    { printf("line %d: LEXICAL ERROR on char %c\n", 
                              yylineno, *yytext);}
%%
