FC     = lfortran
FFLAGS = --openmp

all: test

# The compile is expected to fail, so `-` keeps make going and `test` stays
# useful as a demonstration rather than a gate. Use `make check` for a verdict.
test:
	@echo "=== named critical region (should FAIL to compile) ==="
	-$(FC) $(FFLAGS) -c repro.f90 -o repro.o

check:
	@./check.sh

clean:
	rm -f *.o *.mod repro

.PHONY: all test check clean
