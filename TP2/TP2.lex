%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stddef.h>
    int yylex();

    typedef struct
    {
        int type; // 0 = contenu | 1 -> legende
        int tabID; //identifiant du tableau qui contient le symbole.
        int x;
        int y;
        char* text;
    } Symbole;

    typedef struct 
    { 
        size_t size;    //taille actuelle du tableau
        size_t capacite;    //capacité maximale du tableau.
        Symbole** tab;   //tableau contenant les symboles
    } Array;

    int X = 0;
    int Y = 0;
    int currentTab = 0;
    int currentType = 0;
    Array* tab;

    void initArray(Array* a, size_t tailleInit)
    {
        a->tab = (Symbole**)malloc(tailleInit * sizeof(Symbole*));
        a->size = 0;
        a->capacite = tailleInit;
    }

    void addSymbole(Array* a, char* value)
    {
        Symbole* s = (Symbole*)malloc(1 * sizeof(Symbole));
        s->x = X;
        s->y = Y;
        s->type = currentType;
        s->text = (char*)malloc(yyleng*sizeof(char));
        strcpy(s->text, value);

        if (a->size == a->capacite)
        {
            a->size *= 2;
            a->tab = (Symbole**)realloc(a->tab, a->size * sizeof(Symbole*));
        }
        a->tab[a->size++] = s;
    }

    void printArray(Array* a)
    {
        printf("\n");
        for (int i = 0; i < a->size; i++)
        {
            printf("%s", a->tab[i]->text);
            printf(" x:%d",a->tab[i]->x);
            printf(" y:%d",a->tab[i]->y);
            printf(" type:%d",a->tab[i]->type);
            printf("\n");
        }
    }

    void deleteArray(Array* a)
    {
        free(a->tab);
        a->tab = NULL;
        a->size = a->capacite = 0;
    }

    
%}
%s contenu

debut_tab       <table(.|[^\<]*)>
fin_tab         "</table>"
debut_ligne     <tr(.|[^\<]*)>
fin_ligne       "</tr>"
debut_cellule   <td(.|[^\<]*)>
fin_cellule     "</td>"
debut_tetes     <thead(.|[^\<]*)>
fin_tetes       "</thead>"
debut_tete      <th(.|[^\<]*)>
fin_tete        "</th>"
debut_corps     <tbody(.|[^\<]*)>
fin_corps       "</tbody>"
debut_legende   <caption(.|[^\<]*)>
fin_legende     "</caption>"

%%
{debut_tab}         {printf("debut de tableau\n");}
{fin_tab}           {printf("fin de tableau\n");}
{debut_ligne}       {printf("debut de ligne\n"); Y++; X=0;}
{fin_ligne}         {printf("fin de ligne\n");}
{debut_cellule}     {printf("debut de cellule\n"); X++; currentType=2;BEGIN(contenu);}
{fin_cellule}       {printf("fin de cellule\n"); currentType=0; BEGIN(INITIAL);}
{debut_tetes}       {printf("debut des en-tetes\n");}
{fin_tetes}         {printf("fin des en-tetes\n");}
{debut_corps}       {printf("debut corps\n");}
{fin_corps}         {printf("fin corps\n");}
{debut_legende}     {printf("debut legende\n"); currentType=1; BEGIN(contenu);}
{fin_legende}       {printf("fin legende\n"); currentType=0; BEGIN(INITIAL);}
{debut_tete}        {printf("debut cellule en tete\n"); currentType=3; BEGIN(contenu);}
{fin_tete}          {printf("fin cellule en tete\n"); currentType=0; BEGIN(INITIAL);}
<contenu>([^\<]+)      {printf("contenu de cellule\n"); addSymbole(tab, yytext);}
.|\n                ;
%%

int main() {
    tab = (Array*)malloc(1 * sizeof(Array));
    initArray(tab, 10);
    yylex();
    printArray(tab);
    deleteArray(tab);
}