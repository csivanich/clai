#!/usr/bin/env bash

docker build . -t chat
exec docker run -e OPENAI_API_BASE -e OPENAI_API_KEY chat "$@"
