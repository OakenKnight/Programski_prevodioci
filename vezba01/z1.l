%option noyywrap

%%
[+-]?[0-9]+F {printf("%dC",(atoi(yytext)-32)*5/9);}

%%

int main() {
  yylex();
}



/*

1.
a) [+-]?[0-9]+              { printf("broj: %s\n", yytext); }
b) [0][xX][0-9A-Fa-f]{1,4}        { printf("HexaBroj: %s\n", yytext); }
b) [+-]?[0-9]+\.[0-9]+[eE]?[+-][0-9]{1,3} { printf("decimalan: %s\n", yytext); } 
d) [bB][rR][eE][aA][kK] {printf("ispis: %s\n",yytext); }

2.


\/\/.* 

"/*" {
	char c;
	for(;;){
		while ((c=input()) != '*' && c!=EOF)
			;  //preskoci tekst komentara
		if (c=='*'){
			while((c=input())=='*')
				;		
				if(c=='/')
				break; //kraj komentara
		}
		if (c==EOF){
			perror("EOF in comment");
		break;
		}
	}
}

*/
