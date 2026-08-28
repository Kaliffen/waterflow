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
   state and the revision.

**Done when** every slice in the work is closed on the state surface and the
proof state recorded against the integrated revision is `pass`.

Do not land on a `fail` or a `blocked`. Do not land on a stale `pass` — re-run
it, which is cheap, and always cheaper than the alternative.

**Report** the block last:
[reporting.md](../waterflow/references/reporting.md).
