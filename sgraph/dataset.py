from __future__ import annotations
import os, pickle
import numpy as np
import pandas as pd
from . import asmgen, cfgdfg, metrics, tensors
from .features import MICRO_FEATURES


class Data:
    """Holds window-level table + per-program graph objects."""
    def __init__(self, df, bundles, prog_meta):
        self.df = df.reset_index(drop=True)
        self.bundles = bundles                     # program -> cfgdfg bundle
        self.prog_meta = prog_meta                 # DataFrame indexed by program
        self.struct = pd.DataFrame({p: metrics.compute(b) for p, b in bundles.items()}).T
        self.struct = self.struct[metrics.METRIC_NAMES].astype(float)
        names, X, A, M = tensors.stack(bundles)
        self.names, self.gX, self.gA, self.gM = names, X, A, M
        self.pidx = np.array([names.index(p) for p in self.df["program"]])

    # tabular views
    def micro(self): return self.df[MICRO_FEATURES].values.astype(np.float32)
    def struct_rows(self): return self.struct.loc[self.df["program"]].values.astype(np.float32)
    def y(self): return self.df["label"].values.astype(int)


def build_synthetic(cfg, seed=0):
    from .synth import synth_windows
    s = cfg["synthetic"]
    progs = asmgen.generate(s["variants_per_template"], seed)
    bundles = {p.name: cfgdfg.build_graphs(p.asm) for p in progs}
    df = synth_windows(progs, s["windows_per_program"], seed=seed)
    meta = pd.DataFrame([dict(program=p.name, template=p.template, family=p.family, label=p.label,
                              wrapped=p.wrapped, variant=p.variant) for p in progs]).set_index("program")
    return Data(df, bundles, meta)


def build_from_gem5(cfg, asm_dir, windows_csv):
    """Real data: `windows_csv` has columns program,window,label + MICRO_FEATURES (see
    sgraph/gem5_parser.py); `asm_dir/<program>.S` holds the assembly of each program."""
    df = pd.read_csv(windows_csv)
    bundles = {}
    for p in df["program"].unique():
        with open(os.path.join(asm_dir, p + ".S")) as f:
            bundles[p] = cfgdfg.build_graphs(f.read())
    for c in ("template", "family", "wrapped"):
        assert c in df.columns, f"windows csv needs a '{c}' column (see README)"
    meta = df.groupby("program")[["template", "family", "wrapped"]].first()
    meta["label"] = df.groupby("program")["label"].max()
    return Data(df, bundles, meta)


def load_or_build(cfg, source="synthetic", cache="results/dataset.pkl", **kw):
    if source == "synthetic":
        if os.path.exists(cache):
            try:
                with open(cache, "rb") as f: return pickle.load(f)
            except Exception: pass
        d = build_synthetic(cfg, cfg["seed"])
    else:
        d = build_from_gem5(cfg, kw["asm_dir"], kw["windows_csv"])
    os.makedirs(os.path.dirname(cache), exist_ok=True)
    with open(cache, "wb") as f: pickle.dump(d, f)
    return d
