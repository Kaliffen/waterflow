#!/bin/sh
# Waterflow proof gate. Install as .git/hooks/pre-commit (or call it from one).
#
# Deterministic, zero-dependency, zero context cost. It does not ask a model
# anything; it reads the impression store and compares it against what is staged.
#
#   block  a live prove record says `fail` for something this commit touches
#   warn   a live prove record says `pass` or `blocked`, and this commit moves
#          code under its scope, so that record no longer describes the tree
#
# Store location, in order: $WATERFLOW_IMPRESSIONS, the `impressions path` row
# of .waterflow/config.md, then .waterflow/impressions.
# Set WATERFLOW_GATE=warn to downgrade blocks to warnings.

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" || exit 0

# CR tolerance throughout: a record committed from a Windows checkout without
# .gitattributes carries a trailing CR that GNU grep does not strip, which would
# silently stop every match below.
field() { sed -n "s/^$1: *//p" "$2" | tr -d '\r' | sed 's/[[:space:]]*$//' | head -1; }

if [ -n "$WATERFLOW_IMPRESSIONS" ]; then
  DIR=$WATERFLOW_IMPRESSIONS
elif [ -f .waterflow/config.md ]; then
  DIR=$(sed -n 's/^|[[:space:]]*impressions path[[:space:]]*|[[:space:]]*\([^|]*\).*/\1/p' \
    .waterflow/config.md | tr -d '\r' | sed 's/[[:space:]]*$//' | head -1)
  [ -n "$DIR" ] || DIR=.waterflow/impressions
else
  DIR=.waterflow/impressions
fi
[ -d "$DIR" ] || exit 0

staged=$(git diff --cached --name-only)
[ -n "$staged" ] || exit 0

# Every id named in any supersedes: line. Those records are not live.
superseded=$(grep -h '^supersedes:' "$DIR"/*.md 2>/dev/null | tr -d '\r' \
  | sed 's/^supersedes: *//' | tr -d '[]' | tr ',' '\n' | tr -d ' \t' | grep -v '^$')

# Where a record's revision sits relative to HEAD. The gate reports what it
# actually knows rather than asserting "older", which was not checked at all.
rev_state() {
  [ -n "$1" ] || { echo unknown; return; }
  git cat-file -e "$1^{commit}" 2>/dev/null || { echo unreachable; return; }
  if [ "$(git rev-parse "$1")" = "$(git rev-parse HEAD)" ]; then
    echo head
  elif git merge-base --is-ancestor "$1" HEAD 2>/dev/null; then
    echo behind
  else
    echo unreachable
  fi
}

blocked=0
warned=0

for f in "$DIR"/*.md; do
  [ -f "$f" ] || continue
  tr -d '\r' < "$f" | grep -q '^atom: *prove *$' || continue

  id=$(field id "$f")
  if [ -n "$superseded" ] && printf '%s\n' "$superseded" | grep -qx "$id"; then
    continue
  fi

  # Only a fact carries a verdict. An observation is a reading and a goal is a
  # target, so neither is a result the gate can act on whatever state it
  # happens to carry. The kinds that do not gate are named one by one, and
  # anything unrecognised gates: an absent kind is a record older than the
  # field, and a misspelt one is a typo that must not be able to switch the
  # gate off silently.
  kind=$(field kind "$f")
  case "$kind" in
    observation | idiom | goal | watermark) continue ;;
  esac

  state=$(field state "$f")
  subject=$(field subject "$f")
  revision=$(field revision "$f")
  scope=$(field scope "$f" | tr -d '[]' | tr ',' ' ')
  [ -n "$scope" ] || continue

  # A scope entry matches a staged path only as a whole path or a directory
  # prefix. Substring matching made scope `api/` fire on `packages/api/b.ts`.
  hit=""
  set -f  # scope/staged are split unquoted below; do not glob their contents
  for p in $scope; do
    [ -n "$p" ] || continue
    p=${p%/}
    [ -n "$p" ] || continue
    oldifs=$IFS
    IFS='
'
    for file in $staged; do
      case "$file" in
        "$p" | "$p"/*) hit=$p ;;
      esac
      [ -n "$hit" ] && break
    done
    IFS=$oldifs
    [ -n "$hit" ] && break
  done
  set +f
  [ -n "$hit" ] || continue

  case "$state" in
    fail)
      echo "waterflow: FAIL recorded for '$subject' covering $hit ($id)" >&2
      blocked=$((blocked + 1))
      ;;
    pass)
      case $(rev_state "$revision") in
        head)
          echo "waterflow: proof for '$subject' passed at $revision, but this commit changes $hit under its scope; re-run prove ($id)" >&2
          ;;
        behind)
          echo "waterflow: proof for '$subject' passed at $revision, which is behind HEAD, and $hit has moved since ($id)" >&2
          ;;
        *)
          echo "waterflow: proof for '$subject' passed at revision '$revision', which is not reachable from HEAD; treat it as unproven ($id)" >&2
          ;;
      esac
      warned=$((warned + 1))
      ;;
    blocked)
      echo "waterflow: proof for '$subject' is blocked and covers $hit ($id)" >&2
      warned=$((warned + 1))
      ;;
  esac
done

if [ "$warned" -gt 0 ]; then
  echo "waterflow: $warned stale or unrun proof(s). Run prove before landing." >&2
fi

if [ "$blocked" -gt 0 ] && [ "${WATERFLOW_GATE:-block}" = "block" ]; then
  echo "waterflow: $blocked failing proof(s) cover staged files. Commit refused." >&2
  echo "waterflow: re-run the proof, or WATERFLOW_GATE=warn git commit to override." >&2
  exit 1
fi

exit 0
