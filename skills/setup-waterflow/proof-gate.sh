#!/bin/sh
# Waterflow proof gate. Install as .git/hooks/pre-commit (or call it from one).
#
# Deterministic, zero-dependency, zero context cost. It does not ask a model
# anything; it reads the impression store and compares it against what is staged.
#
#   block  a live prove record says `fail` for something this commit touches
#   warn   a live prove record says `pass`, but this commit moves code under its
#          scope, so that pass no longer describes the tree
#
# Set WATERFLOW_IMPRESSIONS to override the store path.
# Set WATERFLOW_GATE=warn to downgrade blocks to warnings.

DIR="${WATERFLOW_IMPRESSIONS:-.waterflow/impressions}"
[ -d "$DIR" ] || exit 0

staged=$(git diff --cached --name-only)
[ -n "$staged" ] || exit 0

# Every id named in any supersedes: line. Those records are not live.
superseded=$(grep -h '^supersedes:' "$DIR"/*.md 2>/dev/null \
  | sed 's/^supersedes: *//' | tr -d '[]' | tr ',' '\n' | tr -d ' \t' | grep -v '^$')

blocked=0
warned=0

for f in "$DIR"/*.md; do
  [ -f "$f" ] || continue
  grep -q '^atom: *prove *$' "$f" || continue

  id=$(sed -n 's/^id: *//p' "$f" | head -1)
  if [ -n "$superseded" ] && printf '%s\n' "$superseded" | grep -qx "$id"; then
    continue
  fi

  state=$(sed -n 's/^state: *//p' "$f" | head -1)
  scope=$(sed -n 's/^scope: *//p' "$f" | head -1 | tr -d '[]' | tr ',' ' ')
  subject=$(sed -n 's/^subject: *//p' "$f" | head -1)
  [ -n "$scope" ] || continue

  hit=""
  for p in $scope; do
    [ -n "$p" ] || continue
    case "$staged" in
      *"$p"*) hit="$p"; break ;;
    esac
  done
  [ -n "$hit" ] || continue

  case "$state" in
    fail)
      echo "waterflow: FAIL recorded for '$subject' covering $hit ($id)" >&2
      blocked=$((blocked + 1))
      ;;
    pass)
      echo "waterflow: proof for '$subject' passed at an older revision; $hit has moved ($id)" >&2
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
