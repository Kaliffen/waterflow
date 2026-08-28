---
name: critique
description: Review a diff on two separate axes, standards and spec, in parallel subagents. Use when reviewing a branch, a pull request, or work in progress before it lands.
source: mattpocock/skills @ 6654f6b — skills/engineering/code-review/SKILL.md (adapted)
---

# Critique

One operation: review the diff between `HEAD` and a fixed point on two axes that
never merge.

- **Standards** — does the code follow this repository's documented conventions?
- **Spec** — does it faithfully implement what was asked for?

Both run as **parallel subagents** so neither pollutes the other's context.

## Why two axes

A change can pass one and fail the other. Code following every convention while
implementing the wrong thing is Standards pass, Spec fail. Code doing exactly
what was asked while breaking the project's conventions is the reverse.
Reporting them separately stops one axis masking the other.

## 1. Pin the fixed point

Whatever the owner names: a SHA, a branch, a tag, `main`, `HEAD~5`. Ask if none
was given.

```sh
git rev-parse <fixed-point>
git diff <fixed-point>...HEAD        # three-dot: against the merge-base
git log <fixed-point>..HEAD --oneline
```

Confirm the ref resolves and the diff is non-empty **before** spawning anything.
A bad ref should fail here, not inside two subagents.

## 2. Find the spec

In order: the items on the state surface referenced by the commit messages
(`get_item`); a path passed as an argument; live `slice` and `interrogate`
records for the subject via `recall`; a spec file under the repository's usual
place. If nothing is found, ask. If there is genuinely no spec, skip the Spec
subagent and say so in the report — never quietly run one axis and present it as
a review.

## 3. Find the standards

Whatever the repository documents about how code should be written, plus the
**smell baseline** in [smells.md](smells.md), which applies even when a
repository documents nothing. Two rules bind it: a documented repository
standard always **overrides** the baseline, and every baseline smell is a
labelled judgement call, never a hard violation. Skip anything tooling already
enforces.

## 4. Spawn both, in parallel

**Standards subagent** gets the diff command, the commit list, the standards
files you found, and the full text of `smells.md` pasted in — it has no other
access to it. Brief: *"Report, per file or hunk: (a) every place the diff
violates a documented standard, citing the file and the rule; (b) any baseline
smell, named, with the hunk quoted. Distinguish hard violations from judgement
calls. A documented standard overrides the baseline. Skip what tooling enforces.
Under 400 words."*

**Spec subagent** gets the diff command, the commit list, and the spec. Brief:
*"Report: (a) requirements asked for that are missing or partial; (b) behaviour
in the diff nobody asked for; (c) requirements that look implemented but look
wrong. Quote the source line for each finding. Under 400 words."*

Both briefs are bounded: one deliverable, one word budget, one join point — this
step. Neither fixes anything it finds; the containment rules are in
[topology.md](../waterflow/references/topology.md).

## 5. Join and aggregate

Present both under `## Standards` and `## Spec`, verbatim or lightly cleaned.
**Do not merge or re-rank across axes** — that is exactly the collapse the
separation exists to prevent.

Both axes are joined here. If one did not return, report the axis as `⏸️` with
the reason and never present a single-axis run as a review. Two axes that
contradict each other on the same hunk reconcile like any other pair of
branches: [topology.md](../waterflow/references/topology.md).

End with one line: findings per axis, and the worst issue *within each axis*. No
single winner across axes.

## Emit

One record, `atom: critique`, `subject` the change under review, `scope` the
paths in the diff. The gist is the verdict per axis and the count; the detail is
the worst finding on each. Supersede the previous critique record for the same
subject. Contract: [impressions.md](../waterflow/references/impressions.md).

Findings are not fixes. Fixing them is separate work with its own routing.
