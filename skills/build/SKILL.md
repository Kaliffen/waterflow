---
name: build
description: Implement one slice test-first and close it with recorded evidence.
argument-hint: "<slice id, or nothing to take the frontier>"
disable-model-invocation: true
---

# Build

One slice per run. Run these atoms in order; each emits.

1. **`recall`** the subject — the seam, the terms, what is already proven.
2. **`test`** — one failing test at the confirmed seam, then the minimum code
   that passes it. Repeat per behaviour the slice needs. One at a time.
3. **`prove`** — run the named proof and record the state and revision.
4. **`critique`** — two axes, in parallel, not merged.

Take the slice named as an argument, or `list_frontier` and take one whose
blockers are all closed. Do not start a slice that is blocked.

**Done when** `prove` recorded a `pass` at the current revision and `critique`
reported. A `fail` is a finished run too — report it and stop rather than
carrying on under the same routing.

Next: `land`, or the next slice.
