#define _CRT_SECURE_NO_WARNINGS 
#include <stdio.h>

int main(void)
{
	char ascii ='a';
	for (int i = 1; i <= 26; i++) {
		printf("%c ", ascii);
		ascii++;
		if (i % 13 == 0) {
			printf("\n");
		}
	}

	return 0;
}