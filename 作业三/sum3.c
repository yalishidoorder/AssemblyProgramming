#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int main()
{
	int number, sum = 0;

	printf("please enter the number(1-100): ");
	scanf("%d", &number);

	
	for (int i = number; i <= 100; i++) {
		sum += i;
	}

	printf("sum: %d\n", sum);

	return 0;
}