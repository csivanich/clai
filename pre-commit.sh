#!/usr/bin/env bash

if ! command -v pre-commit;then
    pip install pre-commit
fi

pre-commit install
pre-commit install-hooks
pre-commit run -a
