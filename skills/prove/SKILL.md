---
name: prove
description: Run the named proof for a change and record whether it passed. Use after implementing something, when asked whether a change actually works, or before integrating. Not for writing tests — that is the test atom.
---

# Prove

`prove` **runs** evidence and records it. `test` **writes** a test. If nothing
has been written yet, this is the wrong atom.

One operation: take the proof named at routing time, run it, classify the
result, emit the record.

## Steps

1. **Find the named proof.** It was set as the Proof dial when the work was
   routed. Work that was never routed has none, which is the common case for an
   atom firing on its own: fall back to the repository's own test command and
   report it as inferred. When even that cannot fail for the reason the work
   could be wrong, stop and say so — an unprovable change is a routing finding,
   not something to work around. See
   [proof.md](../waterflow/references/proof.md).

2. **Check for a live record first.** `recall` the subject for existing `prove`
   records. A `pass` at the current revision with unchanged `scope` is already
   proven; report it and stop rather than re-running.

3. **Run it.** Exactly as named. Do not substitute a broader suite for a specific
   test, or a narrower one for a suite — a proof that cannot fail for the reason
   the work could be wrong is not proof of that work.

   If the result is a number rather than a pass or a fail, write down what you
   ran it under as you take it — the scenario, the scale, the seed, how far in.
   Reconstructing that afterwards is guesswork, and a number whose conditions
   went unrecorded is the failure in
   [proof.md](../waterflow/references/proof.md).

4. **Classify.** One of:

   | State | When |
   |---|---|
   | `pass` | Ran and succeeded. |
   | `fail` | Ran and did not succeed. |
   | `blocked` | Could not run: missing credential, broken environment, unmet dependency. |

   Keep `blocked` distinct from `fail`. Reporting a broken environment as a
   broken change sends the next hour in the wrong direction.

5. **Emit.** One record, `atom: prove`, carrying `state`, the `revision` it ran
   at, and `scope` set to the paths the proof actually covers. This atom is the
   only one that emits two kinds: a verdict is a `fact`, and a result with
   nothing it could have failed against is an `observation`. A number does not
   decide that — a timing checked against a named budget is a verdict. Either
   may carry `conditions`; see
   [proof.md](../waterflow/references/proof.md). Supersede the
   previous `prove` record for the same subject. Contract:
   [impressions.md](../waterflow/references/impressions.md).

6. **Report** the state, the command, and the revision — this atom's units for
   the line in [impressions.md](../waterflow/references/impressions.md). On
   `fail`, report what failed and stop — do not start fixing it under the same
   routing. On `blocked`, report what is missing.

## Do not

Do not adjust the proof to make it pass. A proof changed to accommodate the code
proves the code changed. If the proof is genuinely wrong, say that, and treat
fixing it as its own work with its own routing.
