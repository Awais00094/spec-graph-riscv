"""E3: which graph-theoretic metrics differ between classes? Program-level tests (no
pseudo-replication over windows). Mann-Whitney U, Cliff's delta, Benjamini-Hochberg FDR."""
from common import *
from scipy.stats import mannwhitneyu
a = args(); cfg, data = setup(a)
S, M = data.struct, data.prog_meta

def bh(p):
    p = np.asarray(p); o = np.argsort(p); n = len(p); q = np.empty(n)
    q[o] = np.minimum.accumulate((p[o] * n / (np.arange(n) + 1))[::-1])[::-1]
    return np.clip(q, 0, 1)

def compare(mask_a, mask_b, title):
    rows = []
    for c in S.columns:
        x, y = S.loc[mask_a, c].values, S.loc[mask_b, c].values
        if np.ptp(np.r_[x, y]) == 0:
            rows.append(dict(metric=c, mean_a=x.mean(), mean_b=y.mean(), delta=0.0, p=1.0)); continue
        u = mannwhitneyu(x, y, alternative="two-sided")
        cliff = 2 * u.statistic / (len(x) * len(y)) - 1
        rows.append(dict(metric=c, mean_a=x.mean(), mean_b=y.mean(), delta=cliff, p=u.pvalue))
    r = pd.DataFrame(rows).set_index("metric"); r["q_BH"] = bh(r.p.values)
    save(cfg, title, r.sort_values("q_BH"))

leak = (M.label == 1).values; ben = ((M.label == 0) & (M.wrapped == 0)).values; wr = (M.wrapped == 1).values
compare(leak, ben, "e03_leak_vs_benign")          # a=leak, b=benign
compare(wr, leak, "e03_wrapped_vs_leak")          # a=wrapped, b=leak
