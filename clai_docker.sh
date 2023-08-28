#!/usr/bin/env bash

docker build . -t chat
exec docker run \
    --rm \
    -e DEBUG \
    -e TRACE \
    -e OPENAI_API_BASE \
    -e OPENAI_API_KEY \
    chat "$@"
