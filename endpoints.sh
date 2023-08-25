#!/usr/bin/env bash

[[ -n "$DEBUG" ]] && set -x

set -Eeuo pipefail

if ! which pv &>/dev/null;then
    pv(){
        cat
    }
fi

SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
THIS_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

# TODO: make this relative to the script's local directory
MODELS_DIR="${THIS_DIR}/models"

json(){
    jq -Rrs .
}

model(){
    local _model="${MODEL:-default}"
    echo "Model: $_model" >&2
    cat $MODELS_DIR/$_model
}

message(){
    jq . <<-EOL
        {
            "model": "$(model | json)",
            "messages": [
                {"role": "system", "content": "$(persona | json)"},
                {"role": "user", "content": "$@"}
            ],
            "temperature": $(json <<< ${TEMPERATURE:-0.0})
        }
EOL
}

query(){
    curl -s "$OPENAI_API_BASE/chat/completions" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d "$(message $@)" \
    | tee $HOME/.cache/.endpoints_last.json \
    | pv - \
    | jq -r '.choices | map(.message.content) | join(" ")' \
    | tee $HOME/.cache/.endpoints_last
}

persona(){
    PERSONAS="$(tr '+' ' ' <<< ${PERSONA:-default})"
    echo "Personas: $PERSONAS" >&2
    (
        for p in ${PERSONAS};do
            cat persona/$p
        done
    ) | tr -d '\n'
}

query "${@:-$(cat -)}"
