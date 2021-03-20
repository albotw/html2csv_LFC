etape4: etape4.yacc etape4.lex
	bison -d -v etape4.yacc
	flex etape4.lex
	mv etape4.tab.hacc etape4.tab.h
	mv etape4.tab.cacc etape4.tab.c
	gcc -o etape4 etape4.tab.c etape4.tab.h lex.yy.c -lfl -lc