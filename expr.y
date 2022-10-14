%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
char idStr[50][50];
int idLen=0;
int idPointer =0;
static double idVal[50];
void yyerror(const char* s);
%}
%token ID
%token NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%token EQUAL
%token l_brace
%token r_brace
%left EQUAL
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :       lines expr ';' {printf("%f\n", $2);}
        |       lines ';'
        |
        ;

expr    :       expr ADD expr   {$$ = $1 + $3;}
        |       expr SUB expr   {$$ = $1 - $3;}
        |       expr MUL expr   {$$ = $1 * $3;}
        |       expr DIV expr   {$$ = $1 / $3;}
        |       expr EQUAL expr   {idVal[(int)$1] = $3;$$ = $3;}
        |       l_brace expr r_brace   {$$ = $2;}
        |       SUB expr %prec UMINUS {$$ = -$2;}
        |       NUMBER {$$ = $1;}
        |       ID {$$ = $1;}
        ;

%%
int yylex(){
    int t;
    while(1){
        t = getchar();
        if(t == ' '|| t == '\t' || t == '\n'){
            
        }
        else if(isdigit(t)){
            yylval = 0;
            while(isdigit(t)){
                yylval = yylval *10 + t - '0';
                t = getchar(); 
            }
            ungetc(t, stdin);
            return NUMBER;
        }else if (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_'))
        {
            int i = 0;
            int hash=0;
            while (( t >= 'a' && t <= 'z') || ( t >= 'A' && t <= 'Z') || ( t == '_')
            ||isdigit(t))
             {
                 idStr[idLen][i] = t;
                 hash = hash*10 + t- '\0';
                 i++;
                 t = getchar();
             }
            idPointer = hash % 50;
            idStr[idLen][i] = '\0';
            if(idVal[idPointer] == 0){
                yylval = idPointer;
            }else
                yylval = idVal[idPointer];
            ungetc(t, stdin);
            idLen ++;
            return ID;
        }else if(t == '+'){
            return ADD;
        }else if(t == '-'){
            return SUB;
        }else if(t == '*'){
            return MUL;
        }else if(t == '/'){
            return DIV;
        }else if(t == '('){
			return l_brace;
		}else if(t == ')'){
			return r_brace;
		}else if(t == '='){
            return EQUAL;
        }else{
            return t;
        }
    }
}
int main(void)
{
    yyin = stdin;
    do{
        yyparse();
    }while(!feof(yyin));
    return 0;
}
void yyerror(const char* s){
    fprintf(stderr, "Parse error:%s\n", s);
    exit(1);
}