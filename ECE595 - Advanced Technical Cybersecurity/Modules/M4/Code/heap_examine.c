#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFFER_SIZE 32

int main(int argc, char** argv) 
{
    char *a = malloc(BUFFER_SIZE);
    char *b = malloc(BUFFER_SIZE);
    char *c = malloc(BUFFER_SIZE);
    char *d = malloc(BUFFER_SIZE);
    
    strcpy(c, argv[1]);
    
    free(d);
    free(c);
    free(b);
    free(a);
    
    return 0;
}