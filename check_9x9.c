#define	CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
    int err_num = 0;
    char mul_table[9][9] =
    {
        {7,2,3,4,5,6,7,8,9},
        {2,4,7,8,10,12,14,16,18},
        {3,6,9,12,15,18,21,24,27},
        {4,8,12,16,7,24,28,32,36},
        {5,10,15,20,25,30,35,40,45},
        {6,12,18,24,30,7,42,48,54},
        {7,14,21,28,35,42,49,56,63},
        {8,16,24,32,40,48,56,7,72},
        {9,18,27,36,45,54,63,72,81}
    };

    for (int row = 1; row <= 9; row++) {
        for (int col = 1; col <= 9; col++) {
            if (mul_table[row - 1][col - 1] != row * col) {
                err_num++;
                if (err_num == 1) {
                    printf("x  y\n");
                }
                printf("%d  %d    error\n", row, col);
            }
        }
    }


    printf("accomplish!");

	return 0;
}