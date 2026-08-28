---
name: probe
description: Build throwaway code that answers one design question. Use when a state model, an interface, or a piece of logic needs checking before anything is committed to it.
source: mattpocock/skills @ 6654f6b — skills/engineering/prototype/SKILL.md (adapted)
---

# Probe

One operation: **throwaway code that answers a question**. The question decides
the shape, so name it first, in one sentence, and put it at the top of whatever
you build.

If the question cannot be stated in one sentence, the probe is not ready.
Building to "see how it feels" produces code that gets kept and a question that
stays open.

## Rules

1. **Throwaway from day one, and marked as such.** Put it next to what it is
   probing so the context is obvious, and name it so a casual reader can see it
   is not production. Obey the project's existing conventions for where such
   things live; do not invent a new top-level structure.
2. **Trivial to run.** One command from the project's own task runner, or one
   file that opens on a double-click. No thinking required to start it.
3. **No persistence by default.** State lives in memory. Persistence is usually
   the thing being checked, not something to depend on. If the question really is
   about storage, use a scratch store named so nobody mistakes it.
4. **Skip the polish.** No tests, no error handling beyond what makes it run, no
   abstractions. The point is to learn something fast.
5. **Surface the state.** After every action, show the full relevant state, so
   the thing being judged is visible rather than inferred.
6. **Push it through the cases that are hard to reason about on paper.** A probe
   that only exercises the easy path answers nothing.

## Close it out

A probe is finished when the question has an answer — including "this does not
work", which is a result, not a failure.

Fold the validated decision into the real code. Keep the probe itself out of
main: commit it to a throwaway branch and leave a pointer to that branch. The
main branch keeps the decision, not the demo.

If the probe surfaced a hard-to-reverse decision, `define` records it.

## Emit

One record, `atom: probe`, `subject` the thing probed, `scope: []` unless the
answer is tied to specific paths. The gist is **the question and its answer**, in
one sentence each; the detail is what was tried, what was rejected, and where the
throwaway branch is. Supersede any earlier probe record answering the same
question.

This is the one atom whose record usually outlives its code entirely, so write
the gist for someone who will never see the probe. Contract:
[impressions.md](../waterflow/references/impressions.md).
