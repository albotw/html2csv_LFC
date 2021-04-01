#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>

typedef struct
{
    int x;
    int y;
    int type;
    char *text;
} Element;

typedef struct
{
    size_t size;
    size_t capacite;
    Element **tab;
} Array;

int X;
int Y;
int currentType;
Array *tab;

void initArray(Array *a, size_t tailleInit);
void addElement(Array *a, char *value);
void printArray(Array *a);
void deleteArray(Array *a);
