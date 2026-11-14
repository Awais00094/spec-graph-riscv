"""Dependency-free (pure PyTorch) dense relational GNN for small program graphs.

arch='rgcn' : separate weights per relation (ctrl/data x forward/reverse)  -> typed edges
arch='sage' : relation-agnostic mean aggregation over the union adjacency (GraphSAGE-mean-like)
mode        : 'struct' (graph only) | 'micro' (window features only; MLP) | 'both'
"""
from __future__ import annotations
import numpy as np
import torch, torch.nn as nn, torch.nn.functional as F
from sklearn.preprocessing import StandardScaler
from .tensors import NODE_DIM, REL


class Layer(nn.Module):
    def __init__(self, din, dout, arch):
        super().__init__()
        self.arch = arch
        self.self_lin = nn.Linear(din, dout)
        nrel = len(REL) if arch == "rgcn" else 1
        self.rel = nn.ModuleList([nn.Linear(din, dout, bias=False) for _ in range(nrel)])

    def forward(self, H, A):                      # H: B,N,D  A: B,R,N,N (row-normalised)
        out = self.self_lin(H)
        if self.arch == "rgcn":
            for r, lin in enumerate(self.rel):
                out = out + torch.bmm(A[:, r], lin(H))
        else:
            U = (A.sum(1) > 0).float()
            U = U / U.sum(-1, keepdim=True).clamp(min=1)
            out = out + torch.bmm(U, self.rel[0](H))
        return F.relu(out)


class Net(nn.Module):
    def __init__(self, n_micro, mode, arch, hidden, layers, dropout):
        super().__init__()
        self.mode = mode
        d = NODE_DIM
        self.layers = nn.ModuleList()
        if mode != "micro":
            for _ in range(layers):
                self.layers.append(Layer(d, hidden, arch)); d = hidden
        gdim = 2 * hidden if mode != "micro" else 0
        mdim = n_micro if mode != "struct" else 0
        self.head = nn.Sequential(nn.Linear(gdim + mdim, hidden), nn.ReLU(), nn.Dropout(dropout),
                                  nn.Linear(hidden, 1))

    def graph_embed(self, X, A, M):
        H = X
        for l in self.layers: H = l(H, A)
        m = M.unsqueeze(-1)
        mean = (H * m).sum(1) / m.sum(1).clamp(min=1)
        mx = (H - 1e9 * (1 - m)).max(1).values
        return torch.cat([mean, mx], -1)

    def forward(self, X, A, M, mic):
        z = []
        if self.mode != "micro": z.append(self.graph_embed(X, A, M))
        if self.mode != "struct": z.append(mic)
        return self.head(torch.cat(z, -1)).squeeze(-1)


class GNNClassifier:
    """fit/predict_proba over window-table row indices of a `Data` object."""
    def __init__(self, data, mode="both", arch="rgcn", hidden=64, layers=3, epochs=60, lr=3e-3,
                 batch_size=128, weight_decay=1e-4, dropout=0.2, seed=0, device="cpu"):
        self.d, self.mode, self.arch = data, mode, arch
        self.hp = dict(hidden=hidden, layers=layers, dropout=dropout)
        self.epochs, self.lr, self.bs, self.wd, self.seed = epochs, lr, batch_size, weight_decay, seed
        self.dev = device

    def _batch(self, idx, mic):
        p = torch.as_tensor(self.d.pidx[idx])
        return (self.d.gX[p].to(self.dev), self.d.gA[p].to(self.dev), self.d.gM[p].to(self.dev),
                torch.as_tensor(mic).to(self.dev))

    def fit(self, tr_idx, val_frac=0.15):
        torch.manual_seed(self.seed); rng = np.random.default_rng(self.seed)
        micro = self.d.micro()
        self.sc = StandardScaler().fit(micro[tr_idx])
        mic_all = self.sc.transform(micro).astype(np.float32)
        y = torch.as_tensor(self.d.y()).float()
        progs = self.d.df["program"].values[tr_idx]
        up = np.unique(progs); rng.shuffle(up)
        vp = set(up[: max(1, int(val_frac * len(up)))])
        isv = np.array([p in vp for p in progs])
        tr, va = tr_idx[~isv], tr_idx[isv]
        self.net = Net(micro.shape[1], self.mode, self.arch, **self.hp).to(self.dev)
        opt = torch.optim.AdamW(self.net.parameters(), lr=self.lr, weight_decay=self.wd)
        best, best_state, bad = 1e9, None, 0
        for ep in range(self.epochs):
            self.net.train(); perm = rng.permutation(tr)
            for i in range(0, len(perm), self.bs):
                b = perm[i:i + self.bs]
                out = self.net(*self._batch(b, mic_all[b]))
                loss = F.binary_cross_entropy_with_logits(out, y[b].to(self.dev))
                opt.zero_grad(); loss.backward(); opt.step()
            self.net.eval()
            with torch.no_grad():
                vl = F.binary_cross_entropy_with_logits(self.net(*self._batch(va, mic_all[va])), y[va]).item()
            if vl < best - 1e-4: best, bad = vl, 0; best_state = {k: v.clone() for k, v in self.net.state_dict().items()}
            else:
                bad += 1
                if bad >= 10: break
        self.net.load_state_dict(best_state); self.net.eval()
        return self

    def predict_proba(self, idx):
        mic = self.sc.transform(self.d.micro()[idx]).astype(np.float32)
        out = []
        with torch.no_grad():
            for i in range(0, len(idx), 1024):
                b = idx[i:i + 1024]
                out.append(torch.sigmoid(self.net(*self._batch(b, mic[i:i + 1024]))).cpu().numpy())
        return np.concatenate(out)
