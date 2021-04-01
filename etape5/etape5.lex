%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "struct.h"
    #include "etape5.tab.h"
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
{debut_tab}         {return DEBTAB;}
{fin_tab}           {return FINTAB;}
{debut_ligne}       {Y++; X=0; return DEBLIG;}
{fin_ligne}         {return FINLIG;}
{debut_cellule}     {X++; currentType = 3; BEGIN(contenu); return DEBCEL;}
{fin_cellule}       {BEGIN(INITIAL); return FINCEL;}
{debut_tetes}       {return DEBHEAD;}
{fin_tetes}         {return FINHEAD;}
{debut_corps}       {return DEBBODY;}
{fin_corps}         {return FINBODY;}
{debut_legende}     {currentType = 1; BEGIN(contenu); return DEBCAP;}
{fin_legende}       {BEGIN(INITIAL); return FINCAP;}
{debut_tete}        {X++; currentType = 2; BEGIN(contenu); return DEBCELENT;}
{fin_tete}          {BEGIN(INITIAL);  return FINCELENT;}
<contenu>(.|[^\<]+) {addElement(tab, yytext); return CONTENU;}
.|\n                ;
%%