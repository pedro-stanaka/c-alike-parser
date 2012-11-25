%{
	#include <stdio.h>
	#include <ast.h>
	#include <sintatico.tab.h>
	#define YYERROR_VERBOSE 1
	
	extern "C"{
		extern int yyerror(const char *s);
		extern int yylex();
	}
	Node* AST = NULL;

	void RPN_Walk(Node* aux)
	{
		aux->RPN();
	}

%}

%union{
	Node* ast;
	int integer;
	char* str;
}

/* declare tokens */
%token VOID INT CHAR RETURN DO WHILE FOR
%token IF ELSE
%token PRINTF SCANF DEFINE EXIT
%token NUM_HEXA NUM_OCTAL NUM_INTEGER CHARACTER
%token STRING IDENTIFIER
%token PLUS MINUS MULTIPLY REMAINDER INC DEC
%token BITWISE_AND BITWISE_OR BITWISE_NOT BITWISE_XOR
%token NOT EQUAL NOT_EQUAL 
%token LOGICAL_AND LOGICAL_OR
%token LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%token R_SHIFT L_SHIFT
%token ASSIGN ADD_ASSIGN MINUS_ASSIGN
%token SEMICOLON COMMA COLON
%token L_PARENT R_PARENT
%token L_CURLY_BRACKET R_BRACE_BRACKET
%token TERNARY_CONDITIONAL
%token NUMBER_SIGN

%type <ast> ssym
%type <ast> program
%type <ast> declarations
%type <ast> type
%type <ast> number
%type <ast> identifier
%type <ast> incdec
%type <ast> unary_exp
%type <ast> multiplicative_expression
%type <ast> C
%type <ast> D
%type <ast> E //
%type <ast> expressao_aditiva
%type <ast> G
%type <ast> H
%type <ast> I
%type <ast> J
%type <ast> expressao_shift
%type <ast> K
%type <ast> L
%type <ast> expressao_relacional
%type <ast> F //
%type <ast> M
%type <ast> N
%type <ast> O
%type <ast> P
%type <ast> Q
%type <ast> R
%type <ast> expressao_de_igualdade
%type <ast> S
%type <ast> T
%type <ast> U
%type <ast> V
%type <ast> X
%type <ast> Y
%type <ast> W
%type <ast> Z
%type <ast> X1
%type <ast> Y1
%type <ast> W1
%type <ast> Z1
%type <ast> expressao_xor
%type <ast> expressao_or
%type <ast> expressao_and_logico
%type <ast> expressao_and
%type <ast> X2
%type <ast> Y2
%type <ast> W2
%type <ast> Z2
%type <ast> X3
%type <ast> Y3
%type <ast> W3
%type <ast> Z3
%type <ast> expressao_or_logico
%type <ast> X4
%type <ast> Y4
%type <ast> W4
%type <ast> Z4
%type <ast> A1
%type <ast> expressao_condicional
%type <ast> X5
%type <ast> Y5
%type <ast> W5
%type <ast> expressao
%type <ast> A //
%type <ast> A6
%type <ast> A9
%type <ast> A10
%type <ast> A11
%type <ast> A12
%type <ast> D2
%type <ast> lista_de_comandos
%type <ast> D3
%type <ast> comandos
%type <ast> bloco
%type <ast> string
%type <ast> D7
%type <ast> D8
%type <ast> C1
%type <ast> C2
%type <ast> F1
%type <ast> F2
%type <ast> parametros
%type <ast> G1
%type <ast> G2
%type <ast> declaracao_de_prototipos
%type <ast> H1
%type <ast> H2
%type <ast> H3
%type <ast> declaracao_de_variaveis
%type <ast> function
%type <ast> I1
%type <ast> I2
%type <ast> K1

%start ssym


%%


ssym : program {
		if(AST){
			RPN_Walk(AST);
		}else{
			std::cout << "There's no tree to walk here pal!\n\n";
		}
	}
;

program	: declarations K1 {
		 Program* aux = new Program();
		 aux->a = $1;
		 aux->b= NULL;
		 $$ = aux;
}
		| function K1 {
			Program * prg = new Program();
			prg->a = $1;
			prg->b = NULL;
			$$ = prg;
		}
;

K1	: program {
		$$ = $1;
	}
	| /*lambda*/ {}
;

declarations	: NUMBER_SIGN DEFINE identifier expressao {
						Declaration * aux = new Declaration();
						aux->a = $3;
						aux->b = $4;
						$$ = aux;
				}
	| declaracao_de_variaveis {
			$$ = $1;
	}
	| declaracao_de_prototipos {
		 $$ = $1;
	}
;

function	: type identifier parametros L_CURLY_BRACKET I1 {
			Function * aux = new Function();
			aux->a = $1;
			aux->b = $2;
			aux->c = $3;
			aux->d = $5;
			$$ = aux;
		}
