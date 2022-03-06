#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        exit(0);
    }
    char* varname = argv[1];
    char* ptr = getenv(varname);
    printf("%p\n", ptr);
}
