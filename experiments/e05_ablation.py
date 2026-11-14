"""E5: structure-only / micro-only / both, for XGB and GNN; + XGB gain importance (Sec. VII)."""
from common import *
from sgraph.models import Tabular
from sgraph.evalutil import run_cv, summarize
from sgraph.features import MICRO_FEATURES
from sgraph.metrics import METRIC_NAMES
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
a = args(); cfg, data = setup(a)
seeds = range(cfg["n_seeds"]); rows = []
for view in ["struct", "micro", "both"]:
    res = run_cv(data.df, lambda s: Tabular(data, "XGB", view, s), "group", seeds, cfg["n_splits"])
    rows.append(dict(model="XGB", inputs=view, **summarize(res)))
    res = run_cv(data.df, gnn_factory(cfg, data, mode=view, arch="rgcn"), "group", seeds, cfg["n_splits"])
    rows.append(dict(model="GNN-RGCN" if view != "micro" else "MLP(GNN head)", inputs=view, **summarize(res)))
save(cfg, "e05_ablation", pd.DataFrame(rows).set_index(["model", "inputs"]))

m = Tabular(data, "XGB", "both", 0).fit(np.arange(len(data.df)))
imp = pd.Series(getattr(m.m, "feature_importances_"), index=MICRO_FEATURES + METRIC_NAMES).sort_values()
save(cfg, "e05_feature_importance", imp.to_frame("importance"), latex=False)
imp.tail(15).plot.barh(figsize=(6, 5)); plt.xlabel("XGBoost importance"); plt.tight_layout()
plt.savefig(os.path.join(cfg["paths"]["results"], "e05_feature_importance.pdf"))
