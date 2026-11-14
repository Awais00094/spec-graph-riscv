smoke:   ; python run_all.py --smoke
all:     ; python run_all.py
asm:     ; python -c "from sgraph import asmgen; asmgen.write_all('data/asm', 30, 0)"
test:    ; pytest -q
table3:  ; python experiments/recompute_table3.py
perf:    ; python experiments/e08_perf_analyze.py results/perf_runs.csv
paper:   ; python paper/build_paper.py --results results --out paper/gen && cd paper && latexmk -pdf -interaction=nonstopmode main.tex
