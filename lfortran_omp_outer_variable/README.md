# Referencing an enclosing-scope variable inside an OpenMP region crashes the compiler

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

Any mention of a variable from the surrounding scope inside `!$omp parallel`
segfaults the compiler. A **read** is enough: no assignment, no `critical`, no
`reduction`.

## Reproduce

```console
$ lfortran --openmp -c repro.f90
Segmentation fault (core dumped)          # exit 139
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## The control

`control.f90` is the same region with no enclosing-scope variable in it, and it
compiles. That is the whole of the difference between the two files:

```console
$ lfortran --openmp -c control.f90        # exit 0
```

`check.sh` compiles the control first and reports `INCONCLUSIVE` if it ever
stops working, since the pair is only meaningful together.

## Expected

A compile. `gfortran -fopenmp` accepts both (GNU Fortran 13.3.0).

## Narrowed

- A read (`print *, total`) is enough; no write is needed.
- Naming the variable explicitly, `shared(total)`, does not change it.
- `parallel do` behaves the same as `parallel`.
- It is a crash, not a diagnostic -- there is no error message to work from.

## Why it matters most

This one is not worked around. It makes `--openmp` unusable for any real
program, because a parallel region that touches nothing outside itself computes
nothing.
