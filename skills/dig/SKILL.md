---
name: dig
description: Investigate a question against primary sources and record what was found. Use when documentation or API facts need gathering, or when reading legwork should be delegated rather than done inline.
source: mattpocock/skills @ 6654f6b — skills/engineering/research/SKILL.md (adapted)
---

# Dig

One operation: answer a factual question from sources that own the fact, and
record the answer where the next loop will find it.

## Recall first

`recall` the subject. Re-deriving a fact the store already holds is the single
most wasteful thing the flow can do, and reading is exactly where it happens.

## Dispatch it

Send the investigation to a **background agent** and keep working. Reading is the
canonical background task: tightly scoped, no steering needed, and slow enough
that waiting wastes the session. See
[topology.md](../waterflow/references/topology.md).

The brief:

1. Investigate against **primary sources** — official documentation, source
   code, specifications, first-party APIs. Not a secondary write-up of them.
   Follow every claim back to the source that owns it.
2. **Cite each claim** with the source it came from, precisely enough to check.
3. Report the findings, and report separately anything the sources do **not**
   settle. An unanswered question named is worth more than a plausible guess.

Name the join point before dispatching, and say when the answer stops being
worth waiting for. What to do when that point arrives with nothing back is the
return leg: [topology.md](../waterflow/references/topology.md).

A background agent that reports nothing is not a dig that found nothing. Report
the question as unanswered, emit no record for it, and say the fact is still
open.

## Emit

One record per **settled fact**, `atom: dig`, `subject` the thing the fact is
about, `scope: []`. The gist is the fact; the detail carries the citation and the
date the source was read.

When the material is genuinely long-form — an API surface, a specification
walkthrough — write it to a note file where the repository already keeps such
notes, and emit **one** record whose detail points at that file. Do not split a
long document into forty records, and do not paste a long document into one.

A source that goes stale does so silently, which is why the citation is the part
that matters most. Contract:
[impressions.md](../waterflow/references/impressions.md).
