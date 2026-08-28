# Topology

source: mattpocock/skills @ 6654f6b — skills/engineering/ask-matt/PHASE-BOUNDARIES.md (adapted)

The Topology dial answers **how many agents, in what shape**. It is decided at a
**boundary**: the gap between one chunk of work and the next. Mid-chunk there is
no decision to make, and switching shape mid-thought loses the thread.

| Value | What it does |
|---|---|
| `inline` | Stay in this context. No switch at all. |
| `subagent` | Send one bounded task to its own context; get a report back. |
| `fan-out` | Several subagents in parallel on independent questions. |
| `background` | A long task that runs while you keep working. |
| `fresh` | Start a new context, seeded deliberately. |

## The tree

Work top to bottom at a boundary. First **yes** wins.

1. **Can you stay inline?** Yes when the next chunk needs this one verbatim, or
   there is simply room. `align` → `build` is the standard yes: implementation
   wants the reasoning as it happened, not a summary of it. Inline costs nothing
   and loses nothing, so rule it out first.
2. **Is this context irrelevant to what comes next?** Then go `fresh` and drop
   it. Cheapest move on the board. Getting it wrong is one-way: you lose the
   *why*, and reading the diff back does not return it.
3. **Are the questions independent?** Two or more things that do not need each
   other's answers go `fan-out`. Dependent questions do not — a fan-out over
   dependent work produces confident, conflicting reports.
4. **Can it run with nobody steering?** Tightly scoped, no judgement calls
   mid-flight, you are not needed while it runs: `subagent`, or `background` if
   it is long enough that waiting wastes your time. Automated review is the
   standard case.
5. **Otherwise stay `inline`** and split the remaining work instead.

## Why the store changes this tree

Every shape except `inline` normally turns a **primary source** — the session as
it happened — into a **secondary** one: a summary, lossy by construction. That
lossiness is the reason step 1 comes first.

Impressions blunt it. What mattered was emitted as a typed record at the moment
it was settled, so it survives the boundary at full fidelity regardless of what
happens to the conversation. The practical effect is that `subagent`, `fan-out`,
and `fresh` are **cheaper than they look**: a cold agent is briefed with the live
records for the subject rather than a pasted transcript.

That is the whole economic argument for the store — see
[impressions.md](impressions.md). Brief with `recall` output, and treat needing
the transcript instead as a signal that something was settled without being
emitted.

## These are judgement calls

None of the questions is objective, and the same boundary can go two ways on two
days. The value is in asking them **in order, at the boundary**, rather than
picking a shape by habit in the middle of the work.

## The return leg

Choosing a shape is half the decision. Every shape except `inline` opens a debt,
and the debt is the part that gets forgotten: an agent was sent somewhere and
nothing said when it comes back.

**Dispatch names three things or it does not happen:**

| | |
|---|---|
| **Deliverable** | What comes back, in what shape, and how long. "Under 400 words, findings per file" — not "look into it". |
| **Budget** | What counts as too far. A question, not a project: an agent with no ceiling explores until something stops it. |
| **Join point** | The step that consumes the result. Named before dispatch, not discovered afterwards. |

**Every dispatched agent is joined at or before the boundary that spawned it.**
A composite never finishes with an agent still running. `background` buys the
right to keep working while it runs; it does not buy the right to forget it.

When the join point arrives and the agent has not reported, there are two moves
and you say which one you took: **wait** for it, or **stop it** and continue
without that input, naming what is now unproven. Letting it run on unwatched is
not a third option — it is how a session ends with agents still burning.

Two rules keep the fan from widening on its own:

- **A dispatched agent does not dispatch.** Nesting is legal only when the brief
  says so explicitly and names the ceiling. Otherwise the shape you chose at the
  boundary is not the shape that ran.
- **A finding is not a mandate.** An agent that discovers adjacent work reports
  it. It does not start it, and it does not spawn something to start it. New
  work is routed at a boundary, by the owner of that boundary.

## Reconciling what comes back

`fan-out` is only legal over independent questions, so the results are
independent too — and merging them destroys the independence that justified the
shape.

- **Branches stay separate.** Report each under its own heading. Do not merge
  into one ranked list; `critique` keeps Standards and Spec apart for exactly
  this reason.
- **A contradiction between branches is a finding**, not an average. Two agents
  that disagree have found something the routing missed. Surface both claims,
  say which sources they rest on, and escalate — see [dials.md](dials.md).
- **An overlap is reported once**, attributed to both branches, so agreement
  reads as corroboration rather than as two problems.

## One writer at a time

Reading fans out freely. **Writing does not.** At most one agent changes the
working tree at a time.

Two agents editing files concurrently in the same tree is not `fan-out`; it is a
merge conflict arranged in advance, and neither agent can prove anything because
the ground moves under both. The cost lands at integration, which is the most
expensive place for it to land.

Parallel implementation is legal under two conditions together:

1. **Separate trees.** Each agent has its own worktree, branch, or clone, and
   integration is an explicit step afterwards with its own proof.
2. **Disjoint scope.** The slices touch different paths. Overlapping scope is a
   blocking edge that `slice` should have drawn — see
   [state-surface.md](state-surface.md).

Fail either one and the shape is `inline`, serialized, one slice at a time. That
is the default `build` already assumes, and it is not a limitation to work
around: a slice that must run beside another slice on the same files was cut
wrong.
