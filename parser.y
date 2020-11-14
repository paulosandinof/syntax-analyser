%{
#include <stdio.h>
#include <string.h>

int yylex(void);
int yyerror(char *s);
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

%start begin

%%

begin: external_declaration			{  }
	| begin external_declaration	{  }
	;

external_declaration: function_definition	{ $$ = $1; }
	| declaration							{ $$ = $1; }
	;

function_definition: declaration_specifiers declarator declaration_list compound_statement	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); strcat(str, " "); strcat(str, $3); strcat(str, " "); strcat(str, $4); $$ = str; printf("%s", $$); }
	| declaration_specifiers declarator compound_statement									{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); strcat(str, " "); strcat(str, $3); $$ = str; printf("%s", $$); }
	| declarator declaration_list compound_statement										{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); strcat(str, " "); strcat(str, $3); $$ = str; printf("%s", $$); }
	| declarator compound_statement															{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; printf("%s", $$); }
	;

compound_statement: LBRACE RBRACE					{ $$ = "[]"; }
	| LBRACE statement_list RBRACE					{ char str[256] = ""; strcat(str, "{"); strcat(str, $2); strcat(str, "}"); $$ = str; }
	| LBRACE declaration_list RBRACE				{ char str[256] = ""; strcat(str, "{"); strcat(str, $2); strcat(str, "}"); $$ = str; }
	| LBRACE declaration_list statement_list RBRACE	{ char str[256] = ""; strcat(str, "{"); strcat(str, $2); strcat(str, " "); strcat(str, $3); strcat(str, "}"); $$ = str; }
	;

statement_list: statement		{ $$ = $1; }
	| statement_list statement	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	;

statement: compound_statement	{ $$ = $1; }
	| expression_statement		{ $$ = $1; }
	| selection_statement		{ $$ = $1; }
	| iteration_statement		{ $$ = $1; }
    | jump_statement			{ $$ = $1; }
	;

jump_statement: RETURN SEMICOLON	{ char str[256] = ""; strcat(str, "return"); strcat(str, ";\n"); $$ = str; }
	| RETURN expression SEMICOLON	{ char str[256] = ""; strcat(str, "return "); strcat(str, $2); strcat(str, ";\n"); $$ = str; }
	;

iteration_statement: WHILE LPAREN expression RPAREN statement							{ char str[256] = ""; strcat(str, "while "); strcat(str, "("); strcat(str, $3); strcat(str, ")"); strcat(str, $5); $$ = str; }
	| FOR LPAREN expression_statement expression_statement LPAREN statement				{ char str[256] = ""; strcat(str, "for "); strcat(str, "("); strcat(str, $3); strcat(str, $4); strcat(str, ")"); strcat(str, $6); $$ = str; }
	| FOR LPAREN expression_statement expression_statement expression RPAREN statement	{ char str[256] = ""; strcat(str, "for "); strcat(str, "("); strcat(str, $3); strcat(str, $4); strcat(str, $5); strcat(str, ")"); strcat(str, $7); $$ = str; }
	;

selection_statement: IF LPAREN expression RPAREN statement	{ char str[256] = ""; strcat(str, "if "); strcat(str, "("); strcat(str, $3); strcat(str, ")"); strcat(str, $5); $$ = str; }
	| IF LPAREN expression RPAREN statement ELSE statement  { char str[256] = ""; strcat(str, "if "); strcat(str, "("); strcat(str, $3); strcat(str, ")"); strcat(str, $5); strcat(str, "else "); strcat(str, $7); $$ = str; }         
	;

expression_statement: SEMICOLON	{ $$ = ";\n"; }
	| expression SEMICOLON		{ char str[256] = ""; strcat(str, $1); strcat(str, ";\n"); $$ = str; }
	;

declaration_list: declaration		{ $$ = $1; }
	| declaration_list declaration	{ char str[256] = ""; strcat(str, $1); strcat(str, $2); $$ = str; }
	;

declaration: declaration_specifiers SEMICOLON				{ char str[256] = ""; strcat(str, $1); strcat(str, ";\n"); $$ = str; }
	| declaration_specifiers init_declarator_list SEMICOLON	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); strcat(str, ";\n"); $$ = str; }
	;

declaration_specifiers: type_specifier		{ $$ = $1; }
	| type_specifier declaration_specifiers	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	;

