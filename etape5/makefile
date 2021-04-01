etape5: etape5.yacc etape5.lex struct.c struct.h
	bison -d -v etape5.yacc
	flex etape5.lex
	mv etape5.tab.hacc etape5.tab.h
	mv etape5.tab.cacc etape5.tab.c
	gcc -o etape5 etape5.tab.c etape5.tab.h lex.yy.c struct.h struct.c -lfl -lc