#!/usr/bin/env python

import sys
import io
import json

# Create an unbuffered input stream
input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding=sys.stdin.encoding, errors=sys.stdin.errors)

# Process lines from the unbuffered input stream
while True:
    line = input_stream.readline().rstrip()

    if not line:
        break

    parts = line.split(" ")

    if parts[1] == "[DONE]":
        break

    for c in json.loads(" ".join(parts[1:])).get('choices', []):
        if 'content' in c.get('delta', {}):
            print(c['delta']['content'], end='', flush=True)

print(flush=True)
