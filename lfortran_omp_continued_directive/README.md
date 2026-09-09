# An OpenMP directive continued onto a second line is rejected

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

The trailing `&` is read as a clause name rather than as the line continuation
it is, so the second `!$omp` line is never joined to the first.

## Reproduce

```console
$ lfortran --openmp -c repro.f90
semantic error: The clause & is not supported for parallel sections
  --> repro.f90:16:4
   |
16 |    !$omp parallel do schedule(static) &
   |    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -fopenmp` accepts it (GNU Fortran 13.3.0). Continuing a
directive is how any directive with more than two or three clauses is written,
and a `private` list of a dozen names does not fit on one line.

## Why this is the one with the widest reach

Of the OpenMP defects here this is the one that touches the most code, because
it is a matter of formatting rather than of feature use. In metalquicha it is
**359 continued directives across 23 files** in `src/` and
`backends/cenzontle/`. Nearly every OpenMP region in that codebase goes through
it, which is what made a build with OpenMP turned off entirely the only shape
worth attempting.
