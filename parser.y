%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern FILE* yyin;
extern FILE* yyout;

int yylex();
void yyerror(char* s);



/* -------------------------------- */
/* Функция автоформатирования табов */
/* -------------------------------- */
char* format_output_with_indentation(const char* input) 
{
    int indent_level = 0;
    int len = strlen(input);
    char* formatted = malloc(len * 2);
    if (!formatted) return NULL;

    int i = 0, j = 0;
    while (input[i]) {
        if (input[i] == '{') {
            formatted[j++] = input[i++];
            formatted[j++] = '\n';
            indent_level++;
            for (int k = 0; k < indent_level; k++) formatted[j++] = '\t';
        } else if (input[i] == '}') {
            formatted[j++] = '\n';
            indent_level--;
            for (int k = 0; k < indent_level; k++) formatted[j++] = '\t';
            formatted[j++] = input[i++];
        } else if (input[i] == '\n') {
            formatted[j++] = input[i++];
            if (input[i] && input[i] != '}' && input[i] != '\n') {
                for (int k = 0; k < indent_level; k++) formatted[j++] = '\t';
            }
        } else {
            formatted[j++] = input[i++];
        }
    }

    formatted[j] = '\0';
    return formatted;
}
%}



/* ------------------ */
/* Декларация токенов */
/* ------------------ */
%union {
    int intval;
    char* strval;
    float fval;
}

%token INT RETURN MAIN IDENTIFIER INTEGER INCLUDE IOSTREAM STRINGINCLUDE USING NAMESPACE STD LPARENSQ RPARENSQ DOT CCS FLOATnumber
%token SEMICOLON LPAREN RPAREN LBRACE RBRACE COMMA AMP CIN COUT ENDL OUTPUT_OP INPUT_OP CLEAR GET OR LEQ LESS BIGGER NOT EQYES NOTEQ DELETE
%token EQ INCREMENT PLUS MINUS DIV MULTIPLY STRUCT VECTOR NEW STRING FLOAT BOOL VOID CONST WHILE FOR IF ELSE SORT BEGINETOK END STR 

%type <strval> IDENTIFIER RETURN STR CCS  struct_declaration struct_fields field sub_functions sub_function DataType sub_function_arguments sub_function_argument Symbols stms stm  if_declaration input_output_datas input_output_data  input_output loop_declaration loop_condition loop_conditions Else_declaration main_function
%type <intval> INTEGER
%type <strval> INT STRING BOOL CONST VOID

%type <strval> COMMA AMP DOT
%type <strval> OR LEQ LESS BIGGER NOT EQYES NOTEQ 
%type <strval> DIV PLUS MINUS INCREMENT MULTIPLY 
%type <fval> FLOATnumber

%type <strval> Bool_operatos

%start program

%%



/* ------------------------------ */
/* Вывод содержимого всего дерева */
/* ------------------------------ */
program:
    headers using struct_declaration sub_functions main_function
    {
        printf("DEBUG: Parsed structures program");
        char* raw_output;
        asprintf(&raw_output, "package main\n\nimport (\n\"fmt\"\n\"sort\"\n)\n\n%s\n%s\n\n%s\n\n", $3,$4,$5);

        char* formatted = format_output_with_indentation(raw_output);
        fprintf(yyout, "%s", formatted);

        free($3); 
        free($4);
        free($5);
        free(raw_output);
        free(formatted);
    }
;



/* -------------------------------- */
/* Грамматики подключения библиотек */
/* -------------------------------- */
headers:
    INCLUDE IOSTREAM { printf("DEBUG: Parsed header\n"); }
    INCLUDE STRINGINCLUDE { printf("DEBUG: Parsed header\n"); }
;

using:
    USING NAMESPACE STD SEMICOLON { printf("DEBUG: Parsed using namespace\n"); }
;



/* --------------------------- */
/* Грамматики основной функции */
/* --------------------------- */
main_function:
    DataType MAIN LPAREN RPAREN LBRACE stms RBRACE
    {
        asprintf(&$$, "func main() {\n   %s\n}\n", $6);
        free($6); 
    }
     


/* ------------------- */
/* Грамматики структур */
/* ------------------- */
struct_declaration:
    STRUCT IDENTIFIER LBRACE struct_fields RBRACE SEMICOLON
    {
        printf("DEBUG: Parsed struct");
        asprintf(&$$, "type %s struct {%s}", $2, $4);
        free($2); 
        free($4);
    }
