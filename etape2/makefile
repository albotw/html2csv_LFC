LFC_reflex : etape2.lex
	REflex/bin/reflex -d etape2.lex
	g++ -oLFC lex.yy.cpp -IREflex/include REflex/lib/libreflex.a

LFC : etape2.lex
	flex etape2.lex
	gcc -oLFC lex.yy.c -lfl -lc