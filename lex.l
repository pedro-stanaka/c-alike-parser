%option noyywrap
%{
#include <node.h>
#include  "parser.tab.h"
        int i = 0;
        int column = 1;
        int lines = 1;
%}

%%
[\n] { 
		lines++; 
		column = 1; 
	 } 

"void"  { 
			column += strlen(yytext); 
			return VOID  ;
		}
"int"   { 
			column += strlen(yytext); 
			return INT;
		}
"char"  { 
			column += strlen(yytext); 
			return CHAR;
		}
"return" { 
			column += strlen(yytext); 
			return RETURN ;
		}

"break" { 
			column += strlen(yytext); 
			return BREAK  ;
		}

"switch" { 
			column += strlen(yytext); 
			return SWITCH;
		}

"case"  {
			column += strlen(yytext); 
			return CASE;
		}

"default" { 
			column += strlen(yytext); 
			return DEFAUL ;
		}

"do"    { 
			column += strlen(yytext); 
			return DO ;
		}

"while" { 
			column += strlen(yytext); 
			return WHILE;
		}

"for"   { 
			column += strlen(yytext); 
			return FOR;
		}

"if"    { 
			column += strlen(yytext); 
			return IF;
		}
"else"  { 
			column += strlen(yytext); 
			return ELSE;
		}
"printf" { 
			column += strlen(yytext); 
			return PRINTF;
		}

"scanf" { 
			column += strlen(yytext); 
			return SCANF;
		}

"define" { 
			column += strlen(yytext); 
			return DEFINE ;
		}

"exit"  { 
			column += strlen(yytext); 
			return EXIT;
		}

  /* Block comment */
[/][*]([^*]|[*]+[^/])*[*]+[/] {

		i=0; 
		while(i<strlen(yytext)){
		if (yytext[i]=='\n'){ 
			lines++; 
			column=0; 
		};
		column++; 
		i++;
		}
	}
	
[/][/].*    /* Line comment */

  /*tabulation and whitespace*/
[ \t]   { 
				column += strlen(yytext); 
		} 

0(X|x){1}[0-9A-Fa-f]+    { 
							column += strlen(yytext) ; 
							yylval.integer = (int)strtol(yytext, NULL, 0);
							return NUM_HEXA;
						 }
0[1-7][0-7]*             { 
							column += strlen(yytext) ; 
							yylval.integer = (int)strtol(yytext, NULL, 8);
							return NUM_OCTAL;
						 }
[0-9]+                   { 
							column += strlen(yytext) ; 
							yylval.integer = (int)strtol(yytext, NULL, 10);
							return NUM_INTEGER ;
						 }

\'([^\']|\\.)?\'         { 
							column += strlen(yytext) ; 
							return CHAR;
						 }
\"(\\.|\"\"|[^"\n])*\"   { 
							column += strlen(yytext) ; 
							return STRING ;
						 }

[a-zA-Z_][a-zA-Z0-9_]*   {  
							column += strlen(yytext) ; 
							return IDENTIFIER ;
						 }

"+"  { 
		column += strlen(yytext); 
		return PLUS;
	}

"-"  { 
		column += strlen(yytext); 
		return MINUS;
	}

"*"  { 
		column += strlen(yytext); 
		return MULTIPLY;
	}

"%"  { 
		column += strlen(yytext); 
		return REMAINDER;
	}

"++" { 	column += strlen(yytext); 
		return INC;
	 }

"--" { 
		column += strlen(yytext); 
		return DEC;                 
	 }

"&"  { 
		column += strlen(yytext); 
		return BITWISE_AND;
	 }

"|"  { 
		column += strlen(yytext); 
		return BITWISE_OR ;
	}

"~"  { 
		column += strlen(yytext); 
		return BITWISE_NOT;
	 }

"^"  { 
		column += strlen(yytext); 
		return BITWISE_XOR;
	 }

"!"  { 
		column += strlen(yytext); 
		return NOT;
	 }

"&&" { 
		column += strlen(yytext); 
		return LOGICAL_AND;
	}

"||" {
		column += strlen(yytext); 
		return LOGICAL_OR;
	}

"==" { 
		column += strlen(yytext); 
		return EQUAL;
	}

"!=" { 
		column += strlen(yytext); 
		return NOT_EQUAL;
	}

"<"  { 
		column += strlen(yytext); 
		return LESS_THAN;
	}

">"  { 	column += strlen(yytext); 
		return GREATER_THAN;
	}

"<=" { 
		column += strlen(yytext); 
		return LESS_EQUAL;
	 }

">=" { 
		column += strlen(yytext); 
		return GREATER_EQUAL;
	 }

">>" { 
		column += strlen(yytext); 
		return R_SHIFT;             
	}

"<<" { 
		column += strlen(yytext); 
		return L_SHIFT;             
	}

"="  { 
		column += strlen(yytext); 
		return ASSIGN;
	}

"+=" { 
		column += strlen(yytext); 
		return ADD_ASSIGN;
	}

"-=" { 
		column += strlen(yytext); 
		return MINUS_ASSIGN;
}
","  { 
		column += strlen(yytext); 
		return COMMA;
	}

":"  {
		column += strlen(yytext); 
		return COLON               ;}
"("  { 
		column += strlen(yytext); 
		return L_PAREN;
	}
")"  { 
		column += strlen(yytext); 
		return R_PAREN;
	}
"{"  { 
		column += strlen(yytext); 
		return L_CURLY_BRACKET     ;
	 }
"}"  { 
		column += strlen(yytext); 
		return R_BRACE_BRACKET;
	 }
"?"  { 
		column += strlen(yytext); 
		return TERNARY_CONDITIONAL ;
	}
"#" { 
		column += strlen(yytext); 
		return NUMBER_SIGN;
	}
";" { 
		column += strlen(yytext); 
		return SEMICOLON;
	}

  /* Mistery char */
.  { 
		printf("Lexical error at LINE: %d, COLUMN: %d\n",lines, column);
	}
%%