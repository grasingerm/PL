#include <stdio.h>

static double int_pts_1[] = { 0.0 };
static double weights_1[] = { 2.0 };
static double int_pts_2[] = 
    { -0.5773502691896257, 0.5773502691896257 };
static double weights_2[] = { 1.0, 1.0 };
static double int_pts_3[] =
    { 0.0, -0.7745966692414834, 0.7745966692414834 };
static double weights_3[] = 
    { 0.8888888888888888, 0.5555555555555556, 0.5555555555555556 };
static double int_pts_4[] =
    { -0.3399810435848563, 0.3399810435848563, -0.8611363115940526, 
        0.8611363115940526 };
static double weights_4[] =
    { 0.6521451548625461, 0.6521451548625461, 0.3478548451374538,
        0.3478548451374538 };
static double int_pts_5[] =
    { 0.0, -0.5384693101056831, 0.5384693101056831, -0.9061798459386640,
        0.9061798459386640 };
static double weights_5[] =
    { 0.5688888888888889, 0.4786286704993665, 0.4786286704993665,
        0.2369268850561891, 0.2369268850561891 };
        
static double *int_pts[] = { int_pts_1, int_pts_2, int_pts_3,
    int_pts_4, int_pts_5 };
static double *weights[] = { weights_1, weights_2, weights_3,
    weights_4, weights_5 };
    
int main(int argc, char *argv[])
{
    double *ips;
    int num_pts = argc;
    int i;
    for (i = 0, ips = int_pts[num_pts-1]; i < num_pts; ips++, i++)
        printf("%lf\n", *ips);
    return 0;
}
