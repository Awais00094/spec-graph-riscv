#!/usr/bin/env bash
# Repeated perf measurement on the P550 (run ON the board). Interleaves variants to cancel drift.
# usage: ./scripts/perf_measure.sh [N=30] [CORE=2]  -> results/perf_runs.csv
set -euo pipefail
N=${1:-30}; CORE=${2:-2}
cd "$(dirname "$0")/../hw"
gcc -O2 -DWRAPPED=0 bench.c -o bench_plain
gcc -O2 -DWRAPPED=1 bench.c -o bench_wrapped
OUT=../results/perf_runs.csv; mkdir -p ../results
echo "variant,run,cycles,instructions,branches,branch-misses,cache-references,cache-misses,seconds" > "$OUT"
EV=cycles,instructions,branches,branch-misses,cache-references,cache-misses
for i in $(seq 1 "$N"); do
  for v in plain wrapped; do
    taskset -c "$CORE" perf stat -x, -e $EV -- ./bench_$v 2> /tmp/perf_$$.txt >/dev/null
    python3 - "$v" "$i" /tmp/perf_$$.txt >> "$OUT" <<'PY'
import sys
v,i,p=sys.argv[1:4]; d={}
for ln in open(p):
    f=ln.strip().split(",")
    if len(f)>2 and f[0].replace(".","").isdigit(): d[f[2].split(":")[0]]=f[0]
print(",".join([v,i]+[d.get(k,"nan") for k in ["cycles","instructions","branches","branch-misses","cache-references","cache-misses"]]+["nan"]))
PY
  done
done
echo "wrote $OUT"
