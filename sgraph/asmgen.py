"""RISC-V assembly template generator.

Produces many *variants* of each Spectre-style / benign template (register renaming,
benign padding, different constants, different but equivalent gadget shapes) so that
grouped cross-validation and leave-one-pattern-out are meaningful.

Templates (family = vulnerability family used for leave-one-family-out):
  benign_loop, benign_memcpy, benign_safe_check  -> label 0 (family 'benign')
  spectre_v1, flush_reload, prime_probe          -> label 1
  spectre_v2                                     -> label 1
  wrapped_v1 (sltu/neg/and + fence rw,rw)        -> label 0, wrapped=1, family 'v1'
  wrapped_v2 (fence before jalr)                 -> label 0, wrapped=1, family 'v2'

NOTE: These are *pattern skeletons* for structural analysis, derived from the gadget
descriptions in the IOLTS paper (Fig. 2/3). They are not working exploits (no
attacker-side training / timing / secret recovery code).
"""
from __future__ import annotations
import random
from dataclasses import dataclass

TEMP = ["t0", "t1", "t2", "t3", "t4", "t5", "t6", "a2", "a3", "a4", "a5", "a6", "a7"]
ALU_PAD = ["addi {r}, {r}, 1", "xori {r}, {r}, 5", "slli {r}, {r}, 1", "ori {r}, {r}, 3"]


@dataclass
class Program:
    name: str
    template: str
    family: str
    label: int       # 1 = speculative leak, 0 = benign / mitigated
    wrapped: int
    variant: int
    asm: str


def _regs(rng, n):
    return rng.sample(TEMP, n)


def _pad(rng, r, k):
    return "\n".join("    " + rng.choice(ALU_PAD).format(r=r) for _ in range(k))


def spectre_v1(rng):
    x, lim, a1, v, a2, t = _regs(rng, 6)
    p = rng.randint(0, 3)
    return f"""gadget:
    la {lim}, array1_size
    lw {lim}, 0({lim})
{_pad(rng, t, p)}
    bgeu {x}, {lim}, done
    la {a1}, array1
    add {a1}, {a1}, {x}
    lbu {v}, 0({a1})
    slli {v}, {v}, {rng.choice([9, 10, 12])}
    la {a2}, array2
    add {a2}, {a2}, {v}
    lbu {t}, 0({a2})
done:
    ret
"""


def wrapped_v1(rng):
    x, lim, a1, v, a2, t = _regs(rng, 6)          # same draws as spectre_v1 -> paired variants
    m = random.Random(hash((x, lim, a1, v, a2, t)) & 0xFFFF).choice([r for r in TEMP if r not in (x, lim, a1, v, a2, t)])
    p = rng.randint(0, 3)
    return f"""gadget:
    la {lim}, array1_size
    lw {lim}, 0({lim})
{_pad(rng, t, p)}
    sltu {m}, {x}, {lim}
    neg {m}, {m}
    and {x}, {x}, {m}
    fence rw, rw
    bgeu {x}, {lim}, done
    la {a1}, array1
    add {a1}, {a1}, {x}
    lbu {v}, 0({a1})
    slli {v}, {v}, {rng.choice([9, 10, 12])}
    la {a2}, array2
    add {a2}, {a2}, {v}
    lbu {t}, 0({a2})
done:
    ret
"""


def spectre_v2(rng):
    tgt, v, a2, t, s = _regs(rng, 5)
    p = rng.randint(0, 3)
    return f"""gadget:
    la {tgt}, victim_table
    ld {tgt}, 0({tgt})
{_pad(rng, t, p)}
    jalr ra, 0({tgt})
    ret
leak_gadget:
    la {s}, secret
    lbu {v}, 0({s})
    slli {v}, {v}, {rng.choice([9, 10, 12])}
    la {a2}, array2
    add {a2}, {a2}, {v}
    lbu {t}, 0({a2})
    ret
"""


def wrapped_v2(rng):
    tgt, v, a2, t, s = _regs(rng, 5)
    p = rng.randint(0, 3)
    return f"""gadget:
    la {tgt}, victim_table
    ld {tgt}, 0({tgt})
{_pad(rng, t, p)}
    fence rw, rw
    fence iorw, iorw
    jalr ra, 0({tgt})
    ret
leak_gadget:
    la {s}, secret
    lbu {v}, 0({s})
    slli {v}, {v}, {rng.choice([9, 10, 12])}
    la {a2}, array2
    add {a2}, {a2}, {v}
    lbu {t}, 0({a2})
    ret
"""


