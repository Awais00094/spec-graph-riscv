"""E10: inference cost per window (single-threaded CPU)."""
import time
from common import *
from sgraph.models import Tabular
a = args(); cfg, data = setup(a)
idx = np.arange(len(data.df)); sub = idx[:2000]
x = Tabular(data, "XGB", "both", 0).fit(idx); g = gnn_factory(cfg, data, mode="both")(0).fit(idx)
def t(f, n=5):
    f(); s = time.perf_counter()
    for _ in range(n): f()
    return (time.perf_counter() - s) / n / len(sub) * 1e6
r = pd.DataFrame([dict(model="XGB (both)", us_per_window=t(lambda: x.predict_proba(sub))),
                  dict(model="GNN-RGCN (both)", us_per_window=t(lambda: g.predict_proba(sub)))]).set_index("model")
save(cfg, "e10_latency", r)
