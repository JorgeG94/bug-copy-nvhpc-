# The `default` clause is rejected on a worksharing directive

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

## Reproduce

```console
$ lfortran --openmp -c repro.f90
semantic error: The clause default is not supported for parallel sections
  --> repro.f90:12:4
   |
12 |    !$omp parallel do default(shared) private(i) schedule(static)
   |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -fopenmp` accepts it (GNU Fortran 13.3.0). `default` is
OpenMP 2.0.

## See also

[`../lfortran_omp_default_none`](../lfortran_omp_default_none) is the same clause with
`none` as its argument, kept separate because the two differ in how much they
cost to work around: `default(shared)` is removable, since shared is already
the default for `parallel`, and `default(none)` is not.

## Where it was found

metalquicha `src/methods/ci/mqc_ci.f90:191`, and three other sites.
