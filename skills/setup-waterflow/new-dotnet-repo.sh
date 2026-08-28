#!/bin/sh
# Spawn a new .NET solution with Waterflow already bound to it.
#
#   new-dotnet-repo.sh <Name> [parent-directory]
#
# Creates the solution, a library and an xunit test project, a git repository,
# the Waterflow config, the impression store, the proof gate, and a CLAUDE.md
# pointing at the router. Ends on a repository you can route work in
# immediately, with nothing left to answer.
#
# Waterflow itself is not copied in: the launchers point Claude at this
# checkout with --plugin-dir, so edits here are live in the new repository.
#
# Requires: dotnet, git.

set -e

NAME=$1
PARENT=${2:-.}

usage() {
  echo "usage: new-dotnet-repo.sh <Name> [parent-directory]" >&2
  echo "  Name must be a valid .NET project name, e.g. Checkout or Acme.Billing" >&2
}

[ -n "$NAME" ] || { usage; exit 2; }
case "$NAME" in
  *[!A-Za-z0-9._-]* | .* | -*) echo "new-dotnet-repo: '$NAME' is not a usable project name" >&2; usage; exit 2 ;;
esac

command -v dotnet >/dev/null 2>&1 || { echo "new-dotnet-repo: dotnet is not on PATH" >&2; exit 1; }
command -v git    >/dev/null 2>&1 || { echo "new-dotnet-repo: git is not on PATH" >&2; exit 1; }

# Resolve this script's directory so the gate is copied from beside it, and the
# checkout root above it, which is what the launchers point --plugin-dir at.
SKILL_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
GATE=$SKILL_DIR/proof-gate.sh
WF_DIR=$(CDPATH= cd -- "$SKILL_DIR/../.." && pwd)

ROOT=$PARENT/$NAME
[ -e "$ROOT" ] && { echo "new-dotnet-repo: $ROOT already exists" >&2; exit 1; }

echo "waterflow: creating $ROOT"
mkdir -p "$ROOT"
cd "$ROOT"

# --- solution ----------------------------------------------------------------
dotnet new sln -n "$NAME" >/dev/null
dotnet new classlib -o "src/$NAME" >/dev/null
dotnet new xunit -o "tests/$NAME.Tests" >/dev/null
dotnet sln add "src/$NAME/$NAME.csproj" >/dev/null
dotnet sln add "tests/$NAME.Tests/$NAME.Tests.csproj" >/dev/null
dotnet add "tests/$NAME.Tests/$NAME.Tests.csproj" reference "src/$NAME/$NAME.csproj" >/dev/null
echo "waterflow: solution, library and test project created"

# --- git ---------------------------------------------------------------------
dotnet new gitignore >/dev/null 2>&1 || printf 'bin/\nobj/\n' > .gitignore

# Impressions are parsed line by line and the gate is POSIX sh. A CRLF checkout
# breaks both, and .NET repositories are disproportionately cloned on Windows.
cat > .gitattributes <<'ATTR'
* text=auto

# Waterflow: the store is parsed line by line and the hook is POSIX sh. Neither
# survives a CRLF checkout on a POSIX host.
*.sh    text eol=lf
*.md    text eol=lf
ATTR

git init -q
echo "waterflow: git repository initialised"

# --- waterflow state ---------------------------------------------------------
mkdir -p .waterflow/items .waterflow/impressions
: > .waterflow/items/.gitkeep
: > .waterflow/impressions/.gitkeep

cat > .waterflow/config.md <<'CONFIG'
# Waterflow config

| Setting | Value |
|---|---|
| state surface | local markdown |
| items path | .waterflow/items/ |
| impressions path | .waterflow/impressions/ |
| authority label | the owner |
| default proof | dotnet test |

## Mapping notes

Blocking: `blockers` in each item's frontmatter, ids of items that must close first.
Closed: `state: closed` plus the proof state and revision, written by `land`.
CONFIG
echo "waterflow: config and impression store written"

# --- proof gate --------------------------------------------------------------
if [ -f "$GATE" ]; then
  cp "$GATE" .git/hooks/pre-commit
  chmod +x .git/hooks/pre-commit
  echo "waterflow: proof gate installed (WATERFLOW_GATE=warn to override a refusal)"
else
  echo "waterflow: proof-gate.sh not found beside this script; gate not installed" >&2
fi

# --- agent instructions ------------------------------------------------------
cat > CLAUDE.md <<AGENTMD
# $NAME

A .NET solution. \`src/$NAME\` is the library, \`tests/$NAME.Tests\` is xunit.

Build and test:

\`\`\`
dotnet build
dotnet test
\`\`\`

## Waterflow

Route non-trivial work with \`/waterflow\` before starting it. It sets lane, model
tier, agent topology, proof, and owner, and reports all five.

Before deriving a fact about an area, \`recall\` it. After a change, \`prove\` it.
The default proof here is \`dotnet test\`. Configuration is in
\`.waterflow/config.md\`.
AGENTMD

# --- local launcher ----------------------------------------------------------
# Waterflow is loaded from the checkout this script lives in, not copied into
# the new repository. --plugin-dir is per-session, so the launcher is how you
# start Claude here. Edits to the checkout are live on the next session.
#
# claude is a native binary on Windows and will not resolve an msys /c/... path,
# so both launchers use the native form when cygpath can produce one.
# Not `a && b`: that is the whole statement, so a missing cygpath would fail it
# and set -e would abort the script on every non-Windows host.
WF_WIN=$WF_DIR
if command -v cygpath >/dev/null 2>&1; then
  WF_WIN=$(cygpath -m -- "$WF_DIR")
fi

cat > wf.sh <<LAUNCH
#!/bin/sh
# Start Claude Code with Waterflow loaded from the local checkout.
exec claude --plugin-dir "$WF_WIN" "\$@"
LAUNCH
chmod +x wf.sh

cat > wf.cmd <<LAUNCH
@echo off
rem Start Claude Code with Waterflow loaded from the local checkout.
claude --plugin-dir "$WF_WIN" %*
LAUNCH

# The launchers hold an absolute path to one machine's checkout. Local only.
printf '\n# Waterflow local launchers: machine-specific absolute paths.\nwf.sh\nwf.cmd\n' >> .gitignore
echo "waterflow: wf.sh / wf.cmd load --plugin-dir $WF_WIN (gitignored)"

# --- first commit ------------------------------------------------------------
git add -A
git -c user.useConfigOnly=false commit -qm "Scaffold $NAME with Waterflow" \
  || echo "waterflow: nothing committed; set user.name and user.email, then commit" >&2

echo
echo "waterflow: $NAME is ready."
echo "  cd $ROOT"
echo "  dotnet test                 the default proof"
echo "  ./wf.sh                     start Claude with Waterflow loaded"
echo "  /waterflow <what you want>  route the first piece of work"