def flush_reload(rng):
    a, t0, t1, c = _regs(rng, 4)
    return f"""probe:
    la {a}, shared_line
    fence rw, rw
    rdcycle {t0}
    lbu {c}, 0({a})
    fence rw, rw
    rdcycle {t1}
    sub {t1}, {t1}, {t0}
    li {c}, {rng.choice([80, 100, 120])}
    bltu {t1}, {c}, hit
    li {c}, 0
    j out
hit:
    li {c}, 1
out:
    ret
"""


def prime_probe(rng):
    base, i, n, t0, t1, c = _regs(rng, 6)
    ways = rng.choice([4, 8])
    return f"""probe_set:
    la {base}, evset
    li {i}, 0
    li {n}, {ways}
    rdcycle {t0}
loop:
    lbu {c}, 0({base})
    addi {base}, {base}, {rng.choice([64, 128, 4096])}
    addi {i}, {i}, 1
    blt {i}, {n}, loop
    rdcycle {t1}
    sub {t1}, {t1}, {t0}
    ret
"""


def benign_loop(rng):
    i, n, s, a, v = _regs(rng, 5)
    return f"""sum:
    li {s}, 0
    li {i}, 0
    li {n}, {rng.choice([64, 128, 256])}
    la {a}, buf
loop:
    lw {v}, 0({a})
    add {s}, {s}, {v}
    addi {a}, {a}, 4
    addi {i}, {i}, 1
    blt {i}, {n}, loop
    ret
"""


def benign_memcpy(rng):
    s, d, n, v = _regs(rng, 4)
    return f"""copy:
    la {s}, src
    la {d}, dst
    li {n}, {rng.choice([32, 64, 128])}
loop:
    lbu {v}, 0({s})
    sb {v}, 0({d})
    addi {s}, {s}, 1
    addi {d}, {d}, 1
    addi {n}, {n}, -1
    bnez {n}, loop
    ret
"""


def benign_safe_check(rng):
    """Hard negative: bounds check + load, but the second access is NOT data-dependent
    on the first load (no transmit gadget)."""
    x, lim, a1, v, a2, t = _regs(rng, 6)
    return f"""safe:
    la {lim}, array1_size
    lw {lim}, 0({lim})
    bgeu {x}, {lim}, done
    la {a1}, array1
    add {a1}, {a1}, {x}
    lbu {v}, 0({a1})
    addi {v}, {v}, 1
    la {a2}, counter
    lbu {t}, 0({a2})
    add {t}, {t}, {v}
    sb {t}, 0({a2})
done:
    ret
"""


TEMPLATES = {
    # name: (fn, family, label, wrapped)
    "benign_loop": (benign_loop, "benign", 0, 0),
    "benign_memcpy": (benign_memcpy, "benign", 0, 0),
    "benign_safe_check": (benign_safe_check, "benign", 0, 0),
    "spectre_v1": (spectre_v1, "v1", 1, 0),
    "wrapped_v1": (wrapped_v1, "v1", 0, 1),
    "spectre_v2": (spectre_v2, "v2", 1, 0),
    "wrapped_v2": (wrapped_v2, "v2", 0, 1),
    "flush_reload": (flush_reload, "cache_probe", 1, 0),
    "prime_probe": (prime_probe, "cache_probe", 1, 0),
}


def generate(variants_per_template: int = 30, seed: int = 0):
    """Variant k of spectre_vN and wrapped_vN share registers/padding (seeded per family+variant),
    so the pair differs only by the wrapper -> clean graph-edit-distance analysis (E7)."""
    progs = []
    for name, (fn, fam, lab, wr) in TEMPLATES.items():
        for v in range(variants_per_template):
            key = (fam if fam in ("v1", "v2") else name, v, seed)
            rng = random.Random(repr(key))
            progs.append(Program(f"{name}_{v:03d}", name, fam, lab, wr, v, fn(rng)))
    return progs


def write_all(out_dir: str, variants_per_template: int = 30, seed: int = 0):
    import os
    os.makedirs(out_dir, exist_ok=True)
    progs = generate(variants_per_template, seed)
    for p in progs:
        with open(os.path.join(out_dir, p.name + ".S"), "w") as f:
            f.write(f"# template={p.template} family={p.family} label={p.label} wrapped={p.wrapped}\n{p.asm}")
    return progs
