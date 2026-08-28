# Lanes

The Lane dial names **where the work enters the flow**. Everything downstream of
the entry point still runs; everything upstream is being asserted as already
settled. Picking a lane is therefore a claim, and the claim is checkable.

| Lane | Enter at | Claim you are making |
|---|---|---|
| `direct` | atoms, no composite | Nothing needs settling. One clear change with an obvious proof. |
| `align` | `align` | The problem is understood but the facts or terms are not. |
| `shape` | `shape` | Facts and terms are settled; the work is not yet cut into slices. |
| `build` | `build` | Slices exist and are implementation-ready. |

Composites run in order, so entering at `align` runs `align` → `shape` → `build`
→ `land`. Entering at `build` runs `build` → `land`.

## Picking one

Start at the bottom and climb only when the claim fails.

1. **Try `direct`.** One change, one obvious proof, no decision in it. Most work
   is not this, and pretending otherwise is where under-routing happens.
2. **Is there a slice list?** No → at most `shape`.
3. **Are the terms and facts settled?** No → `align`.
4. **Is the problem itself unclear?** Then the work is not routable yet. Split it
   into questions and run `align` on each, one at a time.

Step 4 is where a large foggy effort goes in v1. There is no `map` lane: mapping
a whole territory before doing anything is the opposite of a small feedback loop,
and splitting the fog into separate small loops is almost always the better
answer. If splitting genuinely fails, that is the signal to reach for something
Waterflow does not yet ship.

## Skipping ahead

A lane above `direct` may be entered only when the upstream work exists as
**records**, not as a memory of having done it. `recall` on the subject is the
check: if entering at `build` and there are no live `slice` records for the
subject, the claim is false and the lane is wrong.

This is what makes lanes more than a label. See
[impressions.md](impressions.md).
