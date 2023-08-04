#!/usr/bin/env bash

[[ -n "$DEBUG" ]] && set -x

set -Eeuo pipefail

export OPENAI_API_BASE="${OPENAI_API_BASE:-https://api.endpoints.anyscale.com/v1}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-$(cat $HOME/.anyscale/endpoints_token.txt)}"

if ! which pv &>/dev/null;then
    pv(){
        cat
    }
fi

sanitize(){
    sed -e 's/"/\"/g' \
    | sed -e 's/\n/\\n/g'
}

message(){
    local _msg=$(sanitize <<< $@)
    local _persona=$(persona | sanitize)
    local _model="meta-llama/Llama-2-70b-chat-hf"
    echo "Model: $_model" >&2
    cat <<-EOL
        {
            "model": "$_model",
            "messages": [
                {"role": "system", "content": "$_persona"},
                {"role": "user", "content": "$_msg"}
            ],
            "temperature": ${TEMPERATURE:-0.0}
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
    | tee $HOME/.cache/.endpoints_last \
    | present
}

present(){
    echo -e "$(cat -)"
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
