#include <stdio.h>

#include <stddef.h>
#include "alblas.h"

int main() {
	float alpha = 3.0;
	float beta = 2.0;
	float gamma = 1.0;
	// First test case: Pass a null pointer
	printf( "Test case 1: Passing a null pointer to sscal().\n" );
	float* a = NULL;
	sscal( 10, 1, a, 1 );
	// Second test case: Pass a zero length array
	printf( "Test case 2: Passing a zero length array to sscal().\n" );
	sscal( 0, 1, a, 1 );
	// Third test case: One length array
	printf( "Test case 3: Passing a one length array to sscal().\n" );
	float b[] = {beta};
	sscal( 1, alpha, b, gamma );
	printf( "Desired output of %g * %g + %g: %g\n", alpha, beta, gamma, alpha * beta + gamma );
	printf( "Output of %g * %g + %g: %g\n", alpha, beta, gamma, b[0] );
	// Fourth test case: Two length array
	printf( "Test case 4: Passing a two length array to sscal().\n" );
	float c[] = {0, 2};
	printf( "Desired output of %g * %g + %g: %g\n", alpha, c[0], gamma, alpha * c[0] + gamma );
	printf( "Desired output of %g * %g + %g: %g\n", alpha, c[1], gamma, alpha * c[1] + gamma );
	sscal( 2, alpha, c, gamma );
	printf( "Output of %g * %g + %g: %g\n", alpha, c[0], gamma, c[0] );
	printf( "Output of %g * %g + %g: %g\n", alpha, c[1], gamma, c[1] );
	// Fifth test case: Three length array
	printf( "Test case 5: Passing a three length array to sscal().\n" );
	float d[] = {0, 2, 4};
	printf( "Desired output of %g * %g + %g: %g\n", 
		alpha, d[0], gamma, alpha * d[0] + gamma );
	printf( "Desired output of %g * %g + %g: %g\n", 
		alpha, d[1], gamma, alpha * d[1] + gamma );
	printf( "Desired output of %g * %g + %g: %g\n", 
		alpha, d[2], gamma, alpha * d[2] + gamma );
	sscal( 2, alpha, d, gamma );
	printf( "Output of %g * %g + %g: %g\n", alpha, d[0], gamma, d[0] );
	printf( "Output of %g * %g + %g: %g\n", alpha, d[1], gamma, d[1] );
	printf( "Output of %g * %g + %g: %g\n", alpha, d[2], gamma, d[2] );
}
