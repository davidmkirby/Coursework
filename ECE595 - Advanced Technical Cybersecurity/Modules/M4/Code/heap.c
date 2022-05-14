#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define BUFFER_SIZE 32

struct function {
    int (*function)();
};

void print_smiley_face() {
    printf("\nI win :-)\n\n");
}

void print_frowny_face() {
    printf("\nI lose :-(\n\n");
}

int main(int argc, char **argv) {
    struct function *b;

    char *a = malloc(BUFFER_SIZE);
    b = malloc(sizeof(struct function));
    b->function = print_frowny_face;

    strcpy(a, argv[1]);

    b->function();

    return 0;
}