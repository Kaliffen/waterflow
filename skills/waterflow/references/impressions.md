# Impressions

The single emission contract. Every atom writes records in this shape; no atom
restates the schema. Change the shape here and it changes everywhere.

An **impression** is one typed record of something the flow settled: a seam that
was confirmed, a term that was defined, a proof that ran. Records are a byproduct
of doing the work, never a curation task. If a step ever asks a human to tidy the
store, that step is wrong.

The point is that context becomes *queried* rather than *loaded*. Briefing a cold
subagent is "the live records tagged `checkout`", not a pasted conversation.

## Where records live

One file per record, at `.waterflow/impressions/<id>.md`, committed alongside the
code. The path is set at setup and read from `.waterflow/config.md`; everything
else here is fixed.

Records are plain files and retrieval is `grep`. No index, no database, no
embeddings — the store has to survive being copied into any repository on any
host.

## The record

```
---
id:         2026-08-28-a4f2
atom:       seam
subject:    checkout
lane:       build
tier:       good
revision:   9f3c1ab
scope:      [src/checkout/, src/payment/gateway.ts]
supersedes: [2026-08-14-c81b]
tags:       [seam, checkout, payment]
---
Checkout talks to the payment gateway through PaymentPort, so tests fake the
port and never the HTTP client.

Confirmed with the owner. The alternative seam, faking fetch, was rejected
because it couples every test to the wire format.
```

| Field | Required | Meaning |
|---|---|---|
| `id` | always | `YYYY-MM-DD-<4 hex>`. Matches the filename. Never reused. |
| `atom` | always | The atom that emitted. One of the shipped atom names. |
| `subject` | always | One kebab-case noun the record is about. |
| `lane` | always | The lane in force. See [lanes.md](lanes.md). |
| `tier` | always | The tier in force. See [model-tiers.md](model-tiers.md). |
| `revision` | always | `git rev-parse --short HEAD` at emission. The freshness anchor. |
| `scope` | always | Paths the claim depends on. `[]` when the claim is not about code. |
| `supersedes` | always | Ids this record replaces. `[]` when it replaces nothing. |
| `tags` | always | Retrieval axes. See the tag rule below. |
| `state` | `prove` only | `pass` / `fail` / `blocked`. See [proof.md](proof.md). |

The body is a **gist line** — one sentence, the finding itself — then detail
below it. Retrieval shows gists; detail is read only when a gist looks relevant.
Write the gist so it is useful alone.

## The tag rule

Tags exist to be grepped, so the vocabulary has to stay closed. A tag must be one
of:

- the emitting atom's name;
- this record's own subject;
- a subject that already appears in the store.

Nothing invented. A freeform tag is unfindable by anyone who did not write it,
and a growing tag vocabulary is the taxonomy tax this design exists to avoid.

## Emitting

Every atom that **settles** something emits. `recall` is the one exception: it is
the read half of the store and writes nothing, so a composite opening with
`recall` is not skipping an emission. Nothing else is exempt.

1. **Recall first.** Query for live records with the same `atom` and `subject`.
2. **Supersede what you replace.** If a live record makes the same kind of claim
   about the same subject, its id goes in `supersedes`. This is the eviction
   mechanism: without it the store becomes the sediment it exists to prevent.
   Superseded files are not deleted — the trail stays readable.
3. **Emit one record per operation.** Not one per file touched, not one per turn.
4. **Set `scope` to what the claim depends on**, not to everything the operation
   read. A seam record scopes to the modules the seam sits between. A glossary
   decision scopes to `[]`.

Do not emit when the operation settled nothing: a question asked and not
answered, a search that found nothing, a step that only restated what a live
record already says. An empty record costs retrieval attention forever.

## Retrieving

Live records tagged `checkout`, newest first:

```sh
grep -rlE 'tags: *\[([^]]*, *)?checkout( *,|\])' .waterflow/impressions/ | sort -r
```

Tags are kebab-case, so the pattern anchors on the list separators rather than
on word boundaries: `\bcheckout\b` would also match `checkout-flow`, since `-`
ends a word. POSIX ERE, so BSD and GNU grep agree.

Then drop the superseded ones. A record is superseded when its id appears in
another record's `supersedes`:

```sh
grep -rh '^supersedes:' .waterflow/impressions/
```

Anything whose id appears in that output is excluded by default. Include
superseded records only when the question is *how* something changed.

## Staleness

A record's claim was true at its `revision`. It is **stale** when a file under
its `scope` has changed since:

```sh
git merge-base --is-ancestor <revision> HEAD 2>/dev/null || echo unreachable
git log --oneline <revision>..HEAD -- <scope paths>
```

Non-empty output means stale. A record with `scope: []` is never stale by code
drift — a settled term or decision is displaced by a human superseding it, not by
a commit landing.

The ancestry check comes first because a rebase, amend, or squash-merge orphans
the anchor, and `git log` against an unreachable revision prints nothing — which
is indistinguishable from a fresh record. Three states, not two: **fresh**,
**stale**, and **freshness unknown**. The third is reported, never rounded down
to the first.

**A stale record is surfaced as stale, never silently served.** Report it as
"stale since `<revision>`" and let the reader decide whether to trust it or
re-derive. An index that lies is worse than no index, and the only defence is
that the store never claims more freshness than it has.
