#include "struct.h"

extern int yyleng;

void initArray(Array *a, size_t tailleInit)
{
    a->tab = (Element **)malloc(tailleInit * sizeof(Element *));
    a->size = 0;
    a->capacite = tailleInit;
}

void addElement(Array *a, char *value)
{
    Element *s = (Element *)malloc(1 * sizeof(Element));
    s->x = X;
    s->y = Y;
    s->type = currentType;
    s->nbTab = currentTab;
    s->text = (char *)malloc(yyleng * sizeof(char));
    strcpy(s->text, value);

    if (a->size == a->capacite)
    {
        a->capacite *= 2;
        a->tab = (Element **)realloc(a->tab, a->capacite * sizeof(Element *));
    }

    a->tab[a->size++] = s;
}

void printArray(Array *a)
{
    printf("\n");
    for (int i = 0; i < a->size; i++)
    {
        printf("%s", a->tab[i]->text);
        printf(" x:%d", a->tab[i]->x);
        printf(" y:%d", a->tab[i]->y);
        printf(" type:%d", a->tab[i]->type);
        printf(" nbTab:%d", a->tab[i]->nbTab);
        printf("\n");
    }
}

void deleteArray(Array *a)
{
    for (int i = 0; i < a->size; i++)
    {
        free(a->tab[i]->text);
        free(a->tab[i]);
    }
    free(a->tab);
    a->tab = NULL;
    a->size = a->capacite = 0;
}
