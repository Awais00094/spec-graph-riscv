"""E12: pooled out-of-fold ROC / PR curves and confusion matrices under grouped CV (seed 0)."""
from common import *
from sklearn.metrics import roc_curve, precision_recall_curve, confusion_matrix
from sgraph.models import Tabular
from sgraph.evalutil import splits
a = args(); cfg, data = setup(a); R = cfg["paths"]["results"]
y = data.y(); df = data.df
cands = {"XGB (M)": lambda s: Tabular(data, "XGB", "micro", s),
         "XGB (S+M)": lambda s: Tabular(data, "XGB", "both", s),
         "GNN R-GCN (S+M)": gnn_factory(cfg, data, mode="both", arch="rgcn")}
curves, cms = [], []
for name, mk in cands.items():
    p = np.zeros(len(df))
    for _, tr, te in splits(df, "group", cfg["n_splits"], 0):
        p[te] = mk(0).fit(tr).predict_proba(te)
    fpr, tpr, _ = roc_curve(y, p); pr, rc, _ = precision_recall_curve(y, p)
    for a_, b_ in zip(fpr[::max(1, len(fpr) // 200)], tpr[::max(1, len(fpr) // 200)]): curves.append(dict(model=name, kind="roc", x=a_, y=b_))
    for a_, b_ in zip(rc[::max(1, len(rc) // 200)], pr[::max(1, len(rc) // 200)]): curves.append(dict(model=name, kind="pr", x=a_, y=b_))
    tn, fp, fn, tp = confusion_matrix(y, (p >= .5).astype(int)).ravel()
    cms.append(dict(model=name, TN=tn, FP=fp, FN=fn, TP=tp))
pd.DataFrame(curves).to_csv(os.path.join(R, "e12_curves.csv"), index=False)
save(cfg, "e12_confusion", pd.DataFrame(cms).set_index("model"), floatfmt="%.0f")
