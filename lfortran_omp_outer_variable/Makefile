FC     = lfortran
FFLAGS = --openmp

all: test

# control.f90 must keep compiling: it is the same region with no
# enclosing-scope variable in it, and it is what makes the pair an argument.
test:
	@echo "=== control: region with no outer variable (should COMPILE) ==="
	$(FC) $(FFLAGS) -c control.f90 -o control.o
	@echo ""
	@echo "=== repro: same region, reads an outer variable (should SEGFAULT) ==="
	-$(FC) $(FFLAGS) -c repro.f90 -o repro.o

check:
	@./check.sh

clean:
	rm -f *.o *.mod

.PHONY: all test check clean
