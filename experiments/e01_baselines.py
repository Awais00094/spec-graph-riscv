"""E1: baseline re-evaluation. Compares the IOLTS random window split ('random') with a
program-grouped split ('group'). A drop from random -> group quantifies window leakage."""
from common import *
from sgraph.models import Tabular
from sgraph.evalutil import run_cv, summarize

a = args(); cfg, data = setup(a)
seeds = range(cfg["n_seeds"]); rows = []
for proto in ["random", "group"]:
    for name in ["LR", "RF", "XGB", "MLP"]:
        res = run_cv(data.df, lambda s: Tabular(data, name, "micro", s), proto, seeds, cfg["n_splits"])
        rows.append(dict(protocol=proto, model=name, **summarize(res)))
save(cfg, "e01_baselines", pd.DataFrame(rows).set_index(["protocol", "model"]))
