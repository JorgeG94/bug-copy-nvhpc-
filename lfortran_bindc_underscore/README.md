# `--mangle-underscore-external` mangles `bind(C)` names that have no `name=`

**Compiler:** LFortran 0.64.0 · **Status:** open · **Upstream issue:** _not filed yet_

An interoperable procedure declared `bind(C)` with no explicit binding label
takes the lowercased Fortran name as its label, with no trailing underscore.
Under `--mangle-underscore-external` it gets one, and no longer resolves against
the C library it is meant to call.

## Reproduce

This one compiles either way -- the defect is in the emitted symbol, so read the
object file rather than the exit code.

```console
$ lfortran --mangle-underscore-external -c repro.f90 -o m.o
$ nm m.o | grep my_c_fn
                 U my_c_fn_          # wrong: the C symbol is my_c_fn

$ lfortran -c repro.f90 -o m.o       # without the flag
$ nm m.o | grep my_c_fn
                 U my_c_fn           # correct

$ gfortran -c repro.f90 -o m.o       # GNU Fortran 13.3.0, for reference
$ nm m.o | grep my_c_fn
                 U my_c_fn
```

Or `make test` for the demonstration, `make check` for a one-word
verdict -- `./check.sh` prints `REPRODUCES` or `FIXED`.

## Expected

`bind(C)` names should be exempt from the flag, exactly as
`bind(C, name="my_c_fn")` already is -- spelling the label out explicitly
produces the right symbol today, so the two forms disagree where the standard
says they mean the same thing.

## Why the flag is in use at all

It is not gratuitous. LFortran calls a plain external procedure by its bare
name, while every BLAS built by a conventional Fortran compiler exports
`dgemm_`; without `--mangle-underscore-external` nothing links against
libopenblas, and CMake's `FindBLAS` reports the library as not working. So a
project that needs the flag for its BLAS gets wrong symbols for its C interop,
and there is no setting that serves both.

## Where it was found

metalquicha. libxc's Fortran interface is written `bind(c)` with no `name=`
throughout, so its example programs fail to link with undefined references to
`xc_func_end_`, `xc_func_init_`, `xc_func_get_info_` and the rest.
