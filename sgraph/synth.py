"""SYNTHETIC gem5-like window features (Table I) for pipeline smoke-testing ONLY.

!!! These numbers are drawn from hand-set distributions. They exist so that every script in
!!! this repository runs end-to-end before real gem5 traces are available. Do NOT report any
!!! result computed on synthetic data in the paper. Use `--source gem5` for real results.

Generative story (mirrors the label definition of the IOLTS paper: a window is
speculative-leak if transient behaviour is present):
  * each program draws a random effect (program-level offset) -> windows of one program are
    correlated, which is what makes random window splits optimistic vs grouped splits;
  * leak programs have a fraction (1-p_active) of 'quiet' windows with no transient behaviour,
    labelled benign (label noise by design);
  * wrapped programs shift towards benign but keep a partial residual speculative signal.
"""
from __future__ import annotations
import numpy as np
import pandas as pd
from .features import MICRO_FEATURES

# (benign_mean, leak_mean, sd_within) in rough natural units
SPEC = {
    "mispred_rate":     (0.02, 0.10, 0.03),
    "pred_updates":     (200., 420., 90.),
    "spec_instr_proxy": (1000., 1150., 70.),
    "flush_events":     (15., 55., 18.),
    "spec_commit_ratio": (1.03, 1.18, 0.05),
    "spec_loads":       (120., 330., 60.),
    "l1_hit_rate":      (0.97, 0.90, 0.025),
    "evictions":        (10., 35., 10.),
    "mem_latency":      (12., 30., 6.),
    "branch_latency":   (6., 9., 2.),
}


def window_features(rng, kind: str, prog_offset: np.ndarray, residual=0.35):
    """kind in {'benign','leak','wrapped'}; returns feature vector (10,)."""
    out = []
    for k, f in enumerate(MICRO_FEATURES):
        b, l, sd = SPEC[f]
        w = {"benign": 0.0, "leak": 1.0, "wrapped": residual}[kind]
        mu = b + w * (l - b)
        out.append(mu + prog_offset[k] * sd + rng.normal(0, sd))
    return np.array(out)


def synth_windows(programs, windows_per_program=60, p_active=0.8, seed=0, prog_sd=1.8):
    rng = np.random.default_rng(seed)
    rows = []
    for p in programs:
        off = rng.normal(0, prog_sd, len(MICRO_FEATURES))
        for w in range(windows_per_program):
            if p.label == 1:
                active = rng.random() < p_active
                kind, lab = ("leak", 1) if active else ("benign", 0)
            elif p.wrapped:
                kind, lab = "wrapped", 0
            else:
                kind, lab = "benign", 0
            x = window_features(rng, kind, off)
            rows.append(dict(program=p.name, template=p.template, family=p.family,
                             wrapped=p.wrapped, variant=p.variant, window=w, label=lab,
                             **dict(zip(MICRO_FEATURES, x))))
    df = pd.DataFrame(rows)
    df["mispred_rate"] = df["mispred_rate"].clip(0, 1)
    df["l1_hit_rate"] = df["l1_hit_rate"].clip(0, 1)
    return df