;

struct_fields:
    struct_fields field
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | field{$$ = $1;}
;

field:
    DataType IDENTIFIER SEMICOLON
    {
        printf("DEBUG: Parsed struct fields");
        asprintf(&$$, "%s %s\n", $2,$1);
        free($2);
        free($1);
    }
;



/* --------------------------- */
/* Грамматики побочных функций */
/* --------------------------- */
sub_functions:
    sub_functions sub_function
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | sub_function{$$ = $1;}
;

sub_function:
    DataType IDENTIFIER LPAREN sub_function_arguments RPAREN LBRACE stms RBRACE 
    {
        printf("DEBUG: Parsed sub_function");
        asprintf(&$$, "func %s (%s) %s {%s}\n\n", $2,$4,$1,$7);
        free($1);
        free($2);
        free($4);
        free($7);
    }
;

sub_function_arguments: 
sub_function_arguments sub_function_argument
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | sub_function_argument{$$ = $1;}
;

sub_function_argument: 
    DataType IDENTIFIER AMP IDENTIFIER          
    {
        printf("DEBUG: Parsed sub_function argument");
        asprintf(&$$, "%s %s", $4,$2); 
        free($2);
        free($3);
        free($4);
    }
    | DataType IDENTIFIER MULTIPLY IDENTIFIER   
    {
        printf("DEBUG: Parsed sub_function argument");
        asprintf(&$$, "%s []%s", $4,$2);
        free($2);
        free($4);
    }
    | DataType IDENTIFIER                       
    {
        printf("DEBUG: Parsed sub_function argument");
        asprintf(&$$, "%s %s", $2,$1);
        free($1);
        free($2);
    }
    | Symbols 
;



/* ------------------------------------- */
/* Грамматики основных конструкций языка */
/* ------------------------------------- */
stms:
    stms stm
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | stm {$$ = $1;}
;

stm:
    IDENTIFIER       
    {
        asprintf(&$$, "%s ", $1); 
        free($1);
    }
    | FLOATnumber {asprintf(&$$, " %f", $1); }
    | RETURN  
    {
        asprintf(&$$, "%s ", $1); 
        free($1);
    }
    | RETURN INTEGER {asprintf(&$$,"");}
    | IDENTIFIER Symbols IDENTIFIER 
    {
        asprintf(&$$, "%s%s%s", $1, $2, $3); 
        free($1);
        free($3); 
    }
    | IDENTIFIER LPARENSQ IDENTIFIER RPARENSQ Symbols IDENTIFIER 
    {
        asprintf(&$$, "%s[%s]%s%s", $1, $3, $5, $6); // копируем все части в одну строку
        free($1); // освобождаем память для первой части
        free($3); // освобождаем память для индекса
        free($6); // освобождаем память для второй части
    }
    | INTEGER 
    {
        asprintf(&$$, "%d ", $1); // записываем число в строку
    }
    | DataType IDENTIFIER 
    { 
        asprintf(&$$, "var %s %s ", $2, $1); 
        free($2);
    }
    | IDENTIFIER MULTIPLY IDENTIFIER EQ NEW IDENTIFIER LPARENSQ IDENTIFIER RPARENSQ
    {
        asprintf(&$$, "%s := make([]%s, %s)", $3,$6,$8);
        free($3);
        free($6);
        free($8);
    }
    | SORT LPAREN IDENTIFIER COMMA IDENTIFIER PLUS IDENTIFIER COMMA IDENTIFIER RPAREN 
    {
        asprintf(&$$, "sort.Slice(%s, func(i, j int) bool {\n return %s(%s[i], %s[j])}) ",$3,$9,$3,$3);
        free($3);
        free($9);
    }
    | IDENTIFIER LPAREN stms RPAREN
    {
        asprintf(&$$, "%s(%s)", $1,$3);
        free($1); 
        free($3);
    }
    | DataType LPAREN IDENTIFIER RPAREN 
    {
        asprintf(&$$," %s(%s)", $1,$3);
        free($1);
        free($3);
    }
    | DELETE LPARENSQ RPARENSQ IDENTIFIER{asprintf(&$$,"");}
    | if_declaration
    | Else_declaration
    | loop_declaration
    | input_output
    | SEMICOLON {asprintf(&$$, "\n");}
    | EQ        {$$ = strdup("=");}
    | Bool_operatos
    | Math_operators
    | Symbols 
