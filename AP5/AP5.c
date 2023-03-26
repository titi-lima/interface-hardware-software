#include <omp.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 800 // change to a smaller number if the program segfaults

void initMatrix(int A[N][N], int B[N][N]) {
    srand(time(NULL));
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand() % 100;
            B[i][j] = rand() % 100;
        }
    }
}

int serialMultiplication(int A[][N], int B[][N], int C[][N]) {
    int evenNumbers = 0;
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            C[i][j] = 0;
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
            if (C[i][j] % 2 == 0) {
                evenNumbers++;
            }
        }
    }
    return evenNumbers;
}

int parallelMultiplication(int A[][N], int B[][N], int C[][N]) {
    int evenNumbers = 0;
#pragma omp parallel for reduction(+ \
                                   : evenNumbers)
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            C[i][j] = 0;
            for (int k = 0; k < N; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
            if (C[i][j] % 2 == 0) {
                evenNumbers++;
            }
        }
    }
    return evenNumbers;
}

int main() {
    int A[N][N], B[N][N], C[N][N];
    int evenNumbers;
    double startTime, endTime;

    initMatrix(A, B);

    printf("MULTIPLICACAO EM SERIE\n");
    startTime = omp_get_wtime();
    evenNumbers = serialMultiplication(A, B, C);
    endTime = omp_get_wtime();

    printf("Tempo: %.4fs\nNumeros pares: %d\n\n", endTime - startTime, evenNumbers);

    printf("MULTIPLICACAO EM PARALELO\n");
    startTime = omp_get_wtime();
    evenNumbers = parallelMultiplication(A, B, C);
    endTime = omp_get_wtime();

    printf("Tempo: %.4fs\nNumeros pares: %d\n\n", endTime - startTime, evenNumbers);
    return 0;
}

// ran with gcc -fopenmp AP5.c -o AP5 && ./AP5