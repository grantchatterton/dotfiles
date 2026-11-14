---
name: bash-scripts
description: Guidance for writing bash scripts. Use when creating or updating bash scripts.
---

# bash-scripts

## General

Include high-value/helpful comments throughout scripts.

## Header

Start scripts with (at the top):

```bash
#!/usr/bin/env bash
set -euo pipefail
# ...
```

## Style

Use **2 spaces** for each level of indentation.

Wrap variables/values in double-quotes unless you have a specific reason not to:

```bash
input="$(cat)"
foo="$input"
# ...
```

Use double-brackets for `if` statements:

```bash
foo="bar"
if [[ "$foo" == "bar" ]]; then
  # ...
fi
```

## JSON

Use `jq` for dealing with JSON data:

```bash
input="$(cat)"
file_path="$(jq -r '.tool_input.file_path // empty' <<<"$input")"
# ...
```