;



/* -------------------*/
/* Грамматики условий */
/* ------------------ */
if_declaration:
    IF LPAREN stms RPAREN LBRACE stms RBRACE 
    {
        asprintf(&$$, "if (%s) {%s\n}\n", $3, $6);
        free($3);
    }
;

Else_declaration:
    ELSE LBRACE stms RBRACE
    {
        asprintf(&$$, " else {%s\n}\n ", $3);
        free($3);
    }
;


/* ----------------------- */
/* Грамматики ввода/вывода */
/* ----------------------- */
input_output:
    CIN INPUT_OP input_output_datas
    {
        asprintf(&$$,"fmt.Scan(&%s)\n",$3);
        free($3);
    }
    | COUT OUTPUT_OP input_output_datas
    {
        asprintf(&$$,"fmt.Println(%s)\n",$3);
        free($3);
    }
    | CIN DOT GET LPAREN RPAREN NOTEQ CCS{asprintf(&$$,"fmt.Scanln()\n");}
    | CIN DOT CLEAR LPAREN RPAREN SEMICOLON {asprintf(&$$,"");}
;

input_output_datas:
    input_output_datas input_output_data
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | input_output_data {$$ = $1;}
;

input_output_data:
    IDENTIFIER LPARENSQ IDENTIFIER RPARENSQ Symbols IDENTIFIER 
    {
        asprintf(&$$, "%s[%s]%s%s", $1, $3, $5, $6);
        free($1); 
        free($3); 
        free($6); 
    }
    | INPUT_OP          { asprintf(&$$, ",&"); }
    | OUTPUT_OP         { asprintf(&$$, ", "); }
    | STR               
    | OUTPUT_OP ENDL    
    | IDENTIFIER
;



/* ----------------- */
/* Грамматики циклов */
/* ----------------- */
loop_declaration:
    FOR LPAREN loop_conditions RPAREN LBRACE stms RBRACE
    { 
        asprintf(&$$, "for %s {%s\n}\n", $3,$6);
        free($3);
        free($6);
    }
    | WHILE LPAREN loop_conditions RPAREN LBRACE stms RBRACE
    {
        asprintf(&$$, " for {%s\n%s}\n",$3,$6);
        free($3);
        free($6);
	}
    | WHILE LPAREN loop_conditions RPAREN SEMICOLON
    {
        asprintf(&$$, "%s",$3);
        free($3);
	}
;

loop_conditions:
    loop_conditions loop_condition
    {
        asprintf(&$$, "%s%s", $1,$2);
        free($1);
        free($2);
    }
    | loop_condition {$$ = $1;}
;

loop_condition:
    IDENTIFIER 
    | INTEGER               {asprintf(&$$, "%d",$1);} 
    | DataType              {$$ = strdup("");}
    | SEMICOLON             {$$ = strdup(";");}
    | NOT LPAREN input_output RPAREN 
    {
        asprintf(&$$, "_, err := %s\n",$3);
        free($3);
    }
    | OR IDENTIFIER LEQ INTEGER
    {
        asprintf(&$$, "if err == nil && %s > %d {break\n}\n",$2,$4);
        free($2);
    }
    | EQ                {$$ = strdup(":=");}
    | Bool_operatos
    | Math_operators
    | input_output 



/* -------------------------- */
/* Вспомогательные грамматики */
/* -------------------------- */
Symbols:
    COMMA
    | AMP 
    | DOT 
;

Bool_operatos:
    OR 
    | LEQ 
    | LESS 
    | BIGGER 
    | NOT 
    | EQYES 
    | NOTEQ 
;

Math_operators: 
    DIV       
    | PLUS 
    | MINUS 
    | INCREMENT 
    | MULTIPLY    
;

DataType:
      FLOAT     { $$ = strdup("float64"); }
    | INT      
    | STRING   
    | BOOL      
    | CONST   
    | VOID      
;


%%

void yyerror(char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(int argc, char* argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            perror("Error opening file");
            return 1;
        }
    } else {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }

    yyout = stdout;
    yyparse();
    fclose(yyin);
    return 0;
}
