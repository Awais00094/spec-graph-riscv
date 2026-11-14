"""Recompute the derived rows of IOLTS Table III from its own raw counters (sanity check)."""
raw = {"unwrapped": dict(cycles=6361847, inst=6316398, br=553866, brm=2167, cref=4367470, cmiss=142778, t=0.002005),
       "wrapped":   dict(cycles=6475465, inst=6331593, br=553968, brm=2288, cref=4369439, cmiss=152567, t=0.002037)}
paper = {"unwrapped": dict(ipc=0.98, bmr=0.41, cmr=3.27, ghz=3.23, cpb=11.48),
         "wrapped":   dict(ipc=0.99, bmr=0.43, cmr=4.76, ghz=3.12, cpb=11.69)}
for k, r in raw.items():
    c = dict(ipc=r["inst"] / r["cycles"], bmr=100 * r["brm"] / r["br"], cmr=100 * r["cmiss"] / r["cref"],
             ghz=r["cycles"] / r["t"] / 1e9, cpb=r["cycles"] / r["br"])
    print(k)
    for m in c: print(f"  {m:4s} recomputed={c[m]:.4f}  paper={paper[k][m]}")
print("overhead cycles %.2f%%  time %.2f%%  inst %.2f%%" % (
    100 * (raw['wrapped']['cycles'] / raw['unwrapped']['cycles'] - 1),
    100 * (raw['wrapped']['t'] / raw['unwrapped']['t'] - 1),
    100 * (raw['wrapped']['inst'] / raw['unwrapped']['inst'] - 1)))
