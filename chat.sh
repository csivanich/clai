#!/usr/bin/env bash

set -Eeuo pipefail

parse_args(){
    CONTINUE=0

    for arg in "$@"; do
        case $arg in
            "--")
                shift
                return
                ;;
            "--persona"|"-p")
                shift
                export PERSONA=$1
                shift
                break
                ;;
            "--continue"|"-c")
                shift
                export CONTINUE=1
                shift
                break
                ;;
            *)
                echo "Unknown arg: $1"
                exit 1
                ;;
        esac
    done
}

parse_args "$@"

msg="$@"

./endpoints.sh "$msg"
