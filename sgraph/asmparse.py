"""Minimal RISC-V (RV64GC subset) assembly parser sufficient for CFG/DFG construction."""
from __future__ import annotations
import re
from dataclasses import dataclass, field

LOADS = {"lb", "lh", "lw", "ld", "lbu", "lhu", "lwu", "flw", "fld"}
STORES = {"sb", "sh", "sw", "sd", "fsw", "fsd"}
COND_BR = {"beq", "bne", "blt", "bge", "bltu", "bgeu", "beqz", "bnez", "blez", "bgez", "bltz", "bgtz"}
FENCES = {"fence", "fence.i", "fence.tso"}
MASK_OPS = {"sltu", "slt", "neg", "sltiu"}
TIMER = {"rdcycle", "rdtime", "rdinstret"}
# opcodes whose first operand is NOT a destination register
NO_RD = COND_BR | STORES | FENCES | {"j", "jr", "ret", "nop"}

OPCLASSES = ["alu", "load", "store", "cbranch", "jump", "ijump", "call", "ret", "fence", "mask", "timer", "other"]


@dataclass
class Inst:
    idx: int
    op: str
    operands: list
    label_before: list = field(default_factory=list)
    raw: str = ""

    @property
    def opclass(self) -> str:
        o = self.op
        if o in LOADS: return "load"
        if o in STORES: return "store"
        if o in COND_BR: return "cbranch"
        if o == "ret": return "ret"
        if o == "jalr" or o == "jr": return "ijump"
        if o in ("jal", "call"): return "call"
        if o == "j": return "jump"
        if o in FENCES: return "fence"
        if o in MASK_OPS: return "mask"
        if o in TIMER: return "timer"
        if o in {"add", "addi", "sub", "and", "andi", "or", "ori", "xor", "xori", "sll", "slli", "srl", "srli",
                 "sra", "srai", "mul", "li", "mv", "la", "lui", "auipc", "nop", "not", "addw", "addiw"}:
            return "alu"
        return "other"

    def defs(self):
        o = self.op
        if o in NO_RD or not self.operands:
            return []
        if o == "jalr":
            return [self.operands[0]] if len(self.operands) > 1 or "(" in self.operands[-1] else []
        if o == "jal":
            return [self.operands[0]] if len(self.operands) > 1 else ["ra"]
        d = self.operands[0]
        return [d] if re.match(r"^[a-z]+\d*$", d) else []

    def uses(self):
        o = self.op
        regs = []
        ops = self.operands
        if o in NO_RD and o not in STORES and o not in COND_BR:
            if o in ("jr",): return [ops[0]]
            return ["ra"] if o == "ret" else []
        if o in STORES or o in COND_BR:
            src = ops
        elif o == "jalr":
            src = ops[1:] if len(ops) > 1 else ops
        elif o in ("jal", "call"):
            src = []
        else:
            src = ops[1:]
        for s in src:
            m = re.match(r"^-?\d*\((\w+)\)$", s)
            if m:
                regs.append(m.group(1))
            elif re.match(r"^[a-z]+\d*$", s) and not re.match(r"^(done|out|loop|hit|gadget)$", s):
                regs.append(s)
        return regs

    @property
    def target_label(self):
        if self.op in COND_BR or self.op in ("j", "jal"):
            return self.operands[-1] if self.operands else None
        return None


def parse(asm: str):
    insts, pending = [], []
    labels = {}
    for line in asm.splitlines():
        line = line.split("#")[0].strip()
        if not line or line.startswith("."):
            continue
        while ":" in line:
            lab, _, rest = line.partition(":")
            lab = lab.strip()
            if not re.match(r"^[A-Za-z_.][\w.]*$", lab):
                break
            pending.append(lab)
            line = rest.strip()
        if not line:
            continue
        parts = line.replace(",", " ").split()
        op, operands = parts[0], parts[1:]
        # normalise "jalr ra, 0(t0)" / pseudo ops
        if op == "fence" and operands:
            operands = []
        ins = Inst(len(insts), op, operands, list(pending), line)
        for lab in pending:
            labels[lab] = ins.idx
        pending = []
        insts.append(ins)
    return insts, labels