init_declarator_list: init_declarator				{ $$ = $1; }
	| init_declarator_list COMMA init_declarator	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

init_declarator: declarator			{ $$ = $1; }
	| declarator ASSIGN initializer	{ char str[256] = ""; strcat(str, $1); strcat(str, " = "); strcat(str, $3); $$ = str; }
	;

initializer: assignment_expression			{ $$ = $1; }
	| LBRACE initializer_list RBRACE		{ char str[256] = ""; strcat(str, "{"); strcat(str, $2); strcat(str, "}"); $$ = str; }
	| LBRACE initializer_list COMMA RBRACE	{ char str[256] = ""; strcat(str, "{"); strcat(str, $2); strcat(str, ", ") ;strcat(str, "}"); $$ = str; }
	;

initializer_list: initializer				{ $$ = $1; }
	| initializer_list COMMA initializer	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

assignment_expression: conditional_expression						{ $$ = $1; }
	| unary_expression assignment_operator assignment_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); strcat(str, " "); strcat(str, $3); $$ = str; }
	;

assignment_operator: ASSIGN	{ $$ = "="; }
	| MULT_ASSIGN			{ $$ = "*="; }
	| DIV_ASSIGN			{ $$ = "/="; }
	| MOD_ASSIGN			{ $$ = "%="; }
	| ADD_ASSIGN			{ $$ = "+="; }
	| SUB_ASSIGN			{ $$ = "-="; }
	;

unary_expression: postfix_expression	{ $$ = $1; }
	| INCREMENT unary_expression		{ char str[256] = ""; strcat(str, "++"); strcat(str, $2); $$ = str; }
	| DECREMENT unary_expression		{ char str[256] = ""; strcat(str, "--"); strcat(str, $2); $$ = str; }
	| unary_operator cast_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	;

unary_operator: PLUS	{ $$ = "+"; }
	| MINUS				{ $$ = "-"; }
	| NOT				{ $$ = "!"; }
	;

cast_expression: unary_expression				{ $$ = $1; }
	| LPAREN type_name RPAREN cast_expression	{ char str[256] = ""; strcat(str, "("); strcat(str, $2); strcat(str, ")"); strcat(str, $4); $$ = str; }
	;

type_name: specifier_qualifier_list			{ $$ = $1; }
	| specifier_qualifier_list declarator	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	;

specifier_qualifier_list: type_specifier specifier_qualifier_list	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	| type_specifier 												{ $$ = $1; }
	;

postfix_expression: primary_expression							{ $$ = $1; }
	| postfix_expression LBRACKET expression RBRACKET			{ char str[256] = ""; strcat(str, $1); strcat(str, "["); strcat(str, $3); strcat(str, "]"); $$ = str; }
	| postfix_expression LPAREN RPAREN							{ char str[256] = ""; strcat(str, $1); strcat(str, "("); strcat(str, ")"); $$ = str; }
	| postfix_expression LPAREN argument_expression_list RPAREN	{ char str[256] = ""; strcat(str, $1); strcat(str, "("); strcat(str, $3); strcat(str, ")"); $$ = str; }
	| postfix_expression INCREMENT								{ char str[256] = ""; strcat(str, $1); strcat(str, "++"); $$ = str; }
	| postfix_expression DECREMENT								{ char str[256] = ""; strcat(str, $1); strcat(str, "--"); $$ = str; }
	;

argument_expression_list: assignment_expression				{ $$ = $1; }
	| argument_expression_list COMMA assignment_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

expression: assignment_expression				{ $$ = $1; }
	| expression COMMA assignment_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

primary_expression: ID			{ $$ = $1; }
    | CONSTANT					{ $$ = $1; }
	| STRING					{ $$ = $1; }
	| LPAREN expression RPAREN	{ char str[256] = ""; strcat(str, "("); strcat(str, $2); strcat(str, ")"); $$ = str; }
	;

conditional_expression: logical_or_expression { $$ = $1; }
    ;

logical_or_expression: logical_and_expression				{ $$ = $1; }
	| logical_or_expression OR_OP logical_and_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " || "); strcat(str, $3); $$ = str; }
	;

logical_and_expression: inclusive_or_expression				{ $$ = $1; }
	| logical_and_expression AND_OP inclusive_or_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " && "); strcat(str, $3); $$ = str; }
	;

