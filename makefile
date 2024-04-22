COMP=gcc
FLAGS=-Wall -O0

all: bench_sscal.out test_sscal.out

sscal.o: sscal.s
	${COMP} ${FLAGS} -c -o $@ $^

sscal.s: sscal.c
	${COMP} ${FLAGS} -S -o $@ $^

bench_sscal.o: bench_sscal.c
	${COMP} ${FLAGS} -c -o $@ $^
bench_sscal.out: sscal.o bench_sscal.o
	${COMP} ${FLAGS} -o $@ $^

test_sscal.o: test_sscal.c
	${COMP} ${FLAGS} -c -o $@ $^
test_sscal.out: sscal.o test_sscal.o
	${COMP} ${FLAGS} -o $@ $^

clean: 
	rm -r -f *.o *.out
