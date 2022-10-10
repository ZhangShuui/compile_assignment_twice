#include <stdio.h>
int fibo(int n){
    if (n==1||n==0){
        return 1;
    }
    return fibo(n-1) + fibo(n-2);
}
int main(){
    int k = fibo(5);
    printf("%d",k);
    return 0;
}