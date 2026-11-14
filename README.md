# spec-graph-riscv

Code skeleton for the TDMR extension of *"Microarchitectural Analysis of Speculative Execution
Patterns in RISC-V using Machine Learning and ISA-Level Masking Wrappers"* (IOLTS 2026).
New contribution: **graph-theoretic analysis and a graph neural network** over the CFG/DFG of each
gadget, evaluated under a leakage-free protocol.

<!-- > **Read this first.** This repository was rebuilt from the paper, not recovered from your original
> code. Everything that does not need gem5 or the P550 board runs and is tested. Two parts could not be
> tested here and **must be validated by you**: the gem5 stats parser (`sgraph/gem5_parser.py`) and
> the board scripts (`hw/`, `scripts/perf_measure.sh`). The default data is **** and exists only
> to prove the pipeline runs. **Never put numbers computed on data in the paper.** -->

## Quick start

```bash
pip install -r requirements.txt
make test          # 6 unit tests (graph construction, gadget metrics, gem5 stats parser)
make smoke         # whole pipeline on tiny data, ~3 min on 2 CPU cores
make all           # full run (slow; mainly to check scaling)
```
Outputs go to `results/` (`*.csv`, `*.tex` tables, `*.pdf` figure).

## Pipeline

```
asm (.S) --asmparse--> instructions --cfgdfg--> block CFG + instruction graph (ctrl + data edges)
                                                  |-- metrics.py  : centrality, cyclomatic, gadget metrics
                                                  |-- tensors.py  : padded dense tensors (4 relations)
gem5 stats.txt (1 block / 1000 insts) --gem5_parser--> Table I features per window
                      both --> dataset.Data --> baselines (sklearn/XGBoost) | gnn.py (R-GCN / SAGE-mean, pure PyTorch)
```

