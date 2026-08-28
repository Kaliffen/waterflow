---
name: land
description: Integrate finished work after a final review and a fresh proof.
argument-hint: "<what to land>"
disable-model-invocation: true
---

# Land

Run these atoms in order.

1. **`critique`** against the integration point, not against the last commit.
   The diff that matters is everything going in.
2. **`prove`** — run the proof again, now. A pass recorded at an earlier revision
   is not evidence about this one.
3. **Integrate**, then `close_item` for every slice included, with the proof
   state and the revision, and **re-anchor** every record and item in the work
   being landed whose anchor predates what it describes — including the ones
   emitted and closed earlier in the build, which are most of them. See
   [impressions.md](../waterflow/references/impressions.md).
4. **Consolidate** each subject this work finished — one that had items and now
   has none open. What is spent leaves the store and what survives has its kind
   settled. See the fold in
   [impressions.md](../waterflow/references/impressions.md).

**Done when** every slice in the work is closed on the state surface, the proof
state recorded against the integrated revision is `pass`, nothing in the landed
work is still anchored before the work it describes, and any subject the work
finished has been consolidated.

Do not land on a `fail` or a `blocked`. Do not land on a `pass` that is stale or
anchored `unborn` — re-run it. See
[proof.md](../waterflow/references/proof.md).

**Report** the block last:
[reporting.md](../waterflow/references/reporting.md).
