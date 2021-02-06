%{
    #include <stdio.h>
    #include <stdlib.h>
    int yylex();
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
{debut_ligne}       {printf("debut de ligne\n");}
{fin_ligne}         {printf("fin de ligne\n");}
{debut_cellule}     {printf("debut de cellule\n"); BEGIN(contenu);}
{fin_cellule}       {printf("fin de cellule\n"); BEGIN(INITIAL);}
{debut_tetes}       {printf("debut des en-tetes\n");}
{fin_tetes}         {printf("fin des en-tetes\n");}
{debut_corps}       {printf("debut corps\n");}
{fin_corps}         {printf("fin corps\n");}
{debut_legende}     {printf("debut legende\n"); BEGIN(contenu);}
{fin_legende}       {printf("fin legende\n"); BEGIN(INITIAL);}
{debut_tete}        {printf("debut cellule en tete\n"); BEGIN(contenu);}
{fin_tete}          {printf("fin cellule en tete\n"); BEGIN(INITIAL);}
<contenu>(.|[^\<]+)      {printf("contenu de cellule: "); printf("%s\n", yytext);}
.|\n                ;
%%

int main() {
    yylex();
}