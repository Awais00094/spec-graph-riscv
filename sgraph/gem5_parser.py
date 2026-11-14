"""Parse gem5 output into the window table used by this repo.

Two inputs (see scripts/gem5_window_run.py which produces them):
  1. A multi-block stats.txt: one 'Begin/End Simulation Statistics' block per window of
     `window_insts` committed instructions (stats reset after every dump).
  2. (optional) an Exec debug trace, used only as a cross-check of committed instruction counts.

!! gem5 stat names differ between versions / CPU models. STAT_CANDIDATES lists several
!! candidate names per quantity; the first one found is used. Run
!!     python -m sgraph.gem5_parser --list-stats m5out/stats.txt
!! once and edit STAT_CANDIDATES for your build. Missing quantities become NaN and the
!! window is dropped (with a warning) unless --allow-nan is given.
"""
from __future__ import annotations
import re, sys, argparse
import numpy as np
import pandas as pd
from .features import MICRO_FEATURES

C = "system.cpu"
STAT_CANDIDATES = {
    "mispredicts": [f"{C}.commit.branchMispredicts", f"{C}.branchPred.condIncorrect", f"{C}.iew.branchMispredicts"],
    "branches":    [f"{C}.branchPred.condPredicted", f"{C}.commit.branches", f"{C}.fetch.branches"],
    "btb_updates": [f"{C}.branchPred.BTBUpdates", f"{C}.branchPred.btb.updates"],
    "squashed":    [f"{C}.commit.commitSquashedInsts", f"{C}.iew.squashedInsts", f"{C}.branchPred.squashes"],
    "issued":      [f"{C}.iew.instsIssued", f"{C}.issuedInsts"],
    "committed":   [f"{C}.commit.committedInsts", f"{C}.committedInsts", "simInsts"],
    "dcache_acc":  [f"{C}.dcache.overallAccesses::total", f"{C}.dcache.demandAccesses::total"],
    "dcache_miss": [f"{C}.dcache.overallMisses::total", f"{C}.dcache.demandMisses::total"],
    "dcache_repl": [f"{C}.dcache.replacements"],
    "spec_loads":  [f"{C}.iew.exec_refs", f"{C}.lsq0.forwLoads", f"{C}.dcache.ReadReq.accesses::total"],
    "mem_lat_avg": [f"{C}.dcache.overallAvgMissLatency::total", f"{C}.dcache.demandAvgMissLatency::total"],
    "br_lat":      [f"{C}.branchPred.resolutionLatency", f"{C}.iew.branchResolutionLatency"],
}

BLOCK = re.compile(r"-+ Begin Simulation Statistics -+(.*?)-+ End Simulation Statistics -+", re.S)
LINE = re.compile(r"^(\S+)\s+([-+0-9.eE]+|nan|inf)\b")


def read_blocks(path):
    txt = open(path).read()
    blocks = BLOCK.findall(txt) or [txt]
    out = []
    for b in blocks:
        d = {}
        for ln in b.splitlines():
            m = LINE.match(ln.strip())
            if m:
                try: d[m.group(1)] = float(m.group(2))
                except ValueError: pass
        out.append(d)
    return out


def pick(d, key):
    for name in STAT_CANDIDATES[key]:
        if name in d: return d[name]
    return np.nan


def block_to_features(d):
    mis, br = pick(d, "mispredicts"), pick(d, "branches")
    com, iss = pick(d, "committed"), pick(d, "issued")
    acc, miss = pick(d, "dcache_acc"), pick(d, "dcache_miss")
    return {
        "mispred_rate": mis / br if br else np.nan,
        "pred_updates": pick(d, "btb_updates"),
        "spec_instr_proxy": com,                        # paper Table I: commit.committedInsts
        "flush_events": pick(d, "squashed"),
        "spec_commit_ratio": iss / com if com else np.nan,
        "spec_loads": pick(d, "spec_loads"),
        "l1_hit_rate": 1 - miss / acc if acc else np.nan,
        "evictions": pick(d, "dcache_repl"),
        "mem_latency": pick(d, "mem_lat_avg"),
        "branch_latency": pick(d, "br_lat"),
    }


def stats_to_windows(stats_path, program, template, family, wrapped, label, allow_nan=False):
    rows = []
    for w, d in enumerate(read_blocks(stats_path)):
        f = block_to_features(d)
        if not allow_nan and any(np.isnan(v) for v in f.values()):
            continue
        rows.append(dict(program=program, template=template, family=family, wrapped=wrapped,
                         window=w, label=label, **f))
    return pd.DataFrame(rows, columns=["program", "template", "family", "wrapped", "window", "label"] + MICRO_FEATURES)


# ----- Exec-trace cross-check ---------------------------------------------------------------
EXEC = re.compile(r"^\s*(\d+):\s+(\S+):\s+T\d+\s*:\s*(?:(0x[0-9a-f]+)\s+)?(?:@(\S+)\s*:?)?\s*:?\s*(.*?)\s*:\s*(\w+)\s*:(.*)$")


def exec_trace_counts(path, window_insts=1000):
    """Counts committed insts / loads / control insts per window from an Exec trace."""
    counts, cur = [], dict(insts=0, loads=0, ctrl=0)
    for ln in open(path):
        m = EXEC.match(ln)
        if not m: continue
        flags = m.group(7)
        cur["insts"] += 1; cur["loads"] += "IsLoad" in flags; cur["ctrl"] += "IsControl" in flags
        if cur["insts"] == window_insts:
            counts.append(cur); cur = dict(insts=0, loads=0, ctrl=0)
    return pd.DataFrame(counts)


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("--list-stats", metavar="STATS_TXT")
    a = ap.parse_args()
    if a.list_stats:
        d = read_blocks(a.list_stats)[0]
        for k in sorted(d):
            if any(s in k for s in ("branch", "Branch", "dcache", "commit", "iew", "squash", "BTB", "issued", "Insts")):
                print(k, d[k])
