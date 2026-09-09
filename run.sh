#!/usr/bin/env bash
# Run every case that can decide for itself, and report whether it still
# reproduces.
#
# A bug directory opts in by carrying an executable `check.sh` that prints
# REPRODUCES or FIXED; this only has to find them and tabulate. Directories
# without one are demonstrated with `make test` and read by a person instead,
# which is the older convention here and still a fine one.
#
#     ./run.sh                                   # everything with a check.sh
#     ./run.sh lfortran_omp_continued_directive  # one case
#
# Exits non-zero while anything still reproduces, so it can be pointed at a new
# compiler release to see what got fixed.
set -uo pipefail
cd "$(dirname "$0")" || exit 2

root=${1:-.}
[[ -d $root ]] || { echo "no such directory: $root" >&2; exit 2; }

status=0
found=0

while IFS= read -r check; do
   dir=${check%/check.sh}
   printf '%-42s ' "${dir#./}"
   result=$("$check")
   echo "$result"
   found=1
   [[ $result == FIXED ]] || status=1
done < <(find "$root" -name check.sh -type f -perm -u+x | sort)

if [[ $found -eq 0 ]]; then
   echo "no self-checking cases found under $root" >&2
   exit 2
fi

exit "$status"
