# `default(none)` is rejected

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

## Reproduce

```console
$ lfortran --openmp -c repro.f90
semantic error: The clause default is not supported for parallel sections
  --> repro.f90:15:4
   |
15 |    !$omp parallel do default(none) shared(a, n) private(i)
   |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -fopenmp` accepts it (GNU Fortran 13.3.0).

## Kept separate from `lfortran_omp_default_clause` deliberately

Same clause, same message, but the two are not equally severe.
`default(shared)` can be deleted with no change in meaning -- shared is already
the default for `parallel`. `default(none)` cannot: it exists to make the
compiler reject any variable that was not classified on purpose, so removing it
does not preserve the program's guarantees, it discards the check that a data
race was ruled out by hand. A codebase that writes `default(none)` is relying
on it.

## Where it was found

metalquicha `src/methods/dft/mqc_dft_partition.f90:257`.
