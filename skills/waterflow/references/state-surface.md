# State surface

Where **work items** live. Skills call the four operations below and never touch
a path, a URL, or a file format — that is what lets Waterflow install into a
repository that already has a process instead of demanding a new one.

The binding is resolved once, by `setup-waterflow`, and recorded in
`.waterflow/config.md`.

## Not the impression store

Two surfaces, one adapter each, and keeping them apart matters:

| | State surface | Impression store |
|---|---|---|
| Holds | work items: what to do, what is blocked, what is done | what the flow learned |
| Written by | `slice`, `land` | every atom |
| Lives | wherever the team already tracks work | always local files, versioned with the code |
| Contract | this file | [impressions.md](impressions.md) |

Impressions stay local even when the tracker is remote. They are claims about the
code, so they belong beside it and travel with a clone.

## The operations

| Operation | Takes | Returns |
|---|---|---|
| `create_item` | title, body, subject, blockers | the new item's id |
| `get_item` | id | the item, or nothing |
| `list_frontier` | subject (optional) | open items whose blockers are all closed |
| `close_item` | id, proof state, revision | nothing |

An **item** carries: `id`, `title`, `body`, `subject`, `blockers` (item ids),
`state` (`open` / `closed`). Anything else the underlying tracker holds is the
tracker's business and Waterflow does not read or write it.

`list_frontier` is the only non-obvious one, and it is the one that earns the
contract. It answers "what can be worked on right now" — open, and nothing
unfinished in front of it. Blocking edges come from `slice`; the frontier is what
makes them mean something rather than decorate the list.

## Adapters

**Local markdown (default).** Chosen as the default because it needs no account,
no network, and no permission, and it diffs. One file per item at
`.waterflow/items/<id>.md`:

```
---
id:       checkout-a4f2
title:    Reject an expired card at checkout
subject:  checkout
blockers: [checkout-9c11]
state:    open
---
A customer whose card expired before the order is placed sees the card
rejected at the payment step, with the reason named, and the cart intact.
```

| Field | Meaning |
|---|---|
| `id` | `<subject>-<4 hex>`. Matches the filename. Never reused. |
| `title` | One line, behaviour from the caller's point of view. |
| `subject` | The kebab-case noun this item belongs to. Same vocabulary as an impression's `subject`. |
| `blockers` | Ids that must be `closed` before this can start. `[]` when it can start now. |
| `state` | `open` or `closed`. |
| `proof` | Closed items only. `pass` / `fail` / `blocked`, from the `prove` record. |
| `revision` | Closed items only. The revision the proof ran at. |

The body is the description. It says what the slice delivers end to end, in the
project's own words, and avoids file paths and code snippets — they go stale
faster than the item does.

The id embeds the subject so a `blockers` list reads without a lookup, and the
four hex characters keep two branches from colliding on the same number. This is
the same shape as an impression id for the same reason.

### The operations, concretely

**`create_item`** — allocate an id, write the file, return the id. Write in
dependency order so a blocker exists before anything names it.

**`get_item`** — read `.waterflow/items/<id>.md`. Missing file is "nothing",
not an error.

**`close_item`** — set `state: closed` and add `proof` and `revision` from the
`prove` record. Never close without both: an item closed with no recorded proof
is the exact claim this design exists to prevent.

**`list_frontier`** — open items whose blockers are all closed:

```sh
for f in .waterflow/items/*.md; do
  grep -q '^state: *open *$' "$f" || continue
  blockers=$(sed -n 's/^blockers: *//p' "$f" | tr -d '[]' | tr ',' ' ')
  ready=yes
  for b in $blockers; do
    grep -q '^state: *closed *$' ".waterflow/items/$b.md" 2>/dev/null || ready=no
  done
  [ "$ready" = yes ] && echo "$f"
done
```

A blocker id naming a file that does not exist counts as **not closed**. A
dangling reference is a mistake in the breakdown, and treating it as satisfied
would let a slice start on a blocker nobody wrote.

**GitHub Issues.** `create_item` opens an issue; `subject` becomes a label;
`blockers` are recorded as a task list in the body; `list_frontier` filters open
issues whose listed blockers are all closed; `close_item` closes the issue with
the proof state and revision in the closing comment. Uses `gh`.

## Mapping onto an existing process

The common case is a repository that already tracks work. Do not replace it.
`setup-waterflow` maps the four operations onto what is there and writes the
mapping into config — the file that holds the backlog, the field that carries
blocking, the convention for done.

Two things have to be resolved for the mapping to hold:

- **Where blocking lives.** If the existing process has no way to say one item
  blocks another, `list_frontier` degenerates into "all open items". Say so at
  setup rather than pretending the frontier is real. Adding a blocking
  convention is a small change and worth proposing.
- **What closed means.** If closing is a human action in a tool Waterflow cannot
  reach, `close_item` records the proof state locally and reports what the human
  must do. It never claims a close it did not perform.

When the mapping cannot be made honestly, fall back to the local adapter for
Waterflow's own items and leave the existing tracker alone. Two lists is a worse
outcome than one, but a list that lies is worse than both.
