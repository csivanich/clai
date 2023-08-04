#!/usr/bin/env bash

[[ -n "${DEBUG:-}" ]] && set -x

set -Eeuo pipefail

post(){
    case ${POST:-} in
        python)
            python -c -
            ;;
        *)
            cat
            ;;
    esac
}

CONTINUE=0

while [[ $# -gt 0 ]];do
    case $1 in
        "--")
            shift
            break
            ;;
        "--persona"|"-p")
            shift
            export PERSONA=$1
            shift
            ;;
        "--python")
            shift
            POST=python
            export PERSONA=python+concise+runnable
            ;;
        "--continue"|"-c")
            shift
            export CONTINUE=1
            shift
            ;;
        *)
            echo "Unknown arg: $1"
            exit 1
            ;;
    esac
done

msg="$@"

./endpoints.sh "$msg" | post
