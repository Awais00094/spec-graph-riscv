"""Run every experiment. `python run_all.py --smoke` finishes in a few minutes on a laptop CPU."""
import subprocess, sys, argparse
ap = argparse.ArgumentParser(); ap.add_argument("--smoke", action="store_true")
ap.add_argument("--source", default="synthetic"); a, rest = ap.parse_known_args()
flags = (["--smoke"] if a.smoke else []) + ["--source", a.source] + rest
for e in ["e02_dataset_stats", "e03_graph_metrics", "e01_baselines", "e04_gnn_vs_baselines",
          "e05_ablation", "e06_generalization", "e07_wrapper_analysis", "e09_explain", "e10_latency", "e11_unsupervised", "e12_curves"]:
    print(f"\n===== {e} =====", flush=True)
    r = subprocess.run([sys.executable, f"experiments/{e}.py"] + flags)
    if r.returncode: sys.exit(f"{e} failed")
