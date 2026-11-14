"""E7: mitigation analysis. (a) models trained WITHOUT wrapped programs, evaluated on wrapped
windows -> fraction classified benign; (b) graph edit distance of each unwrapped->wrapped pair
vs the Isolation-Forest anomaly-score shift (paper Fig. 4), Spearman correlation."""
from common import *
import networkx as nx
from scipy.stats import spearmanr
from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import StandardScaler
from sgraph.models import Tabular
a = args(extra=lambda ap: ap.add_argument("--ged-timeout", type=float, default=2.0)); cfg, data = setup(a)
df, M = data.df, data.prog_meta
wrapped_mask = (df.wrapped == 1).values
tr = np.where(~wrapped_mask)[0]; te = np.where(wrapped_mask)[0]
rows = []
cands = {"XGB (micro)": lambda s: Tabular(data, "XGB", "micro", s),
         "XGB (both)": lambda s: Tabular(data, "XGB", "both", s),
         "GNN-RGCN (both)": gnn_factory(cfg, data, mode="both")}
for name, mk in cands.items():
    fr = []
    for s in range(max(1, cfg["n_seeds"] // 2)):
        p = mk(s).fit(tr).predict_proba(te)
        for fam in ["v1", "v2"]:
            sel = (df.family.values[te] == fam)
            fr.append(dict(seed=s, family=fam, frac_benign=float((p[sel] < 0.5).mean())))
    f = pd.DataFrame(fr).groupby("family").frac_benign.agg(["mean", "std"]); f["model"] = name
    rows.append(f.reset_index())
save(cfg, "e07_wrapped_classified_benign", pd.concat(rows).set_index(["model", "family"]))

# ---- GED vs Isolation Forest shift
sc = StandardScaler().fit(data.micro()[tr])
iso = IsolationForest(n_estimators=300, random_state=0).fit(sc.transform(data.micro()[(df.label.values == 0) & (~wrapped_mask)]))
score = -iso.score_samples(sc.transform(data.micro()))     # higher = more anomalous
df["anom"] = score
prog_anom = df.groupby("program").anom.mean()

def simple_graph(b):
    h = nx.DiGraph()
    for n, d in b["g"].nodes(data=True): h.add_node(n, c=d["opclass"])
    for u, v in b["g"].edges(): h.add_edge(u, v)
    return h

rows = []
for fam, (leak_t, wr_t) in {"v1": ("spectre_v1", "wrapped_v1"), "v2": ("spectre_v2", "wrapped_v2")}.items():
    for v in sorted(M[M.template == wr_t].variant):
        pl, pw = f"{leak_t}_{v:03d}", f"{wr_t}_{v:03d}"
        if pl not in prog_anom.index or pw not in prog_anom.index: continue
        ged = nx.graph_edit_distance(simple_graph(data.bundles[pl]), simple_graph(data.bundles[pw]),
                                     node_match=lambda x, y: x["c"] == y["c"], timeout=a.ged_timeout)
        rows.append(dict(family=fam, pair=v, ged_upper_bound=ged, anom_leak=prog_anom[pl],
                         anom_wrapped=prog_anom[pw], anom_shift=prog_anom[pl] - prog_anom[pw]))
r = pd.DataFrame(rows)
for fam, g in r.groupby("family"):
    print(fam, "Spearman(GED, anomaly shift) =", spearmanr(g.ged_upper_bound, g.anom_shift) if g.ged_upper_bound.nunique() > 1 else "GED constant")
save(cfg, "e07_ged_vs_anomaly_shift", r.set_index(["family", "pair"]), latex=False)
print("NOTE: GED is an upper bound (networkx anytime search with timeout). Because all wrappers of one "
      "family insert the same instruction sequence, GED can be near-constant: report it as a sanity check, "
      "and prefer varying the wrapper placement/strength if you want a meaningful correlation.")
