#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>

int main()
{
	char output_prompt[] = "The 9mul9 table:";

	printf("%s\n", output_prompt);

	for (int row = 9; row >= 1; row--) {
		for (int col = 1; col <= row; col++) {
			printf("%dx%d=%-4d  ", row, col, row * col);
		}

		printf("\n");
	}

	return 0;
}