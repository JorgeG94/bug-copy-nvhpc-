# A component cannot be default-initialized from a parameter of the same name

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

Fortran is case-insensitive, so `GRID_LEVEL` and `grid_level` are one name. The
initializer appears to resolve to the component being declared rather than to
the module parameter, and so stops being constant.

## Reproduce

```console
$ lfortran -c repro.f90
semantic error: Initialization of `grid_level` must reduce to a compile time constant.
  --> repro.f90:18:7
   |
18 |       integer :: grid_level = GRID_LEVEL
   |       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

A compile. `gfortran -c repro.f90` accepts it (GNU Fortran 13.3.0). The
parameter is in scope in the derived-type definition and is a constant
expression; the component name is not a variable that could shadow it.

## The control is in the same file

`ok_t` initializes from the same parameter under a different component name and
compiles. Renaming the component is the workaround, and it is the only one --
which is a poor trade when the matching names are deliberate (a component and
the named default it takes).

## Not OpenMP

No `--openmp` needed. This one and
[`../lfortran_struct_constructor_ice`](../lfortran_struct_constructor_ice) are what remain
after OpenMP is taken out of the picture entirely.

## Where it was found

metalquicha `backends/cenzontle/dft/mqc_czt_xc.F90:127` --
`integer :: nlc_grid_level = NLC_GRID_LEVEL`.
