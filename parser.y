%{
#include <stdio.h>
#include <string.h>
#include <stdarg.h>

int yylex(void);
int yyerror(char *s);
char *concat(int count, ...);
extern int yylineno;
extern char * yytext;

%}

%union {
    int iValue;
    char* sValue;
}

%token <sValue> ID
%token <sValue> CONSTANT
%token <sValue> STRING

%token PREPROCESS
%token LBRACE LBRACKET LPAREN RPAREN RBRACKET RBRACE
%token COMMA SEMICOLON
%token PLUS MINUS MULT DIV MOD POW ASSIGN
%token MULT_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN SUB_ASSIGN
%token INCREMENT DECREMENT
%token AND_OP OR_OP AND OR XOR
%token NOT EQUAL DIFF
%token LESS_EQUAL_THAN MORE_EQUAL_THAN LESS_THAN MORE_THAN
%token INT FLOAT CHAR VOID
%token FOR WHILE IF ELSE RETURN

%left PLUS MINUS
%left MULT DIV
%right POW
%right ASSIGN
%left AND OR
%left LESS_THAN MORE_THAN LESS_EQUAL_THAN MORE_EQUAL_THAN EQUAL DIFF

%type <sValue> type_specifier
%type <sValue> declaration_specifiers
%type <sValue> declaration
%type <sValue> external_declaration
%type <sValue> init_declarator_list
%type <sValue> init_declarator
%type <sValue> declarator
%type <sValue> direct_declarator
%type <sValue> parameter_list
%type <sValue> identifier_list
%type <sValue> initializer
%type <sValue> assignment_expression
%type <sValue> initializer_list
%type <sValue> conditional_expression
%type <sValue> unary_expression
%type <sValue> assignment_operator
%type <sValue> postfix_expression
%type <sValue> cast_expression
%type <sValue> unary_operator
%type <sValue> type_name
%type <sValue> specifier_qualifier_list
%type <sValue> primary_expression
%type <sValue> expression
%type <sValue> argument_expression_list
%type <sValue> logical_or_expression
%type <sValue> logical_and_expression
%type <sValue> inclusive_or_expression
%type <sValue> exclusive_or_expression
%type <sValue> and_expression
%type <sValue> equality_expression
%type <sValue> relational_expression
%type <sValue> shift_expression
%type <sValue> additive_expression
%type <sValue> multiplicative_expression
%type <sValue> constant_expression
%type <sValue> parameter_declaration
%type <sValue> function_definition
%type <sValue> declaration_list
%type <sValue> compound_statement
%type <sValue> statement_list
%type <sValue> statement
%type <sValue> expression_statement
%type <sValue> selection_statement
%type <sValue> iteration_statement
%type <sValue> jump_statement
%type <sValue> begin

%start test

%%

test: begin	{ printf("%s", $1); }
	;

begin: external_declaration			{ $$ = $1; }
	| begin external_declaration	{ $$ = $$ = concat(2, $1, $2); }
	;

external_declaration: function_definition	{ $$ = $1; }
	| declaration							{ $$ = $1; }
	;

function_definition: declaration_specifiers declarator declaration_list compound_statement	{ $$ = concat(4, $1, $2, $3, $4); }
	| declaration_specifiers declarator compound_statement									{ $$ = concat(3, $1, $2, $3); }
	| declarator declaration_list compound_statement										{ $$ = concat(3, $1, $2, $3); }
	| declarator compound_statement															{ $$ = concat(2, $1, $2); }
	;

compound_statement: LBRACE RBRACE					{ $$ = "[]"; }
	| LBRACE statement_list RBRACE					{ $$ = concat(3, "{\n", $2, "}\n"); }
	| LBRACE declaration_list RBRACE				{ $$ = concat(3, "{\n", $2, "}\n"); }
	| LBRACE declaration_list statement_list RBRACE	{ $$ = concat(4, "{\n", $2, $3, "}\n"); }
	;

statement_list: statement		{ $$ = $1; }
	| statement_list statement	{ $$ = concat(2, $1, $2); }
	;

statement: compound_statement	{ $$ = $1; }
	| expression_statement		{ $$ = $1; }
	| selection_statement		{ $$ = $1; }
	| iteration_statement		{ $$ = $1; }
    | jump_statement			{ $$ = $1; }
	;

jump_statement: RETURN SEMICOLON	{ $$ = "return;\n"; }
	| RETURN expression SEMICOLON	{ $$ = concat(3, "return", $2, ";\n"); }
	;

iteration_statement: WHILE LPAREN expression RPAREN statement							{ $$ = concat(5, "while", "(", $3, ")", $5); }
	| FOR LPAREN expression_statement expression_statement LPAREN statement				{ $$ = concat(6, "for", "(", $3, $4, ")", $6); }
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement	{ $$ = concat(6, "for", "(", $3, $4, $5, ")", $7); }
	;

