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

A pass anchored `unborn` was recorded before any commit existed, so it is not
fresh and not stale — it is unverifiable, and it is re-run on the same terms as
a stale one. See [impressions.md](impressions.md).

## Conditions

A revision is not always the whole anchor. A **measurement** — a timing, a rate,
a throughput — also depends on what it was measured under, and those parameters
do not live in the diff. A proof can therefore be fresh by revision and wrong:
the code has not moved, but the number was taken under conditions nobody wrote
down.

The failure mode is specific and it repeats. A number taken early in a scenario
whose cost rises reports the cheap phase and passes; the same suite measured
later fails. Nobody lied, and re-running does not help, because the run-in is
what varies.

A record describing a measurement may carry `conditions`: the parameters the
number depends on, in the units the work uses — the scenario, the scale, the
seed, how far in it was taken. It is optional, it does not change staleness, and
nothing gates on it. Its whole job is that `recall` shows the phase beside the
number, so the next reader sees what the last one assumed.

## Naming it early

The Proof dial is set at routing time because the answer changes the work.
Knowing that a change closes on a test at a named seam shapes how it is built;
discovering afterwards that nothing can check it means the design already went
wrong. If no proof can be named, that is the finding — say so and escalate rather
than proceeding with the dial left blank.
