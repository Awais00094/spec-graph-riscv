"""Padded dense graph tensors for the (small) per-program instruction graphs."""
from __future__ import annotations
import numpy as np
import torch
from .asmparse import OPCLASSES

REL = ["ctrl_f", "data_f", "ctrl_r", "data_r"]
NODE_DIM = len(OPCLASSES) + 1 + 2 + 1  # opclass one-hot, indirect, in/out data degree, rel. position


def program_tensors(bundle, max_n: int):
    g, insts = bundle["g"], bundle["insts"]
    n = len(insts)
    X = np.zeros((max_n, NODE_DIM), dtype=np.float32)
    A = np.zeros((len(REL), max_n, max_n), dtype=np.float32)
    mask = np.zeros(max_n, dtype=np.float32); mask[:n] = 1
    din = np.zeros(n); dout = np.zeros(n)
    for u, v, d in g.edges(data=True):
        if d["kind"] == "ctrl":
            A[0, v, u] = 1; A[2, u, v] = 1      # message flows u->v (forward) / v->u (reverse)
        else:
            A[1, v, u] = 1; A[3, u, v] = 1
            dout[u] += 1; din[v] += 1
    for i, ins in enumerate(insts):
        X[i, OPCLASSES.index(ins.opclass)] = 1
        X[i, len(OPCLASSES)] = int(ins.opclass == "ijump")
        X[i, len(OPCLASSES) + 1] = min(din[i], 4) / 4
        X[i, len(OPCLASSES) + 2] = min(dout[i], 4) / 4
        X[i, len(OPCLASSES) + 3] = i / max(n - 1, 1)
    for r in range(A.shape[0]):                     # row-normalise (mean aggregation)
        deg = A[r].sum(1, keepdims=True); A[r] = A[r] / np.maximum(deg, 1)
    return X, A, mask


def stack(bundles: dict):
    names = list(bundles)
    max_n = max(len(b["insts"]) for b in bundles.values())
    Xs, As, Ms = zip(*[program_tensors(bundles[k], max_n) for k in names])
    return (names, torch.tensor(np.stack(Xs)), torch.tensor(np.stack(As)), torch.tensor(np.stack(Ms)))