;

I1	: comandos R_BRACE_BRACKET {
		I1 *aux = new I1();
		aux->a = $1;
		aux->b = NULL;
		$$ = aux;
	}
	| I2 {
		$$ = $1;
	}
;

I2	: declaracao_de_variaveis I1 {
			I2* aux = new I2();
			aux->a = $1;
			aux->b = $2;
			$$ = aux;
		}
;
declaracao_de_variaveis	: type H1 {
	VariableDeclaration * aux = new VariableDeclaration();
	aux->a = $1;
	aux->b = $2;
	$$ = aux;
}
;

declaracao_de_prototipos: type identifier parametros SEMICOLON {
	PrototypeDeclaration * aux = new PrototypeDeclaration();
	aux->a = $1;
	aux->b = $2;
	aux->c = $3;
	$$ = aux;
}
;

H1	: identifier H3 {
			H1 * aux = new H1();
			aux->a = $1;
			aux->b = $2;
			$$ = aux;
		}
	| H2 {
		$$ = $1;
	}
;

H2	: identifier ASSIGN expressao H3 {

}
;

H3	: COMMA H1 {}
	| SEMICOLON {}
;
parametros	: L_PARENT G1 {}
;

G1	: type identifier G2 {}
	| R_PARENT {}
;

G2:	 COMMA type identifier G2 {}
	| R_PARENT {}
;

bloco	: L_CURLY_BRACKET comandos R_BRACE_BRACKET {}
;

comandos	: lista_de_comandos {}
		| D3 {}
;

D3	: lista_de_comandos comandos {}
 
lista_de_comandos: expressao SEMICOLON {}
	| DO bloco WHILE L_PARENT expressao R_PARENT SEMICOLON {}
	| IF L_PARENT expressao R_PARENT D7 {}
	| WHILE L_PARENT expressao R_PARENT bloco {}
	| FOR L_PARENT F1 F1 F2 bloco {}
	| PRINTF L_PARENT string C1 {}
	| SEMICOLON {}
	| SCANF L_PARENT string COMMA BITWISE_AND identifier R_PARENT SEMICOLON {}
	| EXIT L_PARENT expressao R_PARENT SEMICOLON {}
	| RETURN D2 {}
	| bloco {}
;

F1	: expressao SEMICOLON {}
	| SEMICOLON {}
;

F2	: R_PARENT {}
	| expressao R_PARENT {}
;

C1	: R_PARENT SEMICOLON {}
	| C2  {}
;

C2	: COMMA expressao C1 {}
;

D7	: bloco {}
	| D8 {}
;

D8	: bloco ELSE bloco {}
;

D2: SEMICOLON {}
	| L_PARENT expressao R_PARENT SEMICOLON {}
;

expressao: expressao_condicional {}
		| X5 {}
;

X5	: expressao_condicional Y5 {}
;

Y5	: ASSIGN W5 {}
	| ADD_ASSIGN W5 {}
	| MINUS_ASSIGN W5 {}
;

W5	: expressao_condicional {}
	| Z5 {}
;

Z5	: expressao_condicional Y5 {}
;

expressao_condicional: expressao_or_logico {}
	| A1 {}
;

A1	: expressao_or_logico TERNARY_CONDITIONAL expressao_or_logico COLON expressao_or_logico {}
;

expressao_and_logico: expressao_or {}
		| X3 {}
;

X3	: expressao_or Y3 {
	X3 * aux = new X3();
	aux->a = $1;
	aux->b = $2;
	$$ = aux;	
}
;

Y3	: LOGICAL_AND W3 {
	Leaf * aux = new Leaf();
	aux->symbol = "LOGICAL_AND";
	aux->value = 0;
	Y3 * aux2 = new Y3();
	aux2->a = aux;
	aux2->b = $2;
	$$ = aux2;
}
;

W3	: expressao_or {$$=$1;}
	| Z3 {$$=$1;}
;
	
Z3	: expressao_or Y3 {
	Z3 * aux = new Z3();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;	
}
;

expressao_or_logico: expressao_and_logico {
			$$ = $1;
		}
		| X4 {
			$$ = $1;
		}
;

X4	: expressao_and_logico Y4 {
		X4 * aux = new X4();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;	
}
;

