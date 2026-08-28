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
   state and the revision, and **re-anchor** the records this run proved to that
   same revision — see
   [impressions.md](../waterflow/references/impressions.md).

**Done when** every slice in the work is closed on the state surface and the
proof state recorded against the integrated revision is `pass`, with no record
this run proved left anchored before the work it describes.

Do not land on a `fail` or a `blocked`. Do not land on a `pass` that is stale or
anchored `unborn` — re-run it. See
[proof.md](../waterflow/references/proof.md).

**Report** the block last:
[reporting.md](../waterflow/references/reporting.md).
