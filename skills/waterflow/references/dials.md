# The dials

Five settings, chosen at the start of every non-trivial piece of work and
reported visibly. Together they answer: how much process, how much model, how
many agents, what closes it, and who decides.

| Dial | Question | Values |
|---|---|---|
| **Lane** | How much process? | `direct` / `align` / `shape` / `build` — [lanes.md](lanes.md) |
| **Tier** | How much model? | `best` / `good` / `normal` / `low` — [model-tiers.md](model-tiers.md) |
| **Topology** | How many agents, what shape? | `inline` / `subagent` / `fan-out` / `background` / `fresh` — [topology.md](topology.md) |
| **Proof** | What closes this? | a named command, test, artifact, review, or human check — [proof.md](proof.md) |
| **Owner** | Who decides? | `agent` / `agent recommends` / `human` — [decision-rights.md](decision-rights.md) |

Report all five, in that order, before starting. A dial you did not think about
gets its default; a dial you did think about and set low is a decision, and the
visible setting is what makes it reviewable.

## Escalate

Move Lane, Tier, and Owner up together when any of these is true:

- the work touches **product direction** or what the thing should be;
- it settles **architecture** or a decision that is hard to reverse;
- the **seam is unclear**, so there is no obvious place to prove the change;
- the **evidence conflicts** — two sources disagree and the disagreement matters;
- **rework would be expensive** if the first answer is wrong.

Escalation is cheap and reversible. Under-routing is neither: the cost shows up
after the work is built on top of the wrong answer.

## Downgrade

Move them down when all three are true: the decision is **already made**, the
change is **mechanical**, and the result is **easy to verify**. Renaming a config
key across a repository is the shape — settled, mechanical, checked by a command.

## Re-route

The dials are set at the start, not fixed for the duration. Re-route when the
work turns out to be different from what was routed: a `direct` task that reveals
an unclear seam becomes `align`, and saying so out loud is the point. Silent
drift into more process is the failure mode; announced re-routing is the flow
working.