Y4	: LOGICAL_OR W4 {
		Leaf * aux = new Leaf();
		aux->symbol = "LOGICAL_OR";
		aux->value = 0;
		Y4 * aux2 = new Y4();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

W4	: expressao_and_logico {$$ = $1;}
	| Z4 {
		$$ = $1;
	}
;

Z4	: expressao_and_logico Y4 {
		Z4 * aux = new Z4();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

expressao_or: expressao_xor {$$=$1;}
		| X2 {
			$$=$1;
		}
;

X2	: expressao_xor Y2 {
		X2 * aux = new X2();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

Y2	: BITWISE_OR W2 {
	Leaf * aux = new Leaf();
	aux->symbol = "BITWISE_OR";
	aux->value = 0;
	Y2 * aux2 = new Y2();
	aux2->a = aux;
	aux2->b = $2;
	$$ = aux2;
}
;

W2	: expressao_xor {$$ = $1;}
	| Z2 {$$ = $1;}
;

Z2	: expressao_xor Y2 {
	Z2 * aux = new Z2();
	aux->a = $1;
	aux->b = $2;
	$$ = aux;
}
;


expressao_xor: expressao_and {$$ = $1;}
		| X1 {$$ = $1;}
;

X1	: expressao_and Y1 {
		X1 * aux = new X1();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

Y1	: BITWISE_XOR W1 {
		Leaf * aux = new Leaf();
		aux->symbol = "BITWISE_XOR";
		aux->value = 0;
		Y1 * aux2 = new Y1();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

W1	: expressao_and {$$ = $1;}
	| Z1 {$$ = $1;}
;

Z1	: expressao_and Y1 {
		Z1 * aux = new Z1();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

expressao_and: expressao_de_igualdade {
			$$ = $1;
		}
		| X {
			$$ = $1;
		}
;

X	: expressao_de_igualdade Y {
		X * aux = new X();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

Y	: BITWISE_AND W {
		Leaf * aux = new Leaf();
		aux->symbol = "BITWISE_AND";
		aux->value = 0;
		Y * aux2 = new Y();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

W	: expressao_de_igualdade {$$ = $1;}
	| Z {$$ = $1;}
;

Z	: expressao_de_igualdade Y {
		Z * aux = new Z();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;




expressao_de_igualdade: expressao_relacional {
			$$ = $1;
		}
		| S {
			$$ = $1;
		}
;

S	: expressao_relacional T {
		S * aux = new S();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

T	: EQUAL U {
		Leaf * aux = new Leaf();
		aux->symbol = "EQUAL";
		aux->value = 0;
		T * aux2 = new T();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;

	}
	| NOT_EQUAL U {
		Leaf * aux = new Leaf();
		aux->symbol = "NOT_EQUAL";
		aux->value = 0;
		T * aux2 = new T();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

U	: expressao_relacional {
		$$ = $1;
	}
	| V {
		$$ = $1;
	}
;

V	: expressao_relacional T {
	V * aux = new V();
	aux->a = $1;
	aux->b = $2;
	$$ = aux;
}
;

expressao_relacional: expressao_shift {
			$$ = $1;
		}
		| O {
			$$ = $1;
		}
;

O	: expressao_shift P {
		O * aux = new O();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}	
;

P	: LESS_THAN Q {}
	| GREATER_THAN Q {
		Leaf * aux = new Leaf();
		aux->symbol = "LESS_THAN";
		aux->value = 0;
		P * aux2 = new P();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
	| LESS_EQUAL Q {
		Leaf * aux = new Leaf();
		aux->symbol = "LESS_EQUAL";
		aux->value = 0;
		P * aux2 = new P();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
	| GREATER_EQUAL Q {
		Leaf * aux = new Leaf();
		aux->symbol = "GREATER_EQUAL";
		aux->value = 0;
		P * aux2 = new P();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

Q	: expressao_shift {
		$$ = $1;
	}
	| R {
		$$ = $1;
	}
;

R	: expressao_shift P {
		R * aux = new R();
		aux->a = $1;
		aux->b = $2;
	}
;

expressao_shift	: expressao_aditiva {
			$$ = $1;
		}
		| K {
			$$ = $1;
		}
;

K: expressao_aditiva L {
		K * aux = new K();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

L	: R_SHIFT M {
		Leaf * aux = new Leaf();
		aux->symbol = "R_SHIFT";
		aux->value = 0;
		L * aux2 = new L();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
	| L_SHIFT M {
		Leaf * aux = new Leaf();
		aux->symbol = "L_SHIFT";
		aux->value = 0;
		L * aux2 = new L();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

M	: expressao_aditiva {
		$$ = $1;
	}
	| N {
		$$ = $1;
	}
;
//STOP POINT - RECOVER FROM HERE -
N	: expressao_aditiva L {
		N * aux = new N();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

expressao_aditiva	: multiplicative_expression {
				$$ = $1;
			}
			| G {
				$$ = $1;
			}
;

G	: multiplicative_expression H {
		G * aux = new G();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;

H	: MINUS I {
	Leaf * aux = new Leaf();
		aux->symbol = "MINUS";
		aux->value = 0;
		H * aux2 = new H();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
	| PLUS I {
		Leaf * aux = new Leaf();
		aux->symbol = "PLUS";
		aux->value = 0;
		H * aux2 = new H();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

I	: multiplicative_expression {
		$$ = $1;
	}
	| J {
		$$ = $1;
	}
;

J	: multiplicative_expression H {
		J * aux = new J();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;
 
multiplicative_expression	: unary_exp {
		$$ = $1;
	}
	| C {
		$$ = $1;
	}
;

C	: unary_exp D {
		C * aux = new C();
		aux->a = $1;
		aux->b = $2;
		$$ = aux;
	}
;
	
D	: MULTIPLY E {
		Leaf * aux = new Leaf();
		aux->symbol = "MULTIPLY";
		aux->value = 0;
		D * aux2 = new D();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
	| REMAINDER E {
		Leaf * aux = new Leaf();
		aux->symbol = "REMAINDER";
		aux->value = 0;
		D * aux2 = new D();
		aux2->a = aux;
		aux2->b = $2;
		$$ = aux2;
	}
;

E	: unary_exp {
		$$ = $1;	
	}
	| F { $$ = $1;
	}
;

F	: unary_exp D {
	F * aux = new F();
	aux->a = $1;
	aux->b = $2;
	$$ = aux;
}
;

unary_exp: identifier {
			$$ = $1;
		}
		| A {
			$$ = $1;
		}
		| number {
			$$ = $1;
		}
		| CHARACTER {
			Leaf * aux = new Leaf();
			aux->symbol = "CHARACTER";
			aux->value = 0;
			$$ = aux;
		}
		| L_PARENT expressao R_PARENT {
			$$ = $2;
		}
		| NOT unary_exp {
			UnaryExpression * aux = new UnaryExpression();
			Leaf * leaf = new Leaf();
			leaf->symbol = "NOT";
			leaf->value = 0;
			aux->a = leaf;
			aux->b = $2;
			$$ = aux;
		}
		| BITWISE_NOT unary_exp {
			UnaryExpression * aux = new UnaryExpression();
			Leaf * leaf = new Leaf();
			leaf->symbol = "BITWISE_NOT";
			leaf->value = 0;
			aux->a = leaf;
			aux->b = $2;
			$$ = aux;
		}
		| MINUS unary_exp {
			UnaryExpression * aux = new UnaryExpression();
			Leaf * leaf = new Leaf();
			leaf->symbol = "MINUS";
			leaf->value = 0;
			aux->a = leaf;
			aux->b = $2;
			$$ = aux;
		}
		| PLUS unary_exp {
			UnaryExpression * aux = new UnaryExpression();
			Leaf * leaf = new Leaf();
			leaf->symbol = "PLUS";
			leaf->value = 0;
			aux->a = leaf;
			aux->b = $2;
			$$ = aux;
		}
		
;

A	: identifier A6 {
		Identifier * aux = new Identifier();
		aux->a = $2;
		$$ = aux;
	}
;

A6	: incdec {
		$$ = $1;
	}
	| A11 {
		$$ = $1;
	}
;

A9	: expressao {
		$$ = $1;
	}
	| A10 {
		$$ = $1;
	}
;

A10	: expressao COMMA A9 {
		Expression *aux = new Expression();
		aux->a = $3;
		$$ = aux;
	}
;

A11	: L_PARENT R_PARENT {
		$$ = NULL;
	}
	| A12 {
		$$ = $1;
	}
;


A12: L_PARENT A9 R_PARENT {
	A12 * aux = new A12();
	aux->a = $2;
	$$ = aux;
}
;

incdec	: INC {
		Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "INC";
    	$$ = aux;
}
	| DEC {
		Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "DEC";
    	$$ = aux;
	}
;

identifier: IDENTIFIER{ 
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "IDENTIFIER";
    	$$ = aux;
    }
;

string: STRING {
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "STRING";
    	$$ = aux;
}
;

 number : NUM_HEXA{ 
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->value = NUM_HEXA;
    	$$ = aux;
    }
    
    | NUM_OCTAL {
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->value = NUM_OCTAL;
    	$$ = aux;          
    }

    | NUM_INTEGER {
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->value = NUM_INTEGER;
    	$$ = aux;          
    }
    
;

type: INT{ 
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "INT";
    	$$ = aux;
    }
    
    | CHAR {
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "CHAR";
    	$$ = aux;          
    }

    | VOID {
        Leaf* aux = new Leaf();
    	aux->a = NULL;
    	aux->b = NULL;
    	aux->symbol = "VOID";
    	$$ = aux;          
    }
;

%%

int yyerror( const char *s)
{
	fprintf(stderr, "Error while parsing: %s\n", s);
}

int main(int argc, char **argv)
{
	yyparse();
}