selection_statement: IF LPAREN expression RPAREN statement	{ $$ = concat(5, "if", "(", $3, ")", $5); }
	| IF LPAREN expression RPAREN statement ELSE statement  { $$ = concat(7, "if", "(", $3, ")", $5, "else", $7); }         
	;

expression_statement: SEMICOLON	{ $$ = ";\n"; }
	| expression SEMICOLON		{ $$ = concat(2, $1, ";\n"); }
	;

declaration_list: declaration		{ $$ = $1; }
	| declaration_list declaration	{ $$ = concat(2, $1, $2); }
	;

declaration: declaration_specifiers SEMICOLON				{ $$ = concat(2, $1, ";\n"); }
	| declaration_specifiers init_declarator_list SEMICOLON	{ $$ = concat(3, $1, $2, ";\n"); }
	;

declaration_specifiers: type_specifier		{ $$ = $1; }
	| type_specifier declaration_specifiers	{ $$ = concat(2, $1, $2); }
	;

init_declarator_list: init_declarator				{ $$ = $1; }
	| init_declarator_list COMMA init_declarator	{ $$ = concat(3, $1, ", ", $3); }
	;

init_declarator: declarator			{ $$ = $1; }
	| declarator ASSIGN initializer	{ $$ = concat(3, $1, " = ", $3); }
	;

initializer: assignment_expression			{ $$ = $1; }
	| LBRACE initializer_list RBRACE		{ $$ = concat(3, "{\n", $2, "}\n"); }
	| LBRACE initializer_list COMMA RBRACE	{ $$ = concat(4, "{\n", $2, ", ", "}"); }
	;

initializer_list: initializer				{ $$ = $1; }
	| initializer_list COMMA initializer	{ $$ = concat(3, $1, ", ", $3); }
	;

assignment_expression: conditional_expression						{ $$ = $1; }
	| unary_expression assignment_operator assignment_expression	{ $$ = concat(3, $1, $2, $3); }
	;

assignment_operator: ASSIGN	{ $$ = "="; }
	| MULT_ASSIGN			{ $$ = "*="; }
	| DIV_ASSIGN			{ $$ = "/="; }
	| MOD_ASSIGN			{ $$ = "%="; }
	| ADD_ASSIGN			{ $$ = "+="; }
	| SUB_ASSIGN			{ $$ = "-="; }
	;

unary_expression: postfix_expression	{ $$ = $1; }
	| INCREMENT unary_expression		{ $$ = concat(2, "++", $2); }
	| DECREMENT unary_expression		{ $$ = concat(2, "--", $2); }
	| unary_operator cast_expression	{ $$ = concat(2, $1, $2); }
	;

unary_operator: PLUS	{ $$ = "+"; }
	| MINUS				{ $$ = "-"; }
	| NOT				{ $$ = "!"; }
	;

cast_expression: unary_expression				{ $$ = $1; }
	| LPAREN type_name RPAREN cast_expression	{ $$ = concat(4, "(", $2, ")", $4); }
	;

type_name: specifier_qualifier_list			{ $$ = $1; }
	| specifier_qualifier_list declarator	{ $$ = concat(2, $1, $2); }
	;

specifier_qualifier_list: type_specifier specifier_qualifier_list	{ $$ = concat(2, $1, $2); }
	| type_specifier 												{ $$ = $1; }
	;

postfix_expression: primary_expression							{ $$ = $1; }
	| postfix_expression LBRACKET expression RBRACKET			{ $$ = concat(4, $1, "[", $3, "]"); }
	| postfix_expression LPAREN RPAREN							{ $$ = concat(3, $1, "(", ")"); }
	| postfix_expression LPAREN argument_expression_list RPAREN	{ $$ = concat(4, $1, "(", $3, ")"); }
	| postfix_expression INCREMENT								{ $$ = concat(2, $1, "++"); }
	| postfix_expression DECREMENT								{ $$ = concat(2, $1, "--"); }
	;

argument_expression_list: assignment_expression				{ $$ = $1; }
	| argument_expression_list COMMA assignment_expression	{ $$ = concat(3, $1, ", ", $3); }
	;

expression: assignment_expression				{ $$ = $1; }
	| expression COMMA assignment_expression	{ $$ = concat(3, $1, ", ", $3); }
	;

primary_expression: ID			{ $$ = $1; }
    | CONSTANT					{ $$ = $1; }
	| STRING					{ $$ = $1; }
	| LPAREN expression RPAREN	{ $$ = concat(3, "(", $2, ")"); }
	;

conditional_expression: logical_or_expression { $$ = $1; }
    ;

logical_or_expression: logical_and_expression				{ $$ = $1; }
	| logical_or_expression OR_OP logical_and_expression	{ $$ = concat(3, $1, " || ", $3); }
	;

