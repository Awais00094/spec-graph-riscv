from __future__ import annotations
import numpy as np, pandas as pd
from sklearn.metrics import (accuracy_score, precision_recall_fscore_support, roc_auc_score,
                             average_precision_score, f1_score)
from sklearn.model_selection import StratifiedGroupKFold, StratifiedKFold


def metrics(y, p, thr=0.5):
    yh = (p >= thr).astype(int)
    out = dict(acc=accuracy_score(y, yh), n=len(y), pos_rate=float(np.mean(y)))
    pr, rc, f1, _ = precision_recall_fscore_support(y, yh, labels=[1], zero_division=0)
    out.update(prec1=pr[0], rec1=rc[0], f1_1=f1[0], f1_macro=f1_score(y, yh, average="macro", zero_division=0))
    if (y == 1).sum() == 0:
        out.update(prec1=np.nan, rec1=np.nan, f1_1=np.nan)
    neg = y == 0
    out["fpr"] = float((yh[neg] == 1).mean()) if neg.any() else np.nan
    if len(np.unique(y)) == 2:
        out["auc"] = roc_auc_score(y, p); out["pr_auc"] = average_precision_score(y, p)
    else:
        out["auc"] = out["pr_auc"] = np.nan
    return out


def splits(df, protocol, n_splits=5, seed=0, group_col="program", y_col="label"):
    """protocol: 'random' (leaky window-level split, as in the IOLTS paper)
                 'group'  (all windows of a program stay together)
                 'logo:<col>' (leave one group of column <col> out, e.g. logo:family)"""
    idx = np.arange(len(df)); y = df[y_col].values
    if protocol == "random":
        for tr, te in StratifiedKFold(n_splits, shuffle=True, random_state=seed).split(idx, y):
            yield "fold", tr, te
    elif protocol == "group":
        for k, (tr, te) in enumerate(StratifiedGroupKFold(n_splits, shuffle=True, random_state=seed).split(idx, y, df[group_col])):
            yield f"fold{k}", tr, te
    elif protocol.startswith("logo:"):
        col = protocol.split(":")[1]
        for g in sorted(df[col].unique()):
            te = idx[df[col].values == g]; tr = idx[df[col].values != g]
            yield str(g), tr, te
    else:
        raise ValueError(protocol)


def run_cv(df, make_model, protocol, seeds, n_splits=5, pooled=False):
    """Returns per-(seed,fold) metrics DataFrame. make_model(seed) -> object with fit/predict_proba(idx)."""
    rows = []
    for s in seeds:
        for name, tr, te in splits(df, protocol, n_splits, s):
            m = make_model(s).fit(tr)
            p = m.predict_proba(te)
            r = metrics(df["label"].values[te], p); r.update(seed=s, fold=name); rows.append(r)
    return pd.DataFrame(rows)


def summarize(res, cols=("acc", "prec1", "rec1", "f1_1", "f1_macro", "auc", "pr_auc")):
    g = res[list(cols)]
    return {c: f"{g[c].mean():.3f}±{res.groupby('seed')[c].mean().std(ddof=0):.3f}" for c in cols}
