# Reporting

What the flow tells the owner while it runs. The dials are reported before the
work starts; this is the other half — what actually happened once it did.

A step that settled something and said nothing has hidden its own evidence. The
owner cannot review a decision they did not see, and the impression store is not
a substitute: records are for the next loop, the report is for the person
watching this one.

## The markers

Five, and no others. They are the only formatting that carries meaning, so a
sixth marker dilutes all five.

| Marker | Means |
|---|---|
| ✅ | Ran and succeeded. |
| ❌ | Ran and did not succeed. |
| ⚠️ | Succeeded with something the owner should look at. |
| ⏸️ | Could not run, or was deliberately skipped. Say which. |
| ❓ | Waiting on the owner. |

`⏸️` covers `blocked` and `skipped` because both mean *no evidence was produced*,
which is the thing the owner needs to see. Which one it was goes in the text
beside it. See [proof.md](proof.md) for why `blocked` never collapses into `❌`.

Markers, tables, and bold are the whole vocabulary. Terminals render markdown,
not colour codes: an ANSI escape is either invisible or literal, never styling.

## An atom reports one line

Specified with the emission contract, because an atom reports and emits in the
same beat: [impressions.md](impressions.md).

## A composite reports a block

Ending an `align`, `shape`, `build`, or `land` run:

```
### build · checkout-a4f2

| step | outcome |
|---|---|
| recall | 3 live records, 1 stale since `c81b` |
| test | ✅ 2 red→green |
| prove | ✅ `npm test` pass @ `9f3c1ab` |
| critique | ⚠️ standards 1, spec 0 |

⚠️ **Standards** — `PaymentPort` fake duplicated in two test files.

**Emitted** 2 impressions · **Closed** checkout-a4f2 · **Dispatched** 2 · **joined** 2 · **Next** land
```

The rules, in order of what goes wrong without them:

1. **One row per atom**, in the order it ran, including the ones that did not.
   An atom that was skipped or blocked gets a row saying `⏸️` and which it was.
   A missing row reads as an atom that ran silently, which is the worst of the
   three.
2. **The worst outcome is stated in full below the table.** A table cell holds a
   count; a `❌` or `⚠️` needs a sentence the owner can act on without asking.
   Everything else stays a count.
3. **The footer names what persisted**: impressions emitted, items opened or
   closed, and the next step in the flow. This is what makes a run resumable by
   someone who did not watch it.
4. **Agents are accounted for**, in every block, including the ones that
   dispatched none. `Dispatched 2 · joined 2` is a line worth its width, and
   `Dispatched 0` is worth it too: the count is the evidence that the return leg
   in [topology.md](topology.md) was walked, and a run that cannot write it has
   an agent still going. Reporting it only when it is interesting means a
   forgotten agent and a quiet run look identical.

## Report what happened

The report describes the run, not the plan. Three failures, all of them the same
failure:

- **A `❌` reported as a `⚠️`.** A failed proof is a finished run with a failing
  result, and it is reported as one. Softening it costs the owner the decision.
- **A row for a step that did not run.** If `critique` was skipped because the
  diff was empty, the row says so. Inventing the outcome of a step that never
  happened is the one thing that makes every future report worthless.
- **A re-route left out.** If the work was routed `direct` and became `align`,
  the block says so and shows both settings. Silent drift is the failure mode
  the visible dials exist to catch — see [dials.md](dials.md).

Length is a constraint, not a courtesy. A block longer than the work it describes
does not get read, and an unread report is the same as no report.
