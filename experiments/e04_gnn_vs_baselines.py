"""E4: headline comparison under the grouped split (+ the leaky random split for reference)."""
from common import *
from sgraph.models import Tabular
from sgraph.evalutil import run_cv, summarize
a = args(); cfg, data = setup(a)
seeds = range(cfg["n_seeds"]); rows = []
for proto in ["group"]:
    cands = {
        "XGB (micro)": lambda s: Tabular(data, "XGB", "micro", s),
        "XGB (micro+struct metrics)": lambda s: Tabular(data, "XGB", "both", s),
        "GNN-SAGE (struct+micro)": gnn_factory(cfg, data, mode="both", arch="sage"),
        "GNN-RGCN (struct+micro)": gnn_factory(cfg, data, mode="both", arch="rgcn"),
    }
    for name, mk in cands.items():
        res = run_cv(data.df, mk, proto, seeds, cfg["n_splits"])
        rows.append(dict(protocol=proto, model=name, **summarize(res)))
save(cfg, "e04_gnn_vs_baselines", pd.DataFrame(rows).set_index(["protocol", "model"]))
