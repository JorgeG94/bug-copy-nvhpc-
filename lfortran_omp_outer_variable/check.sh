#!/usr/bin/env bash
# REPRODUCES if the bug is still present, FIXED if it is not.
#
# The control must keep compiling; if it does not, something else is wrong and
# this case is no longer isolating what it claims to.
#
# The compile goes through a command substitution rather than being run
# directly: the crash is a SIGSEGV, and bash prints "Segmentation fault (core
# dumped)" for a signal death it waited on in a plain command position. Inside
# a substitution the status is a value rather than an event, so the exit code
# is still 139 and nothing is announced.
cd "$(dirname "$0")" || exit 2
lfortran --openmp -c control.f90 -o /dev/null >/dev/null 2>&1 || {
   echo "INCONCLUSIVE (control.f90 no longer compiles)"; exit 0; }
discard=$(lfortran --openmp -c repro.f90 -o /dev/null 2>&1)
rc=$?
: "$discard"
if [ $rc -eq 139 ]; then
   echo REPRODUCES
else
   echo FIXED
fi
