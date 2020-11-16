%{
    #include <stdio.h>
    #include "y.tab.h"

    int COMMENT= 0;

    extern int yyerror(char *msg);

%}

alpha 			                    [A-Za-z_]
fl			                        (f|F|l|L)
ul			                        (u|U|l|L)*
digit 			                    [0-9]
hex			                        [a-fA-F0-9]
exp			                        [Ee][+-]?{digit}+

%%

\n                                  { yylineno++; }

"/*"                                { COMMENT = 1; }
"*/"                                { COMMENT = 0; }
"//".*                              {}

{digit}+    				        { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*INT*/
({digit}+)\.({digit}+) 			    { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
0[xX]{hex}+{ul}?			        { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
{digit}+{ul}?				        { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
'(\\.|[^\\'])+'				        { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
{digit}+{exp}{fl}?			        { if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
{digit}*"."{digit}+({exp})?{fl}?	{ if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/
{digit}+"."{digit}*({exp})?{fl}?	{ if(!COMMENT) { yylval.sValue = strdup(yytext); return (CONSTANT); } } /*FLOAT*/

{alpha}?\"(\\.|[^\\"])*\"		    { if(!COMMENT) { yylval.sValue = strdup(yytext); return (STRING); } } /*STRING*/

\{                                  { if(!COMMENT) return (LBRACE); }
\}                                  { if(!COMMENT) return (RBRACE); }

\( 	                                { if(!COMMENT) return (LPAREN); }
\) 	                                { if(!COMMENT) return (RPAREN); }

\[                                  { if(!COMMENT) return (LBRACKET); }    
\]                                  { if(!COMMENT) return (RBRACKET); }

\,                                  { if(!COMMENT) return (COMMA); }
[;]                                 { if(!COMMENT) return (SEMICOLON); }

\+                                  { if(!COMMENT) return (PLUS); }
\-                                  { if(!COMMENT) return (MINUS); }
\*                                  { if(!COMMENT) return (MULT); }
\/                                  { if(!COMMENT) return (DIV); }
\%                                  { if(!COMMENT) return (MOD); }
=                                   { if(!COMMENT) return (ASSIGN); }
"*="			                    { if(!COMMENT) return (MULT_ASSIGN); }
"/="			                    { if(!COMMENT) return (DIV_ASSIGN); }
"%="			                    { if(!COMMENT) return (MOD_ASSIGN); }
"+="			                    { if(!COMMENT) return (ADD_ASSIGN); }
"-="			                    { if(!COMMENT) return (SUB_ASSIGN); }

\+\+                                { if(!COMMENT) return (INCREMENT); }
\-\-                                { if(!COMMENT) return (DECREMENT); }

\&                                  { if(!COMMENT) return (AND); }
\|                                  { if(!COMMENT) return (OR); }
\^                                  { if(!COMMENT) return (XOR); }

\&\& |
and                                 { if(!COMMENT) return (AND_OP); }

\|\| |
or	                                { if(!COMMENT) return (OR_OP); }

\!                                  { if(!COMMENT) return (NOT); }    
\==                                 { if(!COMMENT) return (EQUAL); }
\!=                                 { if(!COMMENT) return (DIFF); }

\<=                                 { if(!COMMENT) return (LESS_EQUAL_THAN); }
\>=                                 { if(!COMMENT) return (MORE_EQUAL_THAN); }
\<                                  { if(!COMMENT) return (LESS_THAN); }
\>                                  { if(!COMMENT) return (MORE_THAN); } 

int                                 { if(!COMMENT) return (INT); }
float                               { if(!COMMENT) return (FLOAT); }
char                                { if(!COMMENT) return (CHAR); }
void                                { if(!COMMENT) return (VOID); }

if                                  { if(!COMMENT) return (IF); }
else                                { if(!COMMENT) return (ELSE); }
for                                 { if(!COMMENT) return (FOR); }
while                               { if(!COMMENT) return (WHILE); }
return                              { if(!COMMENT) return (RETURN); }

{alpha}({alpha}|{digit})*           { if(!COMMENT) { yylval.sValue = strdup(yytext); return (ID); } }
[ \t\v\n\f]                         { ; }
.                                   { yyerror("invalid character"); }

%%

#ifndef yywrap
   int yywrap (void) {return 1;}
#endif