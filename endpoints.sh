#!/usr/bin/env bash

[[ -n "$DEBUG" ]] && set -x

set -Eeuo pipefail

if ! which pv &>/dev/null;then
    pv(){
        cat
    }
fi

# shellcheck disable=SC2155
if [[ -z "${CLAI_DIR:-}" ]];then
    SOURCE=${BASH_SOURCE[0]}
    while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
      SOURCE=$(readlink "$SOURCE")
      [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    export CLAI_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
fi

MODELS_DIR="${MODELS_DIR:-${CLAI_DIR}/models}"

json(){
    jq -Rrs .
}

model(){
    local _model="${MODEL:-default}"
    echo "Model: $_model" >&2
    cat "$MODELS_DIR/$_model"
}

message(){
    # template and render the string into jq which validates it
    jq . <<-EOL
        {
            "model": "$(model | json)",
            "messages": [
                {"role": "system", "content": "$(persona | json)"},
                {"role": "user", "content": "$@"}
            ],
            "stream": true,
            "temperature": $(json <<< "${TEMPERATURE:-0.7}"),
            "seed": "${SEED:-$(date +%s)}"
        }
EOL
}

query(){
    stream "$@" \
        | tee "$HOME/.cache/.endpoints_last.json" \
        | trace \
        | "$CLAI_DIR/handle_stream.py" \
        | tee "$HOME/.cache/.endpoints_last"
}

affirmative(){
    case "$1" in
        "1"|[Yy]es|[Tt]rue)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

trace(){
    if affirmative "${TRACE:-}"; then
        trace_file="endpoints_trace_$(date +%s).txt"
        "$CLAI_DIR/record.py" "$trace_file"
        echo "Trace: $trace_file" >&2
    else
        cat -
    fi
}

stream(){
    curl -NfSs "$OPENAI_API_BASE/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$(message "$@")"
}

persona(){
    PERSONAS="$(tr '+' ' ' <<< "${PERSONA:-default}")"
    echo "Personas: $PERSONAS" >&2
    (
        for p in ${PERSONAS};do
            cat "$CLAI_DIR/persona/$p"
        done
    ) | tr -d '\n'
}

query "${@:-$(cat -)}"
