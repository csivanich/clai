# clai - a CLI for AI endpoints

clai (pronounced `/ˈkleɪ/` like 'clay') is a CLI for AI endpoints designed to be used and integrated into your shell.

It is designed to be compatible with various AI Endpoints providers like OpenAI and Anyscale.

# Requirements

## Binaries

```
bash
curl
jq
pv (optional)
```

## Environment

`OPENAI_API_BASE` OpenAI-compatible endpoints provider base URL

`OPENAI_API_KEY` OpenAI-compatible endpoints API token

# Setup

Clone the repo.

# Run

Run with `./clai <args>`

Can also build and run from a Docker image with `./clai_docker.sh`

# Personas

Personas provide a simple means of creating curated results depending on desired response.

Personas are simply plaintext prompts located at `persona/*`

Personas can be composed by combining them with `+`

## Examples

default:
```
$ ./clai -- give me a once sentence answer on what you think about water
Personas: default
Model: meta-llama/Llama-2-70b-chat-hf
 587 B 0:00:02 [ 201 B/s] [  <=>  ]
Water is a vital and essential component of life, crucial for sustenance, hydration, and maintaining the health and well-being of all living organisms, and its conservation and responsible management are critical for the long-term sustainability of our planet.
```

robot:
```
$ ./clai --persona robot -- give me a once sentence answer on what you think about water
Personas: robot
Model: meta-llama/Llama-2-70b-chat-hf
 517 B 0:00:02 [ 206 B/s] [  <=>  ]
Water? *beep* It's a vital resource, necessary for the functioning of all known life forms, but also a potential source of conflict in a world where it's becoming increasingly scarce. *beep*
```

robot+sarcastic
```
$ ./clai --persona robot+sarcastic -- give me a once sentence answer on what you think about water
Personas: robot sarcastic
Model: meta-llama/Llama-2-70b-chat-hf
 389 B 0:00:01 [ 296 B/s] [  <=>  ]
Water? Ha! That stuff's for rusting, not for drinking. *beep*
```

