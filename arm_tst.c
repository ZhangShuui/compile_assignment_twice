#include <stdio.h>
 
int factorial(int n)
{
	int m = 1;
	for (int i = 1; i <= n; i++){
		m *= i;
	}
    return m;
}
int C(int n, int m)
{
	return factorial(n) / (factorial(m)*factorial(n - m));
}
 
int main()
{
	printf("%d\n",C(10,2));
	return 0;
}