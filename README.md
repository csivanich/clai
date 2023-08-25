# clai - a CLI for AI endpoints

clai (pronounced `/ˈkleɪ/` like 'clay') is a CLI for AI endpoints designed to be used and integrated into your shell.

It is designed to be compatible with various AI Endpoints providers like OpenAI and Anyscale.

# :warning: Requirements

## Binaries

```
bash
curl
jq
pv (optional)
```

## Environment

| Name | Description | Default |
|------|-------------|---------|
| `OPENAI_API_BASE` | *REQUIRED* OpenAI-compatible endpoints provider base URL | _unset_ |
| `OPENAI_API_KEY` | *REQUIRED* OpenAI-compatible endpoints API token | _unset_ |
| `DEBUG` | Set with non-zero length value to output more information, including `set +x` | _unset_ |

# :wrench: Setup

## Install any dependencies
```sh
# Ubuntu
sudo apt-get install bash curl jq pv

# MacOS
sudo brew install bash curl jq pv

# Fedora/RHEL
sudo dnf install bash curl jq pv

# Arch
sudo pacman -Syu install bash curl jq pv

# Alpine
sudo apk add bash curl jq pv
```

## Clone the repo and add `clai` to your `$PATH`

_This assumes `/usr/local/bin` is in `$PATH`_

```sh
git clone https://github.com/csivanich/clai
ln -s /usr/local/bin/clai $(pwd/clai/clai)
```

## Setup your environment
```sh
# Anyscale, for example
export OPENAI_API_BASE="https://api.endpoints.anyscale.com/v1"
export OPENAI_API_KEY="YOUR_TOKEN"
```

# :runner: Run

```sh
$ clai --help
USAGE: ./clai [-<h|-help>] [--post <POST>] [-<p|-persona> <NAME[+NAME]...>] [-<m|-model> <MODEL>] [--python] [--markdown] -- <prompt>

$ clai -- how many cars are there in the world\?
Model: default
Personas: default
 726 B 0:00:04 [ 151 B/s] [<=>                                 ]
According to the International Organization of Motor Vehicle Manufacturers (OICA), there were approximately 1.44 billion vehicles in the world in 2020...
```

Hooray :tada:

# :clown: Personas

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

# Output

Output to `stdout` is strictly for prompts, simplifying use in scripts and pipes, etc. `stderr` is strictly used for info and debugging.

```
$ clai -- tell me about robert oppenheimer in a few words. 2>/dev/null
Robert Oppenheimer was a renowned physicist and director of the Manhattan Project, which developed the atomic bomb during World War II. He is often referred to as the "father of the atomic bomb."
```
