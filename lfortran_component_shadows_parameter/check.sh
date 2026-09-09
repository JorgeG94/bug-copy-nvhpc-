#!/usr/bin/env bash
# REPRODUCES if the bug is still present, FIXED if it is not.
cd "$(dirname "$0")" || exit 2
out=$(lfortran -c repro.f90 -o /dev/null 2>&1)
if grep -q "must reduce to a compile time constant" <<<"$out"; then
   echo REPRODUCES
else
   echo FIXED
fi
