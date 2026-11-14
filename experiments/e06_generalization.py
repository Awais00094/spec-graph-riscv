"""E6 (RQ2): leave-one-family-out and leave-one-template-out. Test sets can be single-class
(e.g. cache_probe is all-leak), so we report acc / recall(leak) / FPR per held-out group."""
from common import *
from sgraph.models import Tabular
from sgraph.evalutil import run_cv
a = args(); cfg, data = setup(a)
seeds = range(max(1, cfg["n_seeds"] // 2)); rows = []
cands = {
    "XGB (micro)": lambda s: Tabular(data, "XGB", "micro", s),
    "XGB (struct metrics)": lambda s: Tabular(data, "XGB", "struct", s),
    "XGB (both)": lambda s: Tabular(data, "XGB", "both", s),
    "GNN-RGCN (struct)": gnn_factory(cfg, data, mode="struct"),
    "GNN-RGCN (both)": gnn_factory(cfg, data, mode="both"),
}
for col in ["family", "template"]:
    for name, mk in cands.items():
        res = run_cv(data.df, mk, f"logo:{col}", seeds)
        g = res.groupby("fold")[["acc", "rec1", "fpr"]].mean()
        g["heldout_by"], g["model"] = col, name
        rows.append(g.reset_index())
out = pd.concat(rows).set_index(["heldout_by", "fold", "model"])
save(cfg, "e06_generalization", out)
print("Note: rec1 is NaN for held-out groups without leak windows; fpr is NaN for groups without benign windows.")