logical_and_expression: inclusive_or_expression				{ $$ = $1; }
	| logical_and_expression AND_OP inclusive_or_expression	{ $$ = concat(3, $1, " && ", $3); }
	;

inclusive_or_expression: exclusive_or_expression			{ $$ = $1; }
	| inclusive_or_expression OR exclusive_or_expression	{ $$ = concat(3, $1, " | ", $3); }
	;

exclusive_or_expression: and_expression				{ $$ = $1; }
	| exclusive_or_expression XOR and_expression	{ $$ = concat(3, $1, " ^ ", $3); }
	;

and_expression: equality_expression				{ $$ = $1; }
	| and_expression AND equality_expression	{ $$ = concat(3, $1, " & ", $3); }
	;

equality_expression: relational_expression				{ $$ = $1; }
	| equality_expression EQUAL relational_expression	{ $$ = concat(3, $1, " == ", $3); }
	| equality_expression DIFF relational_expression	{ $$ = concat(3, $1, " != ", $3); }
	;

relational_expression: shift_expression							{ $$ = $1; }
	| relational_expression LESS_THAN shift_expression			{ $$ = concat(3, $1, " < ", $3); }
	| relational_expression MORE_THAN shift_expression			{ $$ = concat(3, $1, " > ", $3); }
	| relational_expression LESS_EQUAL_THAN shift_expression	{ $$ = concat(3, $1, " <= ", $3); }
	| relational_expression MORE_EQUAL_THAN shift_expression	{ $$ = concat(3, $1, " >= ", $3); }
	;

shift_expression: additive_expression	{ $$ = $1; }
    ;

additive_expression: multiplicative_expression				{ $$ = $1; }
	| additive_expression PLUS multiplicative_expression	{ $$ = concat(3, $1, " + ", $3); }
	| additive_expression MINUS multiplicative_expression	{ $$ = concat(3, $1, " - ", $3); }
	;

multiplicative_expression: cast_expression				{ $$ = $1; }
	| multiplicative_expression MULT cast_expression	{ $$ = concat(3, $1, " * ", $3); }
	| multiplicative_expression DIV cast_expression		{ $$ = concat(3, $1, " / ", $3); }
	| multiplicative_expression MOD cast_expression		{ $$ = concat(3, $1, " % ", $3); }
	;

type_specifier: VOID	{ $$ = "void "; }
	| CHAR				{ $$ = "char "; }
	| INT 				{ $$ = "int "; }
	| FLOAT				{ $$ = "float "; }
	;

declarator: direct_declarator { $$ = $1; }
	;

direct_declarator: ID											{ $$ = $1; }
	| LPAREN declarator RPAREN									{ $$ = concat(3, "(", $2, ")"); }
	| direct_declarator LBRACKET constant_expression RBRACKET	{ $$ = concat(4, $1, "[", $3, "]"); }
	| direct_declarator LBRACKET RBRACKET						{ $$ = concat(3, $1, "[", "]"); }
	| direct_declarator LPAREN parameter_list RPAREN 			{ $$ = concat(4, $1, "(", $3, ")"); }
	| direct_declarator LPAREN identifier_list RPAREN			{ $$ = concat(4, $1, "(", $3, ")"); }
	| direct_declarator LPAREN RPAREN							{ $$ = concat(3, $1, "(", ")"); }
	;

constant_expression: conditional_expression	{ $$ = $1; }
	;

parameter_list: parameter_declaration				{ $$ = $1; }
	| parameter_list COMMA parameter_declaration	{ $$ = concat(3, $1, ", ", $3); }
	;

parameter_declaration: declaration_specifiers declarator	{ $$ = concat(2, $1, $2); }
	| declaration_specifiers								{ $$ = $1; }
	;

identifier_list: ID				{ $$ = $1; }
	| identifier_list COMMA ID	{ $$ = concat(3, $1, ", ", $3); }
	;

%%

char *concat(int count, ...)
{
    va_list ap;
    size_t  len = 0;

    if (count < 1)
        return NULL;

    // First, measure the total length required.
    va_start(ap, count);
    for (int i=0; i < count; i++) {
        const char *s = va_arg(ap, char *);
        len += strlen(s);
    }
    va_end(ap);

    // Allocate return buffer.
    char *ret = malloc(len + 1);
    if (ret == NULL)
        return NULL;

    // Concatenate all the strings into the return buffer.
    char *dst = ret;
    va_start(ap, count);
    for (int i=0; i < count; i++) {
        const char *src = va_arg(ap, char *);

        // This loop is a strcpy.
        while (*dst++ = *src++);
        dst--;
    }
    va_end(ap);
    return ret;
}

int main (void) {
	return yyparse();
}
         
int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
