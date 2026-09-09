FC     = lfortran
FFLAGS = --mangle-underscore-external

all: test

# This one compiles either way -- the defect is the emitted symbol, so the
# demonstration is a pair of nm listings rather than a failing compile.
test:
	@echo "=== with --mangle-underscore-external (WRONG: expect my_c_fn_) ==="
	$(FC) $(FFLAGS) -c repro.f90 -o with_flag.o
	@nm with_flag.o | grep my_c_fn
	@echo ""
	@echo "=== without it (correct: expect my_c_fn) ==="
	$(FC) -c repro.f90 -o without_flag.o
	@nm without_flag.o | grep my_c_fn

check:
	@./check.sh

clean:
	rm -f *.o *.mod

.PHONY: all test check clean
