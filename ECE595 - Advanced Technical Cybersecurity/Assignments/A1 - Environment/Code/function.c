#include<stdio.h>

void function_1(int x){
    printf("function 1, cnt = %d\n", x);
}

void function_2(int x){
    printf("function 2, cnt = %d\n", x);
}

int main() {
    int i;
    for ( i = 0; i < 5; ++i ){
        function_1(i);
    }

    int j = 0;
    while ( j < 5 ){
        function_2(j);
        ++j;
    }
    return 0;
}