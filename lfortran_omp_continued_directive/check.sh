#!/usr/bin/env bash
# REPRODUCES if the bug is still present, FIXED if it is not.
cd "$(dirname "$0")" || exit 2
out=$(lfortran --openmp -c repro.f90 -o /dev/null 2>&1)
if grep -q "The clause & is not supported" <<<"$out"; then
   echo REPRODUCES
else
   echo FIXED
fi
