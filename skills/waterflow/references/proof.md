# Proof

The Proof dial answers **what closes this**. It is named before the work starts,
not chosen afterwards from whatever happened to pass.

A proof is a specific, runnable, reportable thing:

- a **command** — `npm test`, `cargo check`, a named script;
- a **test** at an agreed seam — see the `seam` and `test` atoms;
- an **artifact** that exists or does not — a migration applied, a file written;
- a **review** with a stated axis — see the `critique` atom;
- a **human check** the owner performs, when nothing above can stand in.

"It works" is not a proof. Neither is a passing suite that does not touch the
change: proof has to be able to **fail** for the reason the work could be wrong.

## States

| State | Meaning |
|---|---|
| `not run` | Named, not yet executed. The starting state of every piece of work. |
| `pass` | Ran, succeeded, at a known revision. |
| `fail` | Ran, did not succeed. A real result — record it and keep going. |
| `blocked` | Could not run. Missing credential, broken environment, unmet dependency. |

`blocked` is deliberately distinct from `fail`. Collapsing them is how a broken
environment gets mistaken for a broken change, and it hides the one problem that
compounds: proof that has silently stopped running.

## Freshness

A `pass` is a claim about a **revision**, not about the work. It expires when the
code under it moves. That is exactly the `revision` plus `scope` rule in
[impressions.md](impressions.md), and the reason `prove` records both.

Never report a stale pass as a pass. Report it as "passed at `<revision>`, stale
since" and re-run it, which is usually cheap and always cheaper than the
alternative.

## Naming it early

The Proof dial is set at routing time because the answer changes the work.
Knowing that a change closes on a test at a named seam shapes how it is built;
discovering afterwards that nothing can check it means the design already went
wrong. If no proof can be named, that is the finding — say so and escalate rather
than proceeding with the dial left blank.
