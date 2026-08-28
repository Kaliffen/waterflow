---
name: seam
description: Choose and confirm where behaviour will be observed, before any test is written. Use when deciding where a test goes, what an interface should expose, or how deep a module should be.
source: mattpocock/skills @ 6654f6b — skills/engineering/codebase-design/SKILL.md (copied, adapted)
---

# Seam

One operation: pick the place a change will be observed, confirm it, and record
it. **No test is written at an unconfirmed seam** — you cannot test everything,
and agreeing the seam up front is how the effort lands on the paths that matter
instead of on every edge case.

## Vocabulary

Use these words exactly. Do not substitute "component", "service", "API", or
"boundary" — consistent language is the point.

**Module** — anything with an interface and an implementation. Scale-agnostic on
purpose: a function, a class, a package, a slice spanning tiers.

**Interface** — everything a caller must know to use the module correctly. Not
just the type signature: invariants, ordering constraints, error modes, required
configuration, performance characteristics.

**Seam** *(Michael Feathers)* — a place where you can alter behaviour without
editing in that place; the *location* where a module's interface lives. Where to
put it is a separate decision from what goes behind it.

**Adapter** — a concrete thing satisfying an interface at a seam. Names a role,
not a substance.

**Depth** — leverage at the interface. How much behaviour a caller or a test can
exercise per unit of interface it must learn. **Deep** is a lot of behaviour
behind a small interface; **shallow** is an interface nearly as complex as the
implementation.

**Leverage** — what callers get from depth: more capability per unit learned.
**Locality** — what maintainers get: change, bugs, and verification concentrate
in one place. Fix once, fixed everywhere.

## Choosing

Four tests, in order:

1. **The interface is the test surface.** Callers and tests cross the same seam.
   Wanting to test *past* the interface means the module is the wrong shape.
2. **The deletion test.** Imagine deleting the module. If complexity vanishes it
   was a pass-through; if it reappears across N callers it was earning its keep.
3. **One adapter is a hypothetical seam. Two is a real one.** Do not introduce a
   seam unless something actually varies across it.
4. **Depth is a property of the interface, not the implementation.** A deep
   module may be internally composed of small swappable parts — they are just
   not part of the interface. Internal seams are legitimate and private.

A fifth test applies after the fact, and it is the one nothing else catches:

5. **Ownership friction is seam evidence.** When two writers keep editing the
   same value, or argue over what it should be, the value is owned by the wrong
   module. Read that as a seam problem rather than a coordination problem to be
   solved with more coordination. It matters because a constant in the wrong
   place breaks no build and fails no assertion — there is nothing for a test to
   catch, so friction is the only signal there is.

When the interface is too wide, ask: can I remove a method, simplify a
parameter, hide more inside?

## Confirm

State the seam, what sits behind it, and what will be faked across it. Get an
explicit yes before anything is written against it. If the seam is contested,
that is an escalation, not a preference — see
[dials.md](../waterflow/references/dials.md).

## Emit

One record, `atom: seam`, `subject` the module or capability, `scope` the paths
the seam sits between. The gist names the seam in one sentence; the detail says
what is faked across it and what the rejected seam was. Supersede the previous
seam record for the same subject. Contract:
[impressions.md](../waterflow/references/impressions.md).
