#!/bin/bash
jq --slurp --raw-input '{"text": "\(.)", "mode": "markdown"}' < $1 | curl --data @- https://api.github.com/markdown > "$1".html