Graph metrics worth knowing (all in `sgraph/metrics.py`): `tainted_load_after_branch` counts
(branch/indirect-jump → load A → load B with B's address data-dependent on A), the Spectre gadget as a
subgraph; `fence_guards_tainted_load` is 1 when a fence control-precedes load A (the wrapper signature).

## Experiments (one script each, map to the planned paper sections)

| Script | What it answers |
|---|---|
| `e01_baselines.py` | Baselines under the IOLTS **random** split vs a **program-grouped** split (quantifies window leakage) |
| `e02_dataset_stats.py` | Dataset/graph statistics table (missing in the IOLTS paper) |
| `e03_graph_metrics.py` | Which graph metrics separate leak / benign / wrapped (Mann-Whitney, Cliff's δ, BH-FDR) |
| `e04_gnn_vs_baselines.py` | Headline: R-GCN / SAGE vs XGBoost, grouped CV, mean ± std over seeds |
| `e05_ablation.py` | struct-only / micro-only / both + feature-importance figure (new Sec. VII) |
| `e06_generalization.py` | RQ2: leave-one-family-out and leave-one-template-out |
| `e07_wrapper_analysis.py` | Wrapped windows classified benign? Graph edit distance vs Isolation-Forest shift |
| `e08_perf_analyze.py` + `scripts/perf_measure.sh` + `hw/bench.c` | 30+ pinned repeated P550 runs, CIs, Welch test |
| `e09_explain.py` | Gradient×input node saliency (heuristic, see caveat) |
| `e10_latency.py` | Inference cost per window |
| `recompute_table3.py` | Recomputes derived rows of the IOLTS Table III from its raw counters |

Flags: `--smoke` (tiny settings), `--source gem5 --asm-dir ... --windows-csv ...` (real data).

## Using real data (what you must do)

1. **Programs.** Put one `<program>.S` per program in `data/asm/` (the generated ones in there are
   templates; replace/extend with your real patterns). Names must be unique.
2. **gem5.** Run each binary in O3 mode and dump+reset stats every 1000 committed instructions
   (`scripts/gem5_window_run.py` shows the loop; the API name for the instruction stop varies by gem5
   version). Then check the stat names of *your* build:
   `python -m sgraph.gem5_parser --list-stats m5out/<prog>/stats.txt` and edit `STAT_CANDIDATES`.
3. **Window table.** `stats_to_windows(...)` returns rows with `program, template, family, wrapped,
   window, label` + the 10 Table I features; concatenate over programs into `data/gem5_windows.csv`.
   `family` groups related programs (e.g. `v1` contains spectre_v1 and wrapped_v1) and drives the
   leave-one-family-out test, so assign it carefully. **Labels** must follow your window definition
   (transient behaviour present), not the program label.
4. `python run_all.py --source gem5 --asm-dir data/asm --windows-csv data/gem5_windows.csv`
5. **P550.** Copy the repo to the board, `./scripts/perf_measure.sh 30 2`, then
   `python experiments/e08_perf_analyze.py results/perf_runs.csv`.

## Known limitations (state them honestly in the paper)

* **Graph scope.** One static graph per *program*; windows of a program share it and differ only in
  microarchitectural features. A per-window dynamic graph (from the Exec trace) is a natural extension.
* **Window label vs graph.** Structure alone cannot tell a quiet window of a leaking program from an
  active one, so struct-only models are upper-bounded; this is expected and is what the ablation shows.
* **GED** (`e07`) is a networkx anytime *upper bound*; paired variants differ only by the wrapper, so
  GED is nearly constant within a family. Use it as a sanity check or add variable-strength wrappers
  (mask-only, fence-only) to get a meaningful correlation.
* **Saliency** (`e09`) is gradient×input on a small model; treat as qualitative.
* `asmgen.py` produces *pattern skeletons* (no attacker training or secret recovery code); they are
  for structural/microarchitectural analysis, not working exploits. `hw/bench.c` measures wrapper
  overhead on in-bounds accesses only.
* No LSTM baseline (needs per-instruction sequences); add one if you keep it in the paper.
* The IOLTS paper's 70/15/15 random split puts overlapping windows of one program in train and test;
  expect `e01` on real data to show a drop from `random` to `group`. Report both.

## IOLTS Table III issues found by `recompute_table3.py`

From the paper's own raw counters: IPC is 0.993 → 0.978 (the table shows 0.98 → 0.99, apparently swapped);
wrapped cache-miss rate is 3.49 % (table: 4.76 %); effective frequency is 3.17 / 3.18 GHz (table:
3.23 / 3.12); branch-miss rate is 0.39 % / 0.41 % (table: 0.41 / 0.43 %). Fix before resubmitting.

## Building the paper (new)

`paper/main.tex` contains **no hand-typed experimental numbers**. Every figure, table and number comes from `results/` via
`paper/build_paper.py` (13 figures, 12 tables, ~70 number macros). Workflow:

```bash
python run_all.py --source gem5 --asm-dir data/asm --windows-csv data/gem5_windows.csv   # REAL data
make paper                                                                               # -> paper/main.pdf
```
* `run_all.py` writes `results/provenance.json`. If it is missing or its source is not `gem5` (i.e. data),
  
* New experiments feeding the paper: `e11_unsupervised.py` (Isolation Forest / k-means / HDBSCAN + PCA figure) and
  `e12_curves.py` (ROC/PR curves, confusion matrices).
* Orange text (`\chk{}`) marks sentences whose direction depends on the results; re-read each against the real numbers and
  soften or delete as needed. Red text (`\tbd{}`) marks values that do not exist yet (gem5 version, cache config, artifact URLs,
  the 30-run hardware column: put `results/perf_summary.csv` from `e08_perf_analyze.py` into `results/` and rebuild).
* The hardware table/figure use the IOLTS single-run counters (derived rows recomputed from raw counts) until `perf_summary.csv` exists.
* Artifact links in `main.tex` (GitHub, Zenodo) are placeholders: create the repository and mint the DOI first.

## Paper sources (`paper/`)

* `main.tex`, `refs.bib`: the manuscript (IEEEtran). `fig/` holds the hand-made figures (framework, wrappers, v1 graph, GNN architecture); `gen/` is **generated** by `build_paper.py` from `results/` and is not committed.
* `CHANGE_REPORT.md`: notes from the last layout/text revision, including open inconsistencies to resolve before submission.
* To use the sources on Overleaf, run `make paper` once, then upload `paper/main.tex`, `refs.bib`, `fig/` and `gen/`.

## License and citation

Add a `LICENSE` file before making the repository public (e.g. MIT or Apache-2.0), and fill in the artifact DOI in `main.tex` after archiving a release on Zenodo.
