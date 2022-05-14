// Allocating two buffers of the same size then copies information from the command line into the first buffer then frees the buffers and returns.

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define BUFFER_SIZE 32

int main(int argc, char** argv) 
{
    char *a = malloc(BUFFER_SIZE);
    char *b = malloc(BUFFER_SIZE);
    
    strcpy(a, argv[1]);
    
    free(a);
    free(b);
    
    return 0;
}