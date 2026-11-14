"""E9: gradient x input node saliency of the trained GNN on gadget programs. Checks whether the
highest-saliency instructions are the bounds-check branch / dependent loads."""
from common import *
import torch
from sgraph.gnn import GNNClassifier
a = args(); cfg, data = setup(a)
df = data.df
g = GNNClassifier(data, mode="both", arch="rgcn", seed=0, **{k: v for k, v in cfg["gnn"].items()})
g.fit(np.arange(len(df)))
rows = []
for tmpl in ["spectre_v1", "spectre_v2", "wrapped_v1", "wrapped_v2", "benign_safe_check"]:
    for prog in data.prog_meta.index[data.prog_meta.template == tmpl][:10]:
        i = int(np.where(df.program.values == prog)[0][0]); b = data.bundles[prog]
        X = data.gX[data.pidx[i]].unsqueeze(0).clone().requires_grad_(True)
        A, M = data.gA[data.pidx[i]].unsqueeze(0), data.gM[data.pidx[i]].unsqueeze(0)
        mic = torch.as_tensor(g.sc.transform(data.micro()[[i]]).astype(np.float32))
        g.net.zero_grad(); g.net(X, A, M, mic).sum().backward()
        sal = (X.grad * X).abs().sum(-1)[0, :len(b["insts"])].detach().numpy()
        top = int(sal.argmax()); ins = b["insts"][top]
        rows.append(dict(template=tmpl, program=prog, top_node=top, top_inst=ins.raw, top_opclass=ins.opclass))
r = pd.DataFrame(rows)
save(cfg, "e09_explain_top_nodes", r.set_index("program"), latex=False)
print(r.groupby(["template", "top_opclass"]).size().unstack(fill_value=0))
