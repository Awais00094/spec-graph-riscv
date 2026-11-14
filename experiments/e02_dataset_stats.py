"""E2: dataset + graph statistics table (missing in the IOLTS paper)."""
from common import *
a = args(); cfg, data = setup(a)
df, st = data.df, data.struct.copy()
st["template"] = data.prog_meta.loc[st.index, "template"]
t = df.groupby("template").agg(programs=("program", "nunique"), windows=("label", "size"),
                               leak_windows=("label", "sum"), wrapped=("wrapped", "max"))
g = st.groupby("template")[["n_nodes", "n_edges_ctrl", "n_edges_data", "cyclomatic"]].mean()
out = t.join(g)
out.loc["TOTAL"] = [out.programs.sum(), out.windows.sum(), out.leak_windows.sum(), np.nan,
                    st.n_nodes.mean(), st.n_edges_ctrl.mean(), st.n_edges_data.mean(), st.cyclomatic.mean()]
save(cfg, "e02_dataset_stats", out)
