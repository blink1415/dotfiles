#!/usr/bin/env bash
# Open the given file:line in the project's git remote (github/gitlab).
# Usage: open-in-remote.sh <file> <line>
# Silently exits if not in a git repo or remote can't be resolved.

set -e

file="$1"
line="$2"

[ -n "$file" ] || exit 0

dir=$(dirname "$file")
[ -d "$dir" ] || exit 0
cd "$dir"

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

remote=$(git config --get remote.origin.url) || exit 0
[ -n "$remote" ] || exit 0

base=$(printf '%s' "$remote" | sed -E 's#^git@([^:]+):#https://\1/#; s#\.git$##')

case "$base" in
  *gitlab*) segment="-/blob" ;;
  *)        segment="blob" ;;
esac

# Pick a ref that actually exists on origin:
#   1. commit SHA, if origin contains it (stable, no slash ambiguity)
#   2. else origin's default branch (HEAD)
sha=$(git rev-parse HEAD)
if git branch -r --contains "$sha" 2>/dev/null | grep -q '^[[:space:]]*origin/'; then
  ref="$sha"
else
  ref=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')
  [ -z "$ref" ] && ref=$(git remote show origin 2>/dev/null | awk '/HEAD branch/ {print $NF}')
  [ -z "$ref" ] && exit 0
fi

rel=$(git ls-files --full-name -- "$(basename "$file")")
[ -n "$rel" ] || exit 0

url="$base/$segment/$ref/$rel#L$line"

case "$(uname)" in
  Darwin) open "$url" ;;
  *)      xdg-open "$url" ;;
esac
