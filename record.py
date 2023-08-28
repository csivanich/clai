#!/usr/bin/env python3

import sys
import time

trace_file = sys.argv[1]
sys.stderr.write(f"Trace: {trace_file}\n")

# This sets the multiplier done to the timestamp
# This reduces issues with floating point subtraction
# when calculating deltas on the replay-side.
# Therefore, the replay side must _divide_ by this
# after doing the floating point delta computation.
SPEEDUP = 10000

with open(trace_file, "w") as trace:
    trace.write(f"# REPLAY {SPEEDUP}\n")
    while True:
        line = sys.stdin.readline()
        if not line:
            break
        timestamp = time.time() * SPEEDUP
        trace.write(f"{timestamp} {line.strip()}\n")
        print(line, end="", flush=True)
