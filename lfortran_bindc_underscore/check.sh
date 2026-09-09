#!/usr/bin/env bash
# REPRODUCES if the bug is still present, FIXED if it is not.
#
# This one compiles either way -- the defect is in the emitted symbol, so the
# check reads the object file rather than the exit code.
cd "$(dirname "$0")" || exit 2
obj=$(mktemp --suffix=.o) || exit 2
trap 'rm -f "$obj"' EXIT
lfortran --mangle-underscore-external -c repro.f90 -o "$obj" >/dev/null 2>&1 || {
   echo "INCONCLUSIVE (repro.f90 no longer compiles)"; exit 0; }
if nm "$obj" | grep -q "my_c_fn_"; then
   echo REPRODUCES
else
   echo FIXED
fi
