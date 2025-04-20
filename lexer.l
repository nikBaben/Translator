%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
%}

%%
"#include"      { printf("LEXER: INCLUDE\n"); return INCLUDE; }
"<iostream>"    { printf("LEXER: IOSTREAM\n");  return IOSTREAM; }
"<string>"      { printf("LEXER: IOSTREAM\n");  return STRINGINCLUDE; }
"using"         { printf("LEXER: USING\n");  return USING; }
"namespace"     { printf("LEXER: NAMESPACE\n");  return NAMESPACE; }
"std"           { printf("LEXER: STD\n");  return STD; }
"main"          { printf("LEXER: main\n");  return MAIN; }
"return"        { printf("LEXER: return\n"); yylval.strval = strdup(yytext); return RETURN; }
";"             { printf("LEXER: semicolon\n"); return SEMICOLON; }
"{"             { printf("LEXER: lbrace\n");  return LBRACE; }
"}"             { printf("LEXER: rbrace\n");  return RBRACE; }
"("             { printf("LEXER: lparen\n");  return LPAREN; }
")"             { printf("LEXER: rparen\n"); return RPAREN; }
"["             { printf("LEXER: lparensq\n"); return LPARENSQ; }
"]"             { printf("LEXER: rparensq\n"); return RPARENSQ; }
"."             { printf("LEXER: dot\n"); yylval.strval = strdup(yytext); return DOT; }
","             { printf("LEXER: comma\n"); yylval.strval = strdup(yytext); return COMMA; }
"&"             { printf("LEXER: amp\n"); yylval.strval = strdup(yytext); return AMP; }

"cin"           { printf("LEXER: cin\n"); return CIN; }
"cout"          { printf("LEXER: cout\n"); return COUT; }
"endl"          { printf("LEXER: endl\n"); return ENDL; }
"<<"            { printf("LEXER: output_op %s\n", yytext); yylval.strval = strdup(""); return OUTPUT_OP; }
">>"            { printf("LEXER: input_op %s\n", yytext);  yylval.strval = strdup(""); return INPUT_OP; }
"clear"         { printf("LEXER: clear\n"); return CLEAR; }
"get"           { printf("LEXER: get\n"); return GET; }

"||"            { printf("LEXER: or\n"); yylval.strval = strdup(yytext); return OR; }
"<="            { printf("LEXER: leq\n"); yylval.strval = strdup(yytext); return LEQ; }
"<"             { printf("LEXER: less\n");  yylval.strval = strdup(yytext); return LESS; }
">"             { printf("LEXER: bigger\n"); yylval.strval = strdup(yytext); return BIGGER; }
"!"             { printf("LEXER: not\n"); yylval.strval = strdup(yytext); return NOT; }
"=="            { printf("LEXER: eqyes\n");yylval.strval = strdup(yytext); return EQYES; }
"!="            { printf("LEXER: noteq\n"); yylval.strval = strdup(yytext); return NOTEQ; }
"="             { printf("LEXER: eq\n"); return EQ; }

"++"            { printf("LEXER: increment\n"); yylval.strval = strdup(yytext); return INCREMENT; }
"+"             { printf("LEXER: plus\n");yylval.strval = strdup(yytext); return PLUS; }
"-"             { printf("LEXER: minus\n");yylval.strval = strdup(yytext); return MINUS; }
"/"             { printf("LEXER: div\n");yylval.strval = strdup(yytext); return DIV; }
"*"             { printf("LEXER: multiply\n"); yylval.strval = strdup(yytext); return MULTIPLY; }

"struct"        { printf("LEXER: struct\n"); return STRUCT; }
"vector"        { printf("LEXER: vector\n"); return VECTOR; }
"new"           { printf("LEXER: new\n"); return NEW; } 

"string"        { printf("LEXER: string\n"); yylval.strval = strdup(yytext); return STRING; }
"float"         { printf("LEXER: float\n"); return FLOAT; }
"bool"          { printf("LEXER: bool\n"); yylval.strval = strdup(yytext); return BOOL; }  
"void"          { printf("LEXER: void\n");yylval.strval = strdup(""); return VOID; }  
"int"           { printf("LEXER: INT\n"); yylval.strval = strdup(yytext); return INT; }
"const"         { printf("LEXER: const\n"); yylval.strval = strdup(""); return CONST; }

"while"         { printf("LEXER: while\n"); return WHILE; }
"for"           { printf("LEXER: for\n"); return FOR; }
"if"            { printf("LEXER: if\n"); return IF; }
"else"          { printf("LEXER: else\n"); return ELSE; }

"sort"          { printf("LEXER: sort\n"); return SORT;}
"begin"         { printf("LEXER: begin\n"); return BEGINETOK; }
"end"           { printf("LEXER: end\n"); return END;}
"delete"        { printf("LEXER: delete\n"); return DELETE;}

[0-9]+          { printf("LEXER: INTEGER %s\n", yytext);yylval.intval = atoi(yytext); return INTEGER; }
[0-9]+\.[0-9]+  {printf("LEXER: FLOATnumber %s\n", yytext);yylval.fval = atof(yytext); return FLOATnumber;}
[a-zA-Z_][a-zA-Z0-9_]* { printf("LEXER: IDENTIFIER %s\n", yytext); yylval.strval = strdup(yytext);  return IDENTIFIER; }
[ \t\n]+        {}
"\""[^"]*"\""   {printf("LEXER: STRING %s\n", yytext); yylval.strval = strdup(yytext); return STR;}
'\\[nrtbfv\\]'  {printf("LEXER: CCS %s\n", yytext); yylval.strval = strdup(yytext); return CCS;}
"//".*          {}
"/*"([^*]|\*+[^*/])*\*+"/"  {}
%%

int yywrap() { return 1; }


