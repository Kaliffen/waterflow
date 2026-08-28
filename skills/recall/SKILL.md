---
name: recall
description: Query what the flow already settled about a subject before deriving it again. Use when starting work on an area, briefing a subagent, resuming after a break, or checking whether a question was already answered.
---

# Recall

One operation: query the impression store and report the live records for a
subject. The read half of the store; `prove` and the other atoms are the write
half.

Reach for this **before** exploring. The expensive part of the work is rarely
reading an answer, it is finding one — and a record naming a confirmed seam kills
an entire exploration loop.

## Steps

1. **Pick the tags.** The subject the work is about, plus the atom whose kind of
   answer you want (`seam` for where to test, `define` for terms, `prove` for
   what is already green). Tags are a closed vocabulary — see
   [impressions.md](../waterflow/references/impressions.md).

2. **Query.**

   ```sh
   grep -rl 'tags:.*\bSUBJECT\b' .waterflow/impressions/ | sort -r
   ```

3. **Exclude superseded.** Collect every id named in a `supersedes:` line and
   drop those records. Include them only when the question is how something
   changed, not what is true.

   ```sh
   grep -rh '^supersedes:' .waterflow/impressions/
   ```

4. **Check freshness.** For each surviving record, compare its `revision` and
   `scope` against HEAD:

   ```sh
   git log --oneline REVISION..HEAD -- SCOPE
   ```

   Non-empty output means stale. A record with `scope: []` is never stale this
   way.

5. **Report gists, newest first.** One line each: the gist, the atom, and the
   date. Mark stale records as **stale since `<revision>`**. Read a record's
   detail only when its gist looks relevant to the work in hand.

6. **Say when there is nothing.** "No live records for `<subject>`" is a useful
   answer that stops the reader assuming coverage exists. Do not pad with
   near-misses from other subjects.

## Briefing with recall

This is what the store is for. When dispatching a subagent, pass the live gists
for the subject instead of a transcript — a few hundred tokens of settled facts
rather than thousands of conversation. If the subagent turns out to need the
transcript anyway, something was settled without being emitted; name it, so the
gap gets fixed.

## Never serve a stale record as current

An index that lies is worse than no index. If everything for a subject is stale,
say so plainly and re-derive. Stale records still help — they say where to look —
but they are a starting point, never an answer.

## Emitting

`recall` reads; it does not write. A query that finds nothing is not a finding
worth a record.
