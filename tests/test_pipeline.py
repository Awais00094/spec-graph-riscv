import os, sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
import numpy as np
from sgraph import asmgen, cfgdfg, metrics, gem5_parser

def m(t, seed=0):
    p = [x for x in asmgen.generate(2, seed) if x.template == t][0]
    return metrics.compute(cfgdfg.build_graphs(p.asm))

def test_v1_gadget_detected():
    x = m("spectre_v1"); assert x["tainted_load_after_branch"] >= 1 and x["fence_guards_tainted_load"] == 0

def test_wrapped_has_fence_guard_and_mask():
    for t in ("wrapped_v1", "wrapped_v2"):
        assert m(t)["fence_guards_tainted_load"] >= 1
    assert m("wrapped_v1")["n_mask"] == 2

def test_benign_has_no_gadget():
    for t in ("benign_loop", "benign_memcpy", "benign_safe_check"):
        assert m(t)["tainted_load_after_branch"] == 0

def test_v2_needs_indirect_edges():
    assert m("spectre_v2")["tainted_load_after_branch"] >= 1

def test_cfg_loop_has_cycle():
    assert m("benign_loop")["n_cycles_cfg"] >= 1

def test_gem5_stats_parser(tmp_path):
    blk = lambda c, mis: f"""---------- Begin Simulation Statistics ----------
system.cpu.commit.committedInsts  {c}
system.cpu.iew.instsIssued  {int(c*1.1)}
system.cpu.commit.branchMispredicts {mis}
system.cpu.branchPred.condPredicted 100
system.cpu.branchPred.BTBUpdates 7
system.cpu.commit.commitSquashedInsts 30
system.cpu.dcache.overallAccesses::total 400
system.cpu.dcache.overallMisses::total 40
system.cpu.dcache.replacements 5
system.cpu.iew.exec_refs 300
system.cpu.dcache.overallAvgMissLatency::total 22.5
system.cpu.branchPred.resolutionLatency 8
---------- End Simulation Statistics ----------
"""
    p = tmp_path / "stats.txt"; p.write_text(blk(1000, 10) + blk(1000, 20))
    df = gem5_parser.stats_to_windows(str(p), "prog", "spectre_v1", "v1", 0, 1)
    assert len(df) == 2 and abs(df.mispred_rate.iloc[0] - 0.10) < 1e-9 and abs(df.l1_hit_rate.iloc[0] - 0.9) < 1e-9
