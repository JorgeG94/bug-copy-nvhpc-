# Fortran compiler bugs

Minimal reproducers for Fortran compiler bugs, one directory each, with a
`Makefile` and a `README.md` per case.

It started with large `real(dp)` bracket `[]` array constructors in module
variable initializers, which is what the first three below are.

## Bugs

| Directory | Compiler | Bug | MRE size |
|---|---|---|---|
| `reshape_bug_nvfortran/` | nvfortran 26.1 | `fort1 TERMINATED by signal 11` on `reshape()` | 88K elements (2.9 MB) |
| `token_bug_ifx/` | ifx | Max token size exceeded (41k limit) | 1.56M elements (51 MB) |
| `modulo_int64_target/` | nvfortran 26.3 | `modulo(int64)` inside OpenMP/OpenACC target — `pgf90_i8modulov_i8 not supported` | tiny |

## LFortran 0.64.0

Eight cases, all found while trying to build
[metalquicha](https://github.com/JorgeG94/metalquicha). Every one compiles under
gfortran 13.3.0, which each README records as its control. None filed upstream
yet -- each README has an `Upstream issue` line to fill in.

| Directory | `--openmp` | Bug | How it fails |
|---|:---:|---|---|
| `lfortran_omp_named_critical/` | yes | `!$omp critical (name)` | semantic error |
| `lfortran_omp_outer_variable/` | yes | enclosing-scope variable read inside a region | **segfault** |
| `lfortran_omp_default_clause/` | yes | `default(shared)` | semantic error |
| `lfortran_omp_continued_directive/` | yes | directive continued with `&` | semantic error |
| `lfortran_omp_default_none/` | yes | `default(none)` | semantic error |
| `lfortran_component_shadows_parameter/` | no | component named like its initializer | semantic error |
| `lfortran_struct_constructor_ice/` | no | derived-type parameter from a constructor | **ICE** |
| `lfortran_bindc_underscore/` | no | `bind(C)` symbol gets a trailing underscore | wrong symbol, links nothing |

`lfortran_omp_outer_variable` is the one that matters most: it makes `--openmp`
unusable for any real program, since a parallel region that touches nothing
outside itself computes nothing. `lfortran_omp_continued_directive` has the
widest reach in real code, being a matter of directive formatting rather than
of feature use -- 359 of them across 23 files in the project these came from.
The last three are what is left when OpenMP is taken out entirely.

## Quick start

Each directory has its own `Makefile`, `test.F90`, and `README.md`.

```bash
cd reshape_bug_nvfortran
FC=nvfortran make test    # sefaults the compiler

cd ../token_bug_ifx
FC=ifx make test          # does not compile

cd ../lfortran_omp_continued_directive
make test                 # does not compile
make check                # REPRODUCES, or FIXED once it is
```

The LFortran directories also carry a `check.sh` that prints `REPRODUCES` or
`FIXED`, so a whole compiler release can be re-checked at once:

```bash
./run.sh                  # every case that has one
./run.sh lfortran_omp_continued_directive
```

`run.sh` exits non-zero while anything still reproduces.

## Compilers that handle both cases

| Compiler | Notes |
|---|---|
| flang 21.1.3 | No issues |
| gfortran | Needs `-fmax-array-constructor=N` flag |
