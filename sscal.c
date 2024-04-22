#include <stddef.h>

void sscal(int N, float ALPHA, float *X, float INCX) {
	// N must be a positive integer, not including zero
	if ( N <= 0 )
		return;
	// *X must not be null
	if ( X == NULL )
		return;
	for( int i = 0; i < N; i++ )
		X[i] = ALPHA * X[i] + INCX;
}
