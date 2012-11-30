%{

#include <stdio.h>
#include "ast.h"
#include "hashTable.h"
#include <parser.tab.h>

#define YYERROR_VERBOSE 1

extern "C"{
        extern int yyerror(const char *s);
        extern int yylex();
    }


GenericNode* AST = NULL;
HashTable * symTable = NULL;
HashTable * localScope = NULL;


int count = 0;


void treeWalk(GenericNode* aux)
{
        if(aux != NULL){
                treeWalk(aux->a);
                treeWalk(aux->b);
                treeWalk(aux->c);
                treeWalk(aux->d);
                printf("  type=%d -  ", aux->node_type);
                if(aux->node_type == NUM_INTEGER || aux->node_type == NUM_HEXA ||
                    aux->node_type == NUM_OCTAL ){
                    printf("  VALUE=> %d  ", aux->value);
                }
                if(aux->node_type == IF ){
		              printf("IF");
                }
        }
}
%}

%code requires  {   
                    class GenericNode;
                    class HashTable;
                }

%union{
        GenericNode* ast;
        int integer;
        char * symId;
        char * symTp;
}

%token VOID INT CHAR
%token RETURN BREAK
%token SWITCH CASE DEFAUL  DO WHILE FOR
%token IF ELSE
%token PRINTF SCANF
%token DEFINE EXIT
%token PLUS MINUS MULTIPLY REMAINDER INC DEC
%token BITWISE_AND BITWISE_OR BITWISE_NOT BITWISE_XOR NOT LOGICAL_AND LOGICAL_OR EQUAL NOT_EQUAL LESS_THAN GREATER_THAN LESS_EQUAL GREATER_EQUAL
%token R_SHIFT L_SHIFT
%token ASSIGN ADD_ASSIGN MINUS_ASSIGN
%token COMMA COLON
%token L_PAREN R_PAREN L_CURLY_BRACKET R_BRACE_BRACKET
%token TERNARY_CONDITIONAL NUMBER_SIGN
%token SEMICOLON
%token NUM_HEXA NUM_OCTAL NUM_INTEGER
%token CHARACTER STRING IDENTIFIER

%type <ast> program declaration 
%type <symId> IDENTIFIER
%type <ast> function function_pre
%type <ast> variable_declaration variable_declaration_pre variable_declaration_post
%type <ast> prototype_declaration
%type <ast> params params_post
%type <ast> type
%type <ast> commands block command_list
%type <ast> for_post for_pre
%type <ast> else_pre
%type <ast> printf_pre
%type <ast> expression expression_post
%type <ast> conditional_expression 
%type <ast> logical_or_exp logical_or_exp_pre logical_and_exp logical_and_exp_pre
%type <ast> or_expression or_expression_pre xor_expression xor_expression_pre
%type <ast> and_expression and_expression_pre equality_expression equality_expression_pre
%type <ast> relational_expression relational_expression_pre
%type <ast> shift_expression shift_expression_pre additive_expression additive_expression_pre
%type <ast> multiplicative_expression multiplicative_expression_pre unary_expression unary_expression_pre
%type <ast> number


%start first

%%
first:
     program { 
                AST = $1;
                if(AST){
                    printf("\n\n\tBeginning to walk on the tree, enjoy the ride!\n\n\n");
                    treeWalk(AST);
                    printf("\n\n");
                }
                else {
                        printf("There's no tree to walk here pal'");
                }
                if ( symTable )
                {
                    //TODO Put here code to print HT
                }else{
                    printf("Error, HT empty!\n");
                }
                if(localScope){
                    //TODO Put here code to print HT
                }else{
                    printf("Error, HT empty!\n");
                }
        }
     ;

