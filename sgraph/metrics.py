"""Graph-theoretic structural metrics on the instruction-level graph and block-level CFG.

All metrics are computed per program. The *gadget-specific* ones encode the Spectre
structure directly: a conditional/indirect branch followed (control-reachable) by a load
whose result feeds (data-reachable) the address of a second load.
"""
from __future__ import annotations
import numpy as np
import networkx as nx

METRIC_NAMES = [
    "n_nodes", "n_edges_ctrl", "n_edges_data", "cyclomatic", "n_cycles_cfg",
    "max_betw", "mean_betw", "max_pagerank", "max_indeg_data", "max_outdeg_data",
    "n_loads", "n_cbranch", "n_ijump", "n_fence", "n_mask", "n_timer",
    "load_load_chain", "branch_to_dep_load_dist", "fence_guards_tainted_load",
    "tainted_load_after_branch",
]


def _sub(g, kind):
    h = nx.DiGraph()
    h.add_nodes_from(g.nodes(data=True))
    for u, v, d in g.edges(data=True):
        if d["kind"] == kind: h.add_edge(u, v)
    return h


def compute(bundle) -> dict:
    g, cfg, insts = bundle["g"], bundle["cfg"], bundle["insts"]
    gc, gd = _sub(g, "ctrl"), _sub(g, "data")
    m = {}
    n = g.number_of_nodes()
    m["n_nodes"] = n
    m["n_edges_ctrl"] = gc.number_of_edges()
    m["n_edges_data"] = gd.number_of_edges()
    e, nb = cfg.number_of_edges(), cfg.number_of_nodes()
    comp = nx.number_weakly_connected_components(cfg)
    m["cyclomatic"] = e - nb + 2 * comp
    try:
        m["n_cycles_cfg"] = sum(1 for _ in nx.simple_cycles(cfg))
    except Exception:
        m["n_cycles_cfg"] = 0
    full = nx.DiGraph(gc); full.add_edges_from(gd.edges())
    bt = nx.betweenness_centrality(full) if n > 2 else {0: 0.0}
    m["max_betw"] = max(bt.values()); m["mean_betw"] = float(np.mean(list(bt.values())))
    pr = nx.pagerank(full) if n else {0: 0}
    m["max_pagerank"] = max(pr.values())
    m["max_indeg_data"] = max((d for _, d in gd.in_degree()), default=0)
    m["max_outdeg_data"] = max((d for _, d in gd.out_degree()), default=0)
    oc = [i.opclass for i in insts]
    for k, name in [("load", "n_loads"), ("cbranch", "n_cbranch"), ("ijump", "n_ijump"),
                    ("fence", "n_fence"), ("mask", "n_mask"), ("timer", "n_timer")]:
        m[name] = oc.count(k)

    loads = [i.idx for i in insts if i.opclass == "load"]
    # load -> (data path) -> load : second load's address depends on first load's value
    chain, taint_pairs = 0, []
    for a in loads:
        reach = nx.descendants(gd, a)
        for b in loads:
            if b != a and b in reach:
                chain += 1; taint_pairs.append((a, b))
    m["load_load_chain"] = chain
    spec_srcs = [i.idx for i in insts if i.opclass in ("cbranch", "ijump")]
    best, tainted, fence_between = 0, 0, 0
    fences = [i.idx for i in insts if i.opclass == "fence"]
    dists = []
    for s in spec_srcs:
        after = nx.descendants(gc, s)
        for (a, b) in taint_pairs:
            if a in after and b in after:
                tainted += 1
                dists.append(nx.shortest_path_length(gc, s, b) if nx.has_path(gc, s, b) else 0)
                # serialization guard: a fence that control-precedes the tainted (secret) load `a`
                # (V1 wrapper: mask + fence before the access; V2 wrapper: fence before jalr)
                if any(nx.has_path(gc, f, a) for f in fences):
                    fence_between += 1
    # indirect jump whose target has downstream dependent load chain also counts (V2)
    m["branch_to_dep_load_dist"] = min(dists) if dists else 0
    m["tainted_load_after_branch"] = tainted
    m["fence_guards_tainted_load"] = fence_between
    return m
