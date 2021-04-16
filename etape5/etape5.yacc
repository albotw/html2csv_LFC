%{
    #include <stdio.h>
    #include <string.h>
    #include "struct.h"

    extern char* yytext;
    int yyparse();
%}

%union { char* str; }

%token DEBTAB DEBLIG DEBCEL DEBCELENT DEBHEAD DEBBODY DEBCAP
%token FINTAB FINLIG FINCEL FINCELENT FINHEAD FINBODY FINCAP
%token <str> CONTENU


%start liste_tableaux

%%

liste_tableaux: //regle vide == lambda
| tableau liste_tableaux                                { }
;

tableau: DEBTAB legende headers body_no_header FINTAB   { X=0; Y=0; currentTab++;}
| DEBTAB legende body_with_header FINTAB                { X=0; Y=0; currentTab++;}
| DEBTAB legende body_no_header FINTAB                  { X=0; Y=0; currentTab++;}
| DEBTAB header body_no_header FINTAB                   { X=0; Y=0; currentTab++;}
| DEBTAB desc_no_header FINTAB                          { X=0; Y=0; currentTab++;}
| DEBTAB desc_with_header FINTAB                        { X=0; Y=0; currentTab++;}
;

legende: DEBCAP CONTENU FINCAP                          { X=0; currentType = 1; addElement(tab, $2);}
;

headers: DEBHEAD ligne_header FINHEAD                   { }
;

ligne_header: DEBLIG liste_header FINLIG                { Y++; X=0;}
;

liste_header: header                                    { }
| header liste_header                                   { }
;

header: DEBCELENT CONTENU FINCELENT                     { X++; currentType = 2; addElement(tab, $2);}
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

ligne:  DEBLIG liste_cells FINLIG                       { X=0; Y++;}
;

liste_cells: cell                                       { }
| cell liste_cells                                      { }
;

cell: DEBCEL CONTENU FINCEL                             { X++; currentType = 3; addElement(tab, $2);}
| DEBCEL tableau FINCEL                                 { printf("cellule avec tableau\n");}
;

%%


int yyerror(void)
{
    fprintf(stderr, "erreur de syntaxe\n");
    return 1;
}

extern FILE *yyin;

void convertTable(Array *a, FILE *fichier)
{
    int fileX = 1;
    int fileY = 1;

    for (int i = 0; i < a->size; i++)
    {
        Element *current = a->tab[i];
        if (i-1 > 0 && a->tab[i-1]->y != current->y)
        {
            fputs("\n", fichier);
        }

        if (i-1 > 0 && a->tab[i-1]->nbTab != current->nbTab)
        {
            fputs("\n", fichier);
        }

        fputs(current->text, fichier);
        
        if (i+1 < a->size && a->tab[i+1]->y == current->y)
        {
            fputs(";", fichier);
        }

        if (current->type == 1)
        {
            fputs("\n", fichier);
        }
    }
}

int main(void)
{
    X = 1;
    Y = 1;
    currentTab = 1;
    tab = (Array*)malloc(1 * sizeof(Array));
    initArray(tab, 5);
    yyin = stdin;
    yyparse();
    printArray(tab);

    FILE *f = fopen("output.csv", "w+");
    convertTable(tab, f);
    fclose(f);

    deleteArray(tab);
}