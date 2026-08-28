# Model tiers

Tier names are the durable contract. Model names are current examples and will
change, so route by tier and let the mapping drift.

The tier dial is **advisory**: Waterflow reports the tier a phase warrants and
you choose the model. It does not dispatch.

| Tier | Use for | Current example |
|---|---|---|
| `best` | Strategy, architecture, contested scope, hard-to-reverse decisions. | Opus |
| `good` | Review, coding judgement, bounded implementation with real risk. | Sonnet |
| `normal` | Ordinary implementation with clear acceptance criteria and local blast radius. | The host's default coding model |
| `low` | Bookkeeping, status, formatting, deterministic chores. | Haiku |

## Why this is a dial at all

Model strength is usually chosen once per session and then forgotten, which means
the whole session runs at whatever the hardest phase needed — or, more often, at
whatever the easiest one did. Neither is right. A single piece of work crosses
tiers: settling the architecture is `best`, applying the resulting rename is
`low`.

The unit of tiering is the **phase**, not the session or the task.

## Moving between tiers

The escalate and downgrade rules are the ones that govern Lane and Owner too —
see [dials.md](dials.md). Tier moves with them, because the conditions that call
for more process are the conditions that call for more model.

Two tier-specific notes:

- **Escalating mid-work is legitimate.** Hitting a decision that needs `best`
  while running at `normal` is a routing correction, not a failure. Say so, and
  say what the decision is.
- **Downgrading needs the decision written down first.** Dropping to `low` for a
  mechanical change is safe only when the thing that made it mechanical exists as
  a record. Otherwise the cheap model is re-deriving the expensive answer.
