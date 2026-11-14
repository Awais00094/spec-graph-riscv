"""gem5 configuration fragment: dump + reset stats every N committed instructions.

Usage (gem5 >= 22, RISC-V O3 SE mode), adapt to your own config script:

    gem5.opt -d m5out/<program> configs/deprecated/example/se.py --cpu-type=O3CPU \
        --caches --l2cache -c <binary>   # then edit se.py's final run loop as below

Replace the final `m5.simulate()` in your config with:
"""
import m5

WINDOW = 1000

def run_in_windows(system, max_windows=10_000):
    cpu = system.cpu[0] if isinstance(system.cpu, list) else system.cpu
    for _ in range(max_windows):
        cpu.scheduleInstStop(0, WINDOW, "window")      # API name may vary slightly by gem5 version
        ev = m5.simulate()
        m5.stats.dump(); m5.stats.reset()               # -> one stats block per window
        if ev.getCause() != "window":
            break
    return ev
