#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main()
{
    clock_t t;
    int r = 1024, c = 1024; //Taking number of Rows and Columns
    int i,j,k,l;
    long (*X)[c] = malloc(sizeof(long[r][c])); //Dynamically Allocating Memory
    long (*Y)[c] = malloc(sizeof(long[r][c])); //Dynamically Allocating Memory
    int b = 8;

    for(i = 0;i < r;i++){
        for(j = 0; j < c; j++){
            X [i][j] = (long)(i*r+j);
            // printf("%d\t",X[i][j]);
        }
        // printf("\n");
    }


//   printf("\n\n");

    t = clock();

    for (i = 0; i < r; i += b) {
        for (j = 0; j < c; j += b) {
            // transpose the block beginning at [i,j]
            for (k = i; k < i + b; k++) {
                for (l = j; l < j + b; l++) {
                    Y[l][k] = X[k][l];
                }
            }
        }
    }

    t = clock() -t;

    double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds
    printf("Transpose using blocking took %f seconds to execute \n", time_taken);

    free(X);
    free(Y);

}
