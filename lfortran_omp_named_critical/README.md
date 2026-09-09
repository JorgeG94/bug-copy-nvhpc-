# A named OpenMP `critical` region is rejected

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

`!$omp critical (name)` is refused. The error names no clause, because the
thing it is objecting to is the region's name.

## Reproduce

```console
$ lfortran --openmp -c repro.f90
semantic error: The clause  is not supported for parallel sections
  --> repro.f90:14:4
   |
14 |    !$omp critical (accumulate)
   |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -fopenmp -c repro.f90` accepts it (tested with GNU Fortran
13.3.0). Naming a critical region is OpenMP 2.0 and is how two independent
critical sections avoid serialising against each other -- unnamed regions all
share one lock, so dropping the name is a correctness-neutral but
performance-destroying workaround, not a fix.

## Independent of the others

Removing `(accumulate)` clears *this* error and then hits
[`../lfortran_omp_outer_variable`](../lfortran_omp_outer_variable), which is a
separate defect.

## Where it was found

metalquicha, via libfint (`src/cint_tab_jacobi_ext.f90:41`), which is the CPU
integrals library and not optional. This is the error that stops a
`--openmp` build of that dependency.
