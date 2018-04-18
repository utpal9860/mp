// rootsc.c
#include <stdio.h>

int main(void)
{
        double a,b,c,root1,root2;
        extern int _roots(double,double,double,double*,double*);
        printf("Enter coefficients: ");
        scanf("%lf %lf %lf",&a,&b,&c);
        if(_roots(a,b,c,&root1,&root2))
                printf("Root1 = %lf and root2 = %lf\n", root1, root2);
        else
                printf("Root1 = %lfi and root2 = %lfi\n", root1, root2);
        return 0;
}
