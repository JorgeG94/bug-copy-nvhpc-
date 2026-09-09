# ICE: a derived-type parameter whose value is a structure constructor

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

`visit_StructConstructor() not implemented`. The module defining the parameter
compiles; the crash comes at the **use** site, on a declaration.

## Reproduce

```console
$ lfortran -c repro.f90
Internal Compiler Error: Unhandled exception
Traceback (most recent call last):
  ...
LCompilersException: visit_StructConstructor() not implemented
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -c repro.f90` accepts it (GNU Fortran 13.3.0).

## What makes it hard to find from the message

There is no structure constructor in the program unit that dies. The chain is:

1. a module declares `type(inner_t), parameter :: INNER_NULL = inner_t(0)`
2. another type defaults a component to that parameter
3. a program declares a variable of *that* type -- and crashes

Initializing the component with an inline `inner_t(0)` instead of the named
constant compiles, so the constructor itself is not the problem; the constant
standing in for one is.

## Not OpenMP

No `--openmp` needed.

## Where it was found

metalquicha. `libmetalquicha.a` -- 314 objects, the whole ab initio backend
included -- archives, and then `app/main.f90` dies on
`type(resources_t) :: resources`. That reaches `MPI_COMM_NULL = MPI_Comm(0)` in
pic-mpi's single-rank backend, three types down. This is the last thing between
that project and a linked binary.
