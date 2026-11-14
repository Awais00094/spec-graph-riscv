"""E8: analyse repeated P550 perf runs (results/perf_runs.csv from scripts/perf_measure.sh).
Derived ratios are computed per run; mean +/- 95% bootstrap CI; Welch t-test on overhead."""
import sys, numpy as np, pandas as pd
from scipy.stats import ttest_ind
path = sys.argv[1] if len(sys.argv) > 1 else "results/perf_runs.csv"
d = pd.read_csv(path)
d["ipc"] = d.instructions / d.cycles
d["branch_miss_rate"] = d["branch-misses"] / d.branches
d["cache_miss_rate"] = d["cache-misses"] / d["cache-references"]
d["cycles_per_branch"] = d.cycles / d.branches
def ci(x, B=5000, rng=np.random.default_rng(0)):
    b = rng.choice(x, (B, len(x))).mean(1); return np.percentile(b, [2.5, 97.5])
rows = []
for m in ["cycles", "instructions", "ipc", "branches", "branch-misses", "branch_miss_rate",
          "cache-references", "cache-misses", "cache_miss_rate", "cycles_per_branch"]:
    a, w = d[d.variant == "plain"][m].values, d[d.variant == "wrapped"][m].values
    rows.append(dict(metric=m, plain=a.mean(), plain_ci=tuple(ci(a).round(4)), wrapped=w.mean(),
                     wrapped_ci=tuple(ci(w).round(4)), overhead_pct=100 * (w.mean() / a.mean() - 1),
                     welch_p=ttest_ind(a, w, equal_var=False).pvalue))
r = pd.DataFrame(rows).set_index("metric"); print(r.to_string()); r.to_csv("results/perf_summary.csv")
