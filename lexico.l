%option noyywrap
%option noyywrap
	int chars = 0;
	int lines = 1;
	int commType = 0;
	int slash = 0;
	int column = 0;
%{
extern "C"
    {
        int yylex(void);
    }
#include <ast.h>
#include <sintatico.tab.h>

void get_column()
{
	int i;

	for (i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;
}


%}
%%

"/*"	 {commType = 1; chars += strlen(yytext);}
"*/"	 {commType = 0;chars += strlen(yytext);}
"//"	 {commType = 1;slash = 1;}chars += strlen(yytext); 
"void"	 {chars += strlen(yytext);if(commType == 0)return VOID;}
"int"	 {chars += strlen(yytext);if(commType == 0)return INT;}
"char"	 {chars += strlen(yytext);if(commType == 0)return CHAR;}
"return" {chars += strlen(yytext);if(commType == 0)return RETURN;}
"do"     {chars += strlen(yytext);if(commType == 0)return DO;}
"while"  {chars += strlen(yytext);if(commType == 0)return WHILE;}
"for"    {chars += strlen(yytext);if(commType == 0)return FOR;}
"if"     {chars += strlen(yytext);if(commType == 0)return IF;}
"else"   {chars += strlen(yytext);if(commType == 0)return ELSE;}
"printf" {chars += strlen(yytext);if(commType == 0)return PRINTF;}
"scanf"	 {chars += strlen(yytext);if(commType == 0)return SCANF;}
"define" {chars += strlen(yytext);if(commType == 0)return DEFINE; }
"exit"	 {chars += strlen(yytext);if(commType == 0)return EXIT;}
0(X|x){1}[0-9A-Fa-f]+ 		{chars += strlen(yytext);yylval.integer = (int)strtol(yytext, NULL, 0); if(commType == 0) return NUM_HEXA;}
0[1-7][0-7]* {chars += strlen(yytext);yylval.integer = (int)strtol(yytext, NULL, 8);if(commType == 0)return NUM_OCTAL;}
[0-9]+ 		{chars += strlen(yytext);yylval.integer = atoi(yytext);if(commType == 0) return NUM_INTEGER;}
\'([^\']|\\.)?\'	{chars += strlen(yytext); yylval.str = strdup(yytext); if(commType == 0) return CHARACTER;}
\"(\\.|\"\"|[^"\n])*\" {chars += strlen(yytext);if(commType == 0)return STRING;}
[a-zA-Z_][a-zA-Z0-9_]* 	{chars += strlen(yytext); yylval.str = yytext; if(commType == 0)return IDENTIFIER;  }
"+"		{
			chars += strlen(yytext);
			if(commType == 0){
				return PLUS;
			}
		}
"-"		{
			chars += strlen(yytext);
			if(commType == 0){
				return MINUS;
			}
		}
"*"		{chars += strlen(yytext);if(commType == 0)return MULTIPLY;}
"%"		{chars += strlen(yytext);if(commType == 0)return REMAINDER;}
"++"	{chars += strlen(yytext);if(commType == 0)return INC;}
"--"	{chars += strlen(yytext);if(commType == 0)return DEC;}
"&"		{chars += strlen(yytext);if(commType == 0)return BITWISE_AND;}
"|"		{chars += strlen(yytext);if(commType == 0)return BITWISE_OR;}
"~"		{chars += strlen(yytext);if(commType == 0)return BITWISE_NOT;}
"^"		{chars += strlen(yytext);if(commType == 0)return BITWISE_XOR;}
"!"		{chars += strlen(yytext);if(commType == 0)return NOT;}
"=="	{chars += strlen(yytext);if(commType == 0)return EQUAL;}
"!="	{chars += strlen(yytext);if(commType == 0)return NOT_EQUAL;}
"&&"	{chars += strlen(yytext);if(commType == 0)return LOGICAL_AND;}
"||"	{chars += strlen(yytext);if(commType == 0)return LOGICAL_OR;}
"<"		{chars += strlen(yytext);if(commType == 0)return LESS_THAN;}
">"		{chars += strlen(yytext);if(commType == 0)return GREATER_THAN;}
"<="	{chars += strlen(yytext);if(commType == 0)return LESS_EQUAL;}
">="	{chars += strlen(yytext);if(commType == 0)return GREATER_EQUAL;}
">>"	{chars += strlen(yytext);if(commType == 0)return R_SHIFT;}
"<<"	{chars += strlen(yytext);if(commType == 0)return L_SHIFT;}
"="     {chars += strlen(yytext);if(commType == 0)return ASSIGN;}
"+="	{chars += strlen(yytext);if(commType == 0)return ADD_ASSIGN;}
"-="	{chars += strlen(yytext);if(commType == 0)return MINUS_ASSIGN;}
";"		{chars += strlen(yytext);if(commType == 0)return SEMICOLON;}
"," 	{chars += strlen(yytext);if(commType == 0)return COMMA;}
":"		{chars += strlen(yytext);if(commType == 0)return COLON;}
"("     {chars += strlen(yytext);if(commType == 0)return L_PARENT;}
")"	    {chars += strlen(yytext);if(commType == 0)return R_PARENT;}
"{"		{chars += strlen(yytext);if(commType == 0)return L_CURLY_BRACKET;}
"}"		{chars += strlen(yytext);if(commType == 0)return R_BRACE_BRACKET;}
"?"		{chars += strlen(yytext);if(commType == 0)return TERNARY_CONDITIONAL;}
"#"     {chars += strlen(yytext);if(commType == 0)return NUMBER_SIGN; }

\n								{
									chars = 0;
									++lines;
									if((commType == 1) && (slash == 1)){
										commType = 0; 
										slash = 0;
									}
								}
\r								{++chars; ++lines;}
\t								{++chars;}
" "								{++chars;}
.								{++chars; printf("ERRO: LINHA: %d COLUNA %d\n",lines,chars);}

%%


