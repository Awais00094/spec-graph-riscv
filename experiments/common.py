import os, sys, yaml, argparse
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import numpy as np, pandas as pd
from sgraph import dataset

def args(extra=None):
    ap = argparse.ArgumentParser()
    ap.add_argument("--config", default="configs/default.yaml")
    ap.add_argument("--smoke", action="store_true", help="tiny/fast settings for pipeline testing")
    ap.add_argument("--source", default="synthetic", choices=["synthetic", "gem5"])
    ap.add_argument("--asm-dir", default="data/asm")
    ap.add_argument("--windows-csv", default="data/gem5_windows.csv")
    if extra: extra(ap)
    return ap.parse_args()

def setup(a):
    cfg = yaml.safe_load(open(a.config))
    if a.smoke:
        cfg["n_seeds"] = 2; cfg["n_splits"] = 3
        cfg["synthetic"].update(variants_per_template=10, windows_per_program=30)
        cfg["gnn"]["epochs"] = 15
        cfg["paths"]["results"] = "results/smoke"
    os.makedirs(cfg["paths"]["results"], exist_ok=True)
    import json   # provenance: build_paper.py watermarks the paper unless source == gem5
    json.dump({"source": a.source, "smoke": bool(a.smoke), "n_programs_cfg": cfg["synthetic"]["variants_per_template"]},
              open(os.path.join(cfg["paths"]["results"], "provenance.json"), "w"))
    cache = os.path.join(cfg["paths"]["results"], "dataset.pkl")
    data = dataset.load_or_build(cfg, a.source, cache, asm_dir=a.asm_dir, windows_csv=a.windows_csv)
    return cfg, data

def save(cfg, name, df, latex=True, floatfmt="%.3f"):
    p = os.path.join(cfg["paths"]["results"], name)
    df.to_csv(p + ".csv", index=True)
    if latex:
        with open(p + ".tex", "w") as f: f.write(df.to_latex(float_format=lambda x: floatfmt % x, escape=True))
    print(f"[saved] {p}.csv"); print(df.to_string()); print()

def gnn_factory(cfg, data, **kw):
    from sgraph.gnn import GNNClassifier
    hp = dict(cfg["gnn"]); hp.update(kw)
    return lambda s: GNNClassifier(data, seed=s, **hp)
