#include <string.h>

#define BUF_SIZE 5

void smash(char* arg) {
    char buffer[BUF_SIZE];
    strcpy(buffer, arg);
}

int main(int argc, char* argv[]) {
    char* arg = argv[1];
    smash(arg);
    return 0;
}
