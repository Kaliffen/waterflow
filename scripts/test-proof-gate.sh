#!/bin/sh
# Fixture suite for skills/waterflow/proof-gate.sh.
#
# Runs the gate against a throwaway repository, one case per behaviour it is
# supposed to have. Every case here was a real defect or the control that proves
# the fix did not simply silence the check.
#
#   ./scripts/test-proof-gate.sh

GATE=$(cd "$(dirname "$0")/.." && pwd)/skills/waterflow/proof-gate.sh
[ -f "$GATE" ] || { echo "no gate at $GATE" >&2; exit 1; }

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
cd "$WORK" || exit 1

git init -q .
git config user.email test@example.com
git config user.name test
mkdir -p .waterflow/impressions packages/api src
echo x > src/a.ts
echo y > packages/api/b.ts
git add -A
git commit -qm init
REV=$(git rev-parse --short HEAD)

pass=0
fail=0

record() { # state scope revision
  printf -- '---\nid:         2026-08-28-aaaa\natom:       prove\nsubject:    checkout\nlane:       build\ntier:       good\nstate:      %s\nrevision:   %s\nscope:      [%s]\nsupersedes: []\ntags:       [prove, checkout]\n---\nRecord.\n' \
    "$1" "$3" "$2" > .waterflow/impressions/r.md
}

# check <name> <expected exit> <expected substring, or - for no output>
check() {
  name=$1; want_exit=$2; want=$3
  out=$(sh "$GATE" 2>&1); got_exit=$?
  ok=yes
  [ "$got_exit" = "$want_exit" ] || ok=no
  if [ "$want" = "-" ]; then
    [ -z "$out" ] || ok=no
  else
    printf '%s' "$out" | grep -q "$want" || ok=no
  fi
  if [ "$ok" = yes ]; then
    pass=$((pass + 1)); echo "  ok    $name"
  else
    fail=$((fail + 1))
    echo "  FAIL  $name (exit $got_exit, wanted $want_exit)"
    printf '%s\n' "$out" | sed 's/^/          /'
  fi
}

echo "proof-gate fixtures"

echo mod >> packages/api/b.ts
git add packages/api/b.ts

# Scope must match a whole path or a directory prefix, never a substring.
record pass "api/" "$REV"
check "scope 'api/' does not match packages/api/b.ts" 0 -

record pass "packages/api/" "$REV"
check "scope 'packages/api/' does match it" 0 "under its scope"

# A pass recorded at HEAD is not 'an older revision'.
record pass "packages/" "$REV"
check "pass at HEAD does not claim an older revision" 0 "passed at $REV"

# An orphaned anchor is unproven, not fresh.
record pass "packages/" "deadbee"
check "unreachable revision reads as unproven" 0 "not reachable from HEAD"

record blocked "packages/" "$REV"
check "blocked state warns" 0 "is blocked and covers"

record fail "packages/" "$REV"
check "fail refuses the commit" 1 "Commit refused"

WATERFLOW_GATE=warn
export WATERFLOW_GATE
check "WATERFLOW_GATE=warn downgrades the refusal" 0 "FAIL recorded"
unset WATERFLOW_GATE

# A superseded record is not live.
record fail "packages/" "$REV"
printf -- '---\nid:         2026-08-29-bbbb\natom:       prove\nsubject:    checkout\nlane:       build\ntier:       good\nstate:      pass\nrevision:   %s\nscope:      []\nsupersedes: [2026-08-28-aaaa]\ntags:       [prove, checkout]\n---\nSuperseding.\n' "$REV" > .waterflow/impressions/s.md
check "superseded fail is ignored" 0 -
rm -f .waterflow/impressions/s.md

# A CR-terminated record still parses: GNU grep does not strip it.
record fail "packages/" "$REV"
sed 's/$/\r/' .waterflow/impressions/r.md > .waterflow/impressions/r.crlf
mv .waterflow/impressions/r.crlf .waterflow/impressions/r.md
check "CRLF record is still detected" 1 "Commit refused"

# The store is found through config when it is not at the default path.
record fail "packages/" "$REV"
mkdir -p docs/store
mv .waterflow/impressions/r.md docs/store/r.md
printf '# Waterflow config\n\n| Setting | Value |\n|---|---|\n| impressions path | docs/store |\n' > .waterflow/config.md
check "relocated store is found via config.md" 1 "Commit refused"
rm -f .waterflow/config.md
mv docs/store/r.md .waterflow/impressions/r.md

# No store at all is not an error.
rm -rf .waterflow
check "absent store exits clean" 0 -

echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]
