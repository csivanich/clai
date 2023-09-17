#!/usr/bin/env python3

import sys
from io import TextIOWrapper
import json


class StreamError(Exception):
    pass


def on_error(code, message):
    raise StreamError(f"({code}) {message}")


def handle(input):
    while True:
        line = input.readline().rstrip()

        # There's empty lines between the JSON stanzas in some implementations
        if line == "":
            continue

        # But if it's false/None, we're done
        if not line:
            break

        # TODO: don't spit and rejoin, just parse until the space
        parts = line.split(" ")

        if parts[0] == "data:":
            if parts[1] == "[DONE]":
                break

            parsed_data = json.loads(" ".join(parts[1:]))

            e = parsed_data.get("error", {})
            if e:
                code = e.get("code", -1)
                message = e.get("message", "Unknown error occurred")
                raise StreamError(code, message)

            for c in parsed_data.get("choices", []):
                if "content" in c.get("delta", {}):
                    print(c["delta"]["content"], end="", flush=True)


if __name__ == "__main__":
    handle(sys.stdin)
    print(flush=True)
