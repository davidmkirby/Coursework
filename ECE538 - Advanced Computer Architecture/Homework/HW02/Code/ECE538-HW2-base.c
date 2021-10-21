#include <stdio.h>
#include <stdlib.h>
#include <time.h>
int main()
{
    clock_t t;
    int r = 1024, c = 1024; //Taking number of Rows and Columns
    int i,j;
    long (*X)[c] = malloc(sizeof(long[r][c])); //Dynamically Allocating Memory
    long (*Y)[c] = malloc(sizeof(long[r][c])); //Dynamically Allocating Memory

    for(i = 0;i < r;i++){
        for(j = 0; j < c; j++){
            X [i][j] = (long)(i*r+j);
            // printf("%d\t",X[i][j]);
        }
        // printf("\n");
    }


//   printf("\n\n");

    t = clock();
    for(i = 0;i < r;i++){
        for(j = 0; j < c; j++){
            Y [j][i] = X[i][j];
         }

    }

//    for(j = 0;j < c;j++){
//        for(i = 0; i < r; i++){
//            Y [j][i] = X[i][j];
//          }
//
//   }

    t = clock() -t;
    // for(i = 0;i < r;i++){
    //     for(j = 0; j < c; j++){
    //         printf("%d\t",Y[i][j]);

    //     }
    //     printf("\n");

    // }
    double time_taken = ((double)t)/CLOCKS_PER_SEC; // in seconds
    printf("Transpose using base code took %f seconds to execute \n", time_taken);

    free(X);
    free(Y);

}
