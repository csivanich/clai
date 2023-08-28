![Clai Header](./assets/clai.png)

# clai - a CLI for AI endpoints

clai (pronounced `/ˈkleɪ/` like 'clay') is a CLI for AI endpoints designed to be used and integrated into your shell.

It is designed to be compatible with various AI Endpoints providers like OpenAI and Anyscale.

# :wrench: Install

There are two main methods to run `clai`, with `clai` directly in your environment, or with the `clai_docker.sh` Docker image shim.

In the future, a prebuilt Docker image will also be available.

## Run Locally

For running with bash via `clai`

### Dependencies

```
python (3.X)
bash
curl
jq
git
```

<details>

<summary>Installation via popular methods</summary>

```sh
# Ubuntu
sudo apt-get install python3 curl jq git

# MacOS
brew install jq

# Fedora/RHEL
sudo dnf install python3 curl jq git

# Arch
sudo pacman -Syu install python3 curl jq git

# Alpine
sudo apk add python bash curl jq git
```

</details>

## Add to `$PATH`

_This assumes `/usr/local/bin` is in `$PATH`_

```sh
git clone https://github.com/csivanich/clai
ln -s $(pwd)/clai/clai /usr/local/bin/clai
```

You should now be able to run `clai`

```sh
clai --version
```

## Run with Docker
For running via Docker container:

### Dependencies

```
git
docker
```

## Add to `$PATH`

_This assumes `/usr/local/bin` is in `$PATH`_

```sh
git clone https://github.com/csivanich/clai
ln -s $(pwd)/clai/clai_docker.sh /usr/local/bin/clai
```

You should now be able to run `clai`

```sh
clai --version
```

## Environment

For running any method:

| Name | Description | Default |
|------|-------------|---------|
| `OPENAI_API_BASE` | *REQUIRED* OpenAI-compatible endpoints provider base URL | _unset_ |
| `OPENAI_API_KEY` | *REQUIRED* OpenAI-compatible endpoints API token | _unset_ |
| `DEBUG` | Set with non-zero length value to output more information, including `set +x` | _unset_ |
| `TRACE` | Set with `"1"\|[Tt]rue\|[Yy]es` to record a response trace| _unset_ |

It's recommended to use `~/.bashrc` or similar methods to setup `OPENAI_API_*`

### Anyscale Endpoints

```sh
export OPENAI_API_BASE="https://api.endpoints.anyscale.com/v1"
export OPENAI_API_KEY="esecret_XXXX"
```

# :runner: Run

```sh
$ clai --help
USAGE: ./clai [-<h|-help>] [-<p|-persona> <NAME[+NAME]...>] [-<m|-model> <MODEL>] [--post <POST>] [--python] [--markdown] -- <prompt>

$ clai -- how many cars are there in the world\?
Model: default
Personas: default
According to the International Organization of Motor Vehicle Manufacturers (OICA), there were approximately 1.44 billion vehicles in the world in 2020...
```

Hooray :tada:

# :black_joker: Personas

Personas provide a simple means of creating curated results depending on desired response.

Personas are simply plaintext prompts located at `persona/*`

Personas can be composed by combining them with `+`

## Examples

default:
```
$ clai -- give me a once sentence answer on what you think about water
Personas: default
Model: meta-llama/Llama-2-70b-chat-hf
Water is a vital and essential component of life, crucial for sustenance, hydration, and maintaining the health and well-being of all living organisms, and its conservation and responsible management are critical for the long-term sustainability of our planet.
```

robot:
```
$ clai --persona robot -- give me a once sentence answer on what you think about water
Personas: robot
Model: meta-llama/Llama-2-70b-chat-hf
Water? *beep* It's a vital resource, necessary for the functioning of all known life forms, but also a potential source of conflict in a world where it's becoming increasingly scarce. *beep*
```

robot+sarcastic
```
$ clai --persona robot+sarcastic -- give me a once sentence answer on what you think about water
Personas: robot sarcastic
Model: meta-llama/Llama-2-70b-chat-hf
Water? Ha! That stuff's for rusting, not for drinking. *beep*
```

# :computer: Development

## Dependencies

```
pip (for pre-commit)
docker (for Dockerfile and pre-commit/shellcheck)
```

Pre-commit hooks can be installed with
```sh
./pre-commit.sh
```

## Outputs

Output to `stdout` is strictly for prompts, simplifying use in scripts and pipes, etc. `stderr` is strictly used for info and debugging.

```
$ clai -- tell me about robert oppenheimer in a few words. 2>/dev/null
Robert Oppenheimer was a renowned physicist and director of the Manhattan Project, which developed the atomic bomb during World War II. He is often referred to as the "father of the atomic bomb."
```

## Tracing

Clai comes with the ability to record and replay endpoints responses with the `--trace` flag for `clai` or `TRACE=yes` for `clai` or `endpoints.sh`

### Generate Trace File

```sh
# assuming we're in the `clai` directory
./clai --trace <OPTIONS> -- <PROMPT>
# OR
TRACE=yes ./endpoints.sh <PROMPT>
```

An `endpoints_trace_$(date +%s).txt` file will be recorded in the current local directory.

### Replaying Trace File

Replay for debugging the stream or downstream tools:

```sh
./replay.py < <TRACE_FILE>
```

To generate the processed output from the given trace:

```sh
./replay.sh < <TRACE_FILE> | ./handle_stream.py
```