program:
        declaration {
          $$ = $1;
        }
        | function {
          $$ = $1;
        }
        | declaration program {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
        | function program {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
        ;

declaration: 
           NUMBER_SIGN DEFINE IDENTIFIER expression {
                        GenericNode* aux = new GenericNode($4, NULL, NULL, NULL);
                        aux->setType(DEFINE);
                        aux->symTp = "DEFINE";
                        aux->symId = $3;
                        
                        $$ = aux;
                }
           | variable_declaration {$$ = $1;}
           | prototype_declaration {$$ = $1;}
           ;

function:
      type IDENTIFIER params L_CURLY_BRACKET commands R_BRACE_BRACKET {
                        GenericNode* aux = new GenericNode($1,$3,$5,NULL);
                        $$ = aux;
                }
      | type IDENTIFIER params L_CURLY_BRACKET function_pre commands R_BRACE_BRACKET {
                        GenericNode* aux = new GenericNode($1,$3,$5,$6);
                        $$ = aux;
                }
      ; 
 
function_pre:
          variable_declaration {$$ = $1;}
          | variable_declaration function_pre{
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
          ;

variable_declaration:
                    type variable_declaration_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                    ;

variable_declaration_pre:
                        IDENTIFIER variable_declaration_post{$$ = $2;}
                        | IDENTIFIER ASSIGN expression variable_declaration_post{
                                        GenericNode* aux = new GenericNode($3,$4,NULL,NULL);
                                        $$ = aux;
                                }
                        ;

variable_declaration_post:
                         COMMA variable_declaration_pre{$$ = $2;}
                        | SEMICOLON{$$ = NULL;}
                        ;

prototype_declaration:
                   type IDENTIFIER params SEMICOLON{
                                GenericNode* aux = new GenericNode($1,$3,NULL,NULL);
                                $$ = aux;
                        }
                   ;

params:
          L_PAREN R_PAREN{$$ = NULL;}
          | L_PAREN params_post R_PAREN{$$ = $2;}
          ;

params_post:
              type IDENTIFIER{$$ = $1;}
              | type IDENTIFIER COMMA params_post{
                        GenericNode* aux = new GenericNode($1,$4,NULL,NULL);
                        $$ = aux;
                }
              ;

type:
    INT {$$ = NULL;}
    | CHAR {$$ = NULL;}
    | VOID {$$ = NULL;}
    ;

commands:
        command_list{$$ = $1;}
        | command_list commands {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
        ;

block:
     L_CURLY_BRACKET commands R_BRACE_BRACKET {$$ = $2;}
     ;

command_list:
                 DO block WHILE L_PAREN expression R_PAREN SEMICOLON {
                                GenericNode* aux = new GenericNode($2,$5,NULL,NULL);
                                aux->setType(DO);
                                $$ = aux;
                        }
                 | IF L_PAREN expression R_PAREN block ELSE else_pre {
                                GenericNode* aux = new GenericNode($3,$5,$7,NULL);
                                aux->setType(IF);
                                $$ = aux;
                        }
                 | IF L_PAREN expression R_PAREN block {
                                GenericNode* aux = new GenericNode($3,$5,NULL,NULL);
                                aux->setType(IF);
                                $$ = aux;
                        }
                 | WHILE L_PAREN expression R_PAREN block {
                                GenericNode* aux = new GenericNode($3,$5,NULL,NULL);
                                aux->setType(WHILE);
                                $$ = aux;
                        }
                 | FOR L_PAREN for_post for_post for_pre block {
                                GenericNode* aux = new GenericNode($3,$4,$5,$6);
                                aux->setType(FOR);
                                $$ = aux;
                        }
                 | PRINTF L_PAREN STRING printf_pre R_PAREN SEMICOLON{
                                GenericNode* aux = new GenericNode($4,NULL,NULL,NULL);
                                aux->setType(PRINTF);
                                $$ = aux;
                        }
                 | SCANF L_PAREN STRING COMMA BITWISE_AND IDENTIFIER R_PAREN SEMICOLON {
                                GenericNode *aux = new GenericNode(NULL,NULL,NULL,NULL);
                                aux->setType(SCANF);
                                $$ = aux;
                        }
                 | EXIT L_PAREN expression R_PAREN SEMICOLON {
                                GenericNode *aux = new GenericNode($3,NULL,NULL,NULL);
                                aux->setType(EXIT);
                                $$ = aux;
                        }
                 | RETURN SEMICOLON {
                                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                                aux->setType(RETURN);
                                $$ = aux;
                        }
                 | RETURN L_PAREN expression R_PAREN SEMICOLON {
                                GenericNode* aux = new GenericNode($3,NULL,NULL,NULL);
                                aux->setType(RETURN);
                                $$ = aux;
                        }
                 | expression SEMICOLON {$$ = $1;}
                 | SEMICOLON {$$ = NULL;}
                 | block {$$ = $1;}
                 ;

for_post:
       expression SEMICOLON {$$ = $1;}
       | SEMICOLON {$$ = NULL;}
       ;

for_pre:
       expression R_PAREN{$$ = $1;}
       | R_PAREN {$$ = NULL;}
       ;

else_pre:
        block {$$ = $1;}
        | L_CURLY_BRACKET R_BRACE_BRACKET {$$ = NULL;}
        ;

printf_pre:
          COMMA expression {$$ = $2;}
          | COMMA expression printf_pre {
                        GenericNode* aux = new GenericNode($2,$3,NULL,NULL);
                        $$ = aux;
                }
          ;

expression:
         conditional_expression {$$ = $1;}
         | conditional_expression expression_post {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
         ;

expression_post:
             ASSIGN expression {
                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                        aux->setType(ASSIGN);
                        $$ = aux;
                }
             | ADD_ASSIGN expression {
                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                        aux->setType(ADD_ASSIGN);
                        $$ = aux;
                }
             | MINUS_ASSIGN expression {
                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                        aux->setType(MINUS_ASSIGN);
                        $$ = aux;
                }
             ;

conditional_expression:
                     logical_or_exp {$$ = $1;}
                     | TERNARY_CONDITIONAL logical_or_exp COLON logical_or_exp {
                                GenericNode* aux = new GenericNode($2,$4,NULL,NULL);
                                aux->setType(TERNARY_CONDITIONAL);
                                $$ = aux;
                        }
                     ;

logical_or_exp:
                   logical_and_exp {$$ = $1;}
                   | logical_and_exp logical_or_exp_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                   ;

logical_or_exp_pre:
                       LOGICAL_OR logical_or_exp {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(LOGICAL_OR);
                                $$ = aux;
                        }
                       ;

logical_and_exp:
                    or_expression {$$ = $1;}
                    | or_expression logical_and_exp_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                    ;

logical_and_exp_pre:
                        LOGICAL_AND logical_and_exp {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(LOGICAL_AND);
                                        $$ = aux;
                                }
                        ;

or_expression:
            xor_expression {$$ = $1;}
            | xor_expression or_expression_pre {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
            ;

or_expression_pre:
                BITWISE_OR or_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(BITWISE_OR);
                                $$ = aux;
                        }
                ;

xor_expression:
             and_expression {$$ = $1;}
             | and_expression xor_expression_pre {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
             ;

xor_expression_pre:
                 BITWISE_XOR xor_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(BITWISE_XOR);
                                $$ = aux;
                        }
                 ;

and_expression:
             equality_expression {$$ = $1;}
             | equality_expression and_expression_pre {
                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                        $$ = aux;
                }
             ;

and_expression_pre:
                 BITWISE_AND and_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(BITWISE_AND);
                                $$ = aux;
                        }
                 ;

equality_expression:
                   relational_expression {$$ = $1;}
                   | relational_expression equality_expression_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                   ;

equality_expression_pre:
                       EQUAL equality_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(EQUAL);
                                $$ = aux;
                        }
                       | NOT_EQUAL equality_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(NOT_EQUAL);
                                $$ = aux;
                        }
                       ;

relational_expression:
                    shift_expression {$$ = $1;}
                    | shift_expression relational_expression_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                    ;

relational_expression_pre:
                        LESS_THAN relational_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(LESS_THAN);
                                        $$ = aux;
                                }
                        | LESS_EQUAL relational_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(LESS_EQUAL);
                                        $$ = aux;
                                }
                        | GREATER_THAN relational_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(GREATER_THAN);
                                        $$ = aux;
                                }
                        | GREATER_EQUAL relational_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(GREATER_EQUAL);
                                        $$ = aux;
                                }
                        ;