inclusive_or_expression: exclusive_or_expression			{ $$ = $1; }
	| inclusive_or_expression OR exclusive_or_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " | "); strcat(str, $3); $$ = str; }
	;

exclusive_or_expression: and_expression				{ $$ = $1; }
	| exclusive_or_expression XOR and_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " ^ "); strcat(str, $3); $$ = str; }
	;

and_expression: equality_expression				{ $$ = $1; }
	| and_expression AND equality_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " & "); strcat(str, $3); $$ = str; }
	;

equality_expression: relational_expression				{ $$ = $1; }
	| equality_expression EQUAL relational_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " == "); strcat(str, $3); $$ = str; }
	| equality_expression DIFF relational_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " != "); strcat(str, $3); $$ = str; }
	;

relational_expression: shift_expression							{ $$ = $1; }
	| relational_expression LESS_THAN shift_expression			{ char str[256] = ""; strcat(str, $1); strcat(str, " < "); strcat(str, $3); $$ = str; }
	| relational_expression MORE_THAN shift_expression			{ char str[256] = ""; strcat(str, $1); strcat(str, " > "); strcat(str, $3); $$ = str; }
	| relational_expression LESS_EQUAL_THAN shift_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " <= "); strcat(str, $3); $$ = str; }
	| relational_expression MORE_EQUAL_THAN shift_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " >= "); strcat(str, $3); $$ = str; }
	;

shift_expression: additive_expression	{ $$ = $1; }
    ;

additive_expression: multiplicative_expression				{ $$ = $1; }
	| additive_expression PLUS multiplicative_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " + "); strcat(str, $3); $$ = str; }
	| additive_expression MINUS multiplicative_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " - "); strcat(str, $3); $$ = str; }
	;

multiplicative_expression: cast_expression				{ $$ = $1; }
	| multiplicative_expression MULT cast_expression	{ char str[256] = ""; strcat(str, $1); strcat(str, " * "); strcat(str, $3); $$ = str; }
	| multiplicative_expression DIV cast_expression		{ char str[256] = ""; strcat(str, $1); strcat(str, " / "); strcat(str, $3); $$ = str; }
	| multiplicative_expression MOD cast_expression		{ char str[256] = ""; strcat(str, $1); strcat(str, " % "); strcat(str, $3); $$ = str; }
	;

type_specifier: VOID	{ $$ = "void"; }
	| CHAR				{ $$ = "char"; }
	| INT 				{ $$ = "int"; }
	| FLOAT				{ $$ = "float"; }
	;

declarator: direct_declarator { $$ = $1; }
	;

direct_declarator: ID											{ $$ = $1; }
	| LPAREN declarator RPAREN									{ char str[256] = ""; strcat(str, "("); strcat(str, $2); strcat(str, ")"); $$ = str; }
	| direct_declarator LBRACKET constant_expression RBRACKET	{ char str[256] = ""; strcat(str, $1); strcat(str, "["); strcat(str, $3); strcat(str, "]"); $$ = str; }
	| direct_declarator LBRACKET RBRACKET						{ char str[256] = ""; strcat(str, $1); strcat(str, "["); strcat(str, "]"); $$ = str; }
	| direct_declarator LPAREN parameter_list RPAREN 			{ char str[256] = ""; strcat(str, $1); strcat(str, "("); strcat(str, $3); strcat(str, ")"); $$ = str; }
	| direct_declarator LPAREN identifier_list RPAREN			{ char str[256] = ""; strcat(str, $1); strcat(str, "("); strcat(str, $3); strcat(str, ")"); $$ = str; }
	| direct_declarator LPAREN RPAREN							{ char str[256] = ""; strcat(str, $1); strcat(str, "("); strcat(str, ")"); $$ = str; }
	;

constant_expression: conditional_expression	{ $$ = $1; }
	;

parameter_list: parameter_declaration				{ $$ = $1; }
	| parameter_list COMMA parameter_declaration	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

parameter_declaration: declaration_specifiers declarator	{ char str[256] = ""; strcat(str, $1); strcat(str, " "); strcat(str, $2); $$ = str; }
	| declaration_specifiers								{ $$ = $1; }
	;

identifier_list: ID				{ $$ = $1; }
	| identifier_list COMMA ID	{ char str[256] = ""; strcat(str, $1); strcat(str, ", "); strcat(str, $3); $$ = str; }
	;

%%

int main (void) {
	return yyparse();
}
         
int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
