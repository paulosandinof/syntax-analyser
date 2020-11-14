# syntax-analyser

Compile

lex lexer.l && yacc parser.y -d -v -g && gcc lex.yy.c y.tab.c -o a.out

Run

./a.out < input.txt