from __future__ import annotations
import numpy as np
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.neural_network import MLPClassifier
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler


def make_tabular(name, seed=0):
    if name == "LR":
        return make_pipeline(StandardScaler(), LogisticRegression(max_iter=2000, random_state=seed))
    if name == "RF":
        return RandomForestClassifier(n_estimators=300, n_jobs=-1, random_state=seed)
    if name == "XGB":
        try:
            from xgboost import XGBClassifier
            return XGBClassifier(n_estimators=300, max_depth=5, learning_rate=0.1, subsample=0.9,
                                 colsample_bytree=0.9, eval_metric="logloss", random_state=seed, n_jobs=2)
        except ImportError:
            return GradientBoostingClassifier(random_state=seed)
    if name == "MLP":
        return make_pipeline(StandardScaler(), MLPClassifier((64, 32), max_iter=300, early_stopping=True, random_state=seed))
    raise KeyError(name)


class Tabular:
    """sklearn model on a feature view: 'micro' | 'struct' | 'both'."""
    def __init__(self, data, name, view="micro", seed=0):
        self.d, self.name, self.view, self.seed = data, name, view, seed

    def X(self, idx):
        parts = []
        if self.view in ("micro", "both"): parts.append(self.d.micro()[idx])
        if self.view in ("struct", "both"): parts.append(self.d.struct_rows()[idx])
        return np.hstack(parts)

    def fit(self, tr_idx):
        self.m = make_tabular(self.name, self.seed).fit(self.X(tr_idx), self.d.y()[tr_idx]); return self

    def predict_proba(self, idx): return self.m.predict_proba(self.X(idx))[:, 1]
