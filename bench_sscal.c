#include "alblas.h"
#include <stdlib.h>

int main() {
	const float n = 200000000;
	float* x = (float*) malloc( sizeof(float) * n );
	sscal( n, 1, x, 1 );
	free( x );
	return 0;
}