shift_expression:
               additive_expression {$$ = $1;}
               | additive_expression shift_expression_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
               ;

shift_expression_pre:
                   R_SHIFT shift_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(R_SHIFT);
                                $$ = aux;
                        }
                   | L_SHIFT shift_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(L_SHIFT);
                                $$ = aux;
                        }
                   ;

additive_expression:
                 multiplicative_expression {$$ = $1;}
                 | multiplicative_expression additive_expression_pre {
                                GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                $$ = aux;
                        }
                 ;

additive_expression_pre:
                     PLUS additive_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(PLUS);
                                $$ = aux;
                        }
                     | MINUS additive_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(MINUS);
                                $$ = aux;
                        }
                     ;

multiplicative_expression:
                        unary_expression {$$ = $1;}
                        | unary_expression multiplicative_expression_pre {
                                        GenericNode* aux = new GenericNode($1,$2,NULL,NULL);
                                        $$ = aux;
                                }
                        ;

multiplicative_expression_pre:
                            REMAINDER multiplicative_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(REMAINDER);
                                        $$ = aux;
                                }
                            | MULTIPLY multiplicative_expression {
                                        GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                        aux->setType(MULTIPLY);
                                        $$ = aux;
                                }
                            ;

unary_expression:
                IDENTIFIER INC {
                                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                                aux->setType(INC);
                                $$ = aux;
                        }
                | IDENTIFIER {$$ = NULL;}
                | IDENTIFIER DEC {
                                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                                aux->setType(DEC);
                                $$ = aux;
                        }
                | number {$$ = $1;}
                | CHARACTER {
                                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                                aux->setType(CHARACTER);
                                $$ = aux;
                        }
                | IDENTIFIER L_PAREN unary_expression_pre R_PAREN {$$ = $3;}
                | L_PAREN expression R_PAREN {$$ = $2;}
                | NOT unary_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(NOT);
                                $$ = aux;
                        }
                | BITWISE_NOT unary_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(BITWISE_NOT);
                                $$ = aux;
                        }
                | MINUS unary_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(MINUS);
                                $$ = aux;
                        }
                | PLUS unary_expression {
                                GenericNode* aux = new GenericNode($2,NULL,NULL,NULL);
                                aux->setType(PLUS);
                                $$ = aux;
                        }
                ;

unary_expression_pre:
                    expression {$$ = $1;}
                    | expression COMMA unary_expression_pre {
                                GenericNode* aux = new GenericNode($1,$3,NULL,NULL);
                                $$ = aux;
                        }
                    ;

number:
      NUM_INTEGER {
                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                aux->setType(NUM_INTEGER);
                aux->value = NUM_INTEGER;
                $$ = aux;
        }
      | NUM_HEXA {
                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                aux->setType(NUM_HEXA);
                aux->value = NUM_HEXA;
                $$ = aux;
        }
      | NUM_OCTAL {
                GenericNode* aux = new GenericNode(NULL,NULL,NULL,NULL);
                aux->setType(NUM_OCTAL);
                aux->value = NUM_OCTAL;
                $$ = aux;
        }
      ;

%%


int yyerror( const char *s)
{
    fprintf(stderr, "Error while parsing: %s\n", s);
    printf("Error while parsing: %s\n\n", stderr);
}


int main(int argc, char **argv)
{
        printf("\n\n \t yyparse return ==> \n\n", yyparse());
        return 0;
}

