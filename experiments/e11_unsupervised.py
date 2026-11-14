"""E11 (RQ1): Isolation Forest, k-means (k=2) and HDBSCAN on the window features, with a 3-panel PCA
figure and summary metrics; also dumps per-template feature/structure summaries used by the paper."""
from common import *
from sklearn.cluster import KMeans, HDBSCAN
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
from sklearn.metrics import adjusted_rand_score, normalized_mutual_info_score, roc_auc_score
from sklearn.preprocessing import StandardScaler
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
from sgraph.features import MICRO_FEATURES
a = args(); cfg, data = setup(a); R = cfg["paths"]["results"]
df = data.df; X = StandardScaler().fit_transform(data.micro()); y = data.y(); wr = df.wrapped.values == 1
rng = np.random.default_rng(0)
sub = rng.choice(len(df), min(6000, len(df)), replace=False)          # HDBSCAN is O(n log n) but plots stay readable
Z = PCA(2, random_state=0).fit_transform(X)
ben_fit = (y == 0) & ~wr
iso = IsolationForest(n_estimators=300, random_state=0).fit(X[ben_fit])
score = -iso.score_samples(X); thr = np.percentile(score[ben_fit], 95); iso_pred = (score > thr).astype(int)
km = KMeans(2, n_init=10, random_state=0).fit(X[sub]); km_lab_all = km.predict(X)
Z3 = PCA(3, random_state=0).fit_transform(X)                              # fixed, documented setting (no tuning on labels)
hd = HDBSCAN(min_cluster_size=100, min_samples=20, copy=True).fit(Z3[sub]); hd_lab = hd.labels_
# majority cluster ~ leak mapping for k-means
leak_cl = int(np.argmax([y[km_lab_all == c].mean() for c in (0, 1)])); km_pred = (km_lab_all == leak_cl).astype(int)
rows = [
 dict(model="Isolation Forest (fit on benign, 95th pct)", ARI=adjusted_rand_score(y, iso_pred), NMI=normalized_mutual_info_score(y, iso_pred),
      AUC_vs_label=roc_auc_score(y, score), frac_wrapped_flagged=float(iso_pred[wr].mean()), frac_leak_flagged=float(iso_pred[y == 1].mean())),
 dict(model="k-means (k=2)", ARI=adjusted_rand_score(y, km_pred), NMI=normalized_mutual_info_score(y, km_pred), AUC_vs_label=np.nan,
      frac_wrapped_flagged=float(km_pred[wr].mean()), frac_leak_flagged=float(km_pred[y == 1].mean())),
 dict(model="HDBSCAN (subsample)", ARI=adjusted_rand_score(y[sub], hd_lab), NMI=normalized_mutual_info_score(y[sub], hd_lab), AUC_vs_label=np.nan,
      frac_wrapped_flagged=float((hd_lab[wr[sub]] == -1).mean()) if wr[sub].any() else np.nan,
      frac_leak_flagged=float((hd_lab[y[sub] == 1] == -1).mean())),
]
save(cfg, "e11_unsupervised", pd.DataFrame(rows).set_index("model"))
amb = np.abs(score - thr) < 0.01                                         # ambiguous band near the IF threshold
fig, ax = plt.subplots(1, 3, figsize=(7.16, 2.2), sharex=True, sharey=True)
for k, (name, lab) in enumerate([("Isolation Forest", iso_pred), ("k-means (k=2)", km_pred), ("HDBSCAN", None)]):
    A = ax[k]
    if lab is None:
        nz = hd_lab == -1
        A.scatter(Z[sub][nz, 0], Z[sub][nz, 1], c="#bbbbbb", s=2, alpha=.4, rasterized=True)
        A.scatter(Z[sub][~nz, 0], Z[sub][~nz, 1], c=hd_lab[~nz], s=2, cmap="coolwarm", alpha=.6, rasterized=True)
    else:
        A.scatter(Z[:, 0], Z[:, 1], c=lab, s=2, cmap="coolwarm", alpha=.4, rasterized=True)
    A.scatter(Z[wr, 0], Z[wr, 1], s=5, facecolors="none", edgecolors="k", lw=.3, alpha=.5, rasterized=True)
    if lab is not None: A.scatter(Z[amb, 0], Z[amb, 1], marker="x", s=6, c="gold", lw=.5, rasterized=True)
    A.set_title(name, fontsize=8); A.tick_params(labelsize=7)
ax[0].set_ylabel("PC2", fontsize=7); [a_.set_xlabel("PC1", fontsize=7) for a_ in ax]
plt.tight_layout(pad=.3); plt.savefig(os.path.join(R, "e11_unsupervised.pdf"))
# per-template summaries for paper figures
S = data.struct.copy(); S["template"] = data.prog_meta.loc[S.index, "template"]
S.groupby("template").mean().to_csv(os.path.join(R, "e11_struct_by_template.csv"))
M = df.copy(); M["cls"] = np.where(M.wrapped == 1, "wrapped", np.where(M.label == 1, "leak", "benign"))
M.groupby("cls")[MICRO_FEATURES].mean().to_csv(os.path.join(R, "e11_micro_by_class.csv"))
