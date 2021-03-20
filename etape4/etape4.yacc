%{
    #include <stdio.h>
    #include <string.h>
    int yyparse();
%}


%token DEBTAB DEBLIG DEBCEL DEBCELENT DEBHEAD DEBBODY DEBCAP
%token FINTAB FINLIG FINCEL FINCELENT FINHEAD FINBODY FINCAP
%token CONTENU

%start liste_tableaux

%%

liste_tableaux: //regle vide == lambda
| tableau liste_tableaux                                { }
;

tableau: DEBTAB legende headers body_no_header FINTAB   {  }
| DEBTAB legende body_with_header FINTAB                {  }
| DEBTAB legende body_no_header FINTAB                  {  }
| DEBTAB header body_no_header FINTAB                   {  }
| DEBTAB desc_no_header FINTAB                          {  }
| DEBTAB desc_with_header FINTAB                        {  }
;

legende: DEBCAP CONTENU FINCAP                          { printf("légende\n");}
;

headers: DEBHEAD ligne_header FINHEAD                   { }
;

ligne_header: DEBLIG liste_header FINLIG                { }
;

liste_header: header                                    { }
| header liste_header                                   { }
;

header: DEBCELENT CONTENU FINCELENT                     { printf("cellule d'en-tête\n");}
;

body_with_header: DEBBODY desc_with_header FINBODY      { }
;

body_no_header: DEBBODY desc_no_header FINBODY          { }
;

desc_with_header: ligne_header liste_lignes             { }
;

desc_no_header: liste_lignes                            { }
;

liste_lignes: ligne                                     { }
| ligne liste_lignes                                    { }
;

ligne:  DEBLIG liste_cells FINLIG                       { }
;

liste_cells: cell                                       { }
| cell liste_cells                                      { }
;

cell: DEBCEL CONTENU FINCEL                             { printf("cellule avec contenu\n");}
| DEBCEL tableau FINCEL                                 { printf("cellule avec tableau\n");}
;

%%

int yyerror(void)
{
    fprintf(stderr, "erreur de syntaxe\n");
    return 1;
}

extern FILE *yyin;

int main(void)
{
    yyin = stdin;
    yyparse();
}