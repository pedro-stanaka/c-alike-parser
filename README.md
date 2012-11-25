Para compilar:

    make


Depois:

   Vá no código gerado 'sintatico.tab.c'
	Altere a linha #3000 que é assim: char const *yymsgp = YY_("syntax error");
	Para:                             char *yymsgp = YY_("syntax error");


E então use: make build
