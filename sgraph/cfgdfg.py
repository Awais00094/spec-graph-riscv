"""CFG (basic-block) and instruction-level DFG construction from parsed assembly."""
from __future__ import annotations
import networkx as nx
from .asmparse import parse, COND_BR


def basic_blocks(insts, labels):
    leaders = {0}
    for ins in insts:
        if ins.label_before:
            leaders.add(ins.idx)
        if ins.opclass in ("cbranch", "jump", "ijump", "ret", "call"):
            if ins.idx + 1 < len(insts):
                leaders.add(ins.idx + 1)
        t = ins.target_label
        if t in labels:
            leaders.add(labels[t])
    leaders = sorted(leaders)
    blocks = []
    for k, s in enumerate(leaders):
        e = leaders[k + 1] if k + 1 < len(leaders) else len(insts)
        blocks.append(list(range(s, e)))
    return blocks


def indirect_targets(insts, labels):
    """Conservative target set of indirect jumps: labels that are not the entry label and are
    never referenced by a direct branch/jump (i.e. address-taken / separately-entered code)."""
    referenced = {i.target_label for i in insts if i.target_label}
    first = insts[0].label_before[0] if insts and insts[0].label_before else None
    out = []
    for lab, idx in labels.items():
        if lab in referenced or lab == first or idx == 0:
            continue
        out.append(idx)
    return sorted(set(out))


def build_cfg(insts, labels):
    """Basic-block CFG. Node attrs: insts (idx list), sig (opclass multiset signature)."""
    blocks = basic_blocks(insts, labels)
    blk_of = {i: b for b, blk in enumerate(blocks) for i in blk}
    g = nx.DiGraph()
    for b, blk in enumerate(blocks):
        sig = tuple(sorted(insts[i].opclass for i in blk))
        g.add_node(b, insts=blk, sig=sig)
    for b, blk in enumerate(blocks):
        last = insts[blk[-1]]
        fall = b + 1 < len(blocks)
        oc = last.opclass
        if oc == "cbranch":
            t = labels.get(last.target_label)
            if t is not None: g.add_edge(b, blk_of[t], kind="taken")
            if fall: g.add_edge(b, b + 1, kind="fall")
        elif oc == "jump":
            t = labels.get(last.target_label)
            if t is not None: g.add_edge(b, blk_of[t], kind="jump")
        elif oc in ("ret",):
            pass
        elif oc == "ijump":
            g.nodes[b]["indirect"] = True
            for t in indirect_targets(insts, labels):
                g.add_edge(b, blk_of[t], kind="indirect")
            if fall: g.add_edge(b, b + 1, kind="indirect_fall")
        elif fall:
            g.add_edge(b, b + 1, kind="fall")
    return g, blocks


def inst_successors(insts, labels):
    succ = {i.idx: [] for i in insts}
    n = len(insts)
    for ins in insts:
        oc, i = ins.opclass, ins.idx
        if oc == "cbranch":
            t = labels.get(ins.target_label)
            if t is not None: succ[i].append((t, "ctrl"))
            if i + 1 < n: succ[i].append((i + 1, "ctrl"))
        elif oc == "jump":
            t = labels.get(ins.target_label)
            if t is not None: succ[i].append((t, "ctrl"))
        elif oc == "ret":
            pass
        elif oc == "ijump":
            for t in indirect_targets(insts, labels):
                succ[i].append((t, "ctrl"))
            if i + 1 < n: succ[i].append((i + 1, "ctrl"))
        elif i + 1 < n:
            succ[i].append((i + 1, "ctrl"))
    return succ


def reaching_defs(insts, succ):
    """Classic iterative reaching definitions; returns list of (def_idx, use_idx, reg)."""
    n = len(insts)
    gen = [{r: ins.idx for r in ins.defs()} for ins in insts]
    IN = [dict() for _ in range(n)]   # reg -> set(def idx)
    OUT = [dict() for _ in range(n)]
    preds = {i: [] for i in range(n)}
    for i, ss in succ.items():
        for j, _ in ss: preds[j].append(i)
    changed = True
    while changed:
        changed = False
        for i in range(n):
            newin = {}
            for p in preds[i]:
                for r, ds in OUT[p].items():
                    newin.setdefault(r, set()).update(ds)
            newout = {r: set(ds) for r, ds in newin.items()}
            for r, d in gen[i].items():
                newout[r] = {d}
            if newin != IN[i] or newout != OUT[i]:
                IN[i], OUT[i] = newin, newout
                changed = True
    edges = []
    for ins in insts:
        for r in set(ins.uses()):
            for d in IN[ins.idx].get(r, ()):
                edges.append((d, ins.idx, r))
    return edges


def build_graphs(asm: str):
    """Returns dict with insts, cfg (block level), g (instruction-level multi-relational graph)."""
    insts, labels = parse(asm)
    cfg, blocks = build_cfg(insts, labels)
    succ = inst_successors(insts, labels)
    ddeps = reaching_defs(insts, succ)
    g = nx.MultiDiGraph()
    for ins in insts:
        g.add_node(ins.idx, op=ins.op, opclass=ins.opclass, indirect=int(ins.opclass == "ijump"))
    for i, ss in succ.items():
        for j, k in ss: g.add_edge(i, j, kind="ctrl")
    for d, u, r in ddeps:
        g.add_edge(d, u, kind="data", reg=r)
    return dict(insts=insts, labels=labels, cfg=cfg, blocks=blocks, g=g)
