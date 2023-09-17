#!/usr/bin/env python3

import sys
import time

args = sys.argv[1:]
if args:
    with open(args[0]) as f:
        lines = f.readlines()
else:
    lines = sys.stdin.readlines()

first_line = lines[0]
parts = first_line.split(" ")
assert parts[0] == "#" and parts[1] == "REPLAY"
SLOWDOWN = float(parts[2])
lines = lines[1:]

first_line = True
for line in lines:
    parts = line.split(" ")

    # prime the "last" timestamp
    if first_line:
        first_line = False
        timestamp = float(parts[0])

    diff = float(parts[0]) - timestamp
    time.sleep(diff / SLOWDOWN)
    print(" ".join(parts[1:]), end="", flush=True)
    timestamp = float(parts[0])
