---
name: test
description: Write one failing test at the agreed seam, then make it pass. Use for red-green work, building a feature test-first, or fixing a bug with a reproducing test. To run an existing proof instead, use prove.
source: mattpocock/skills @ 6654f6b — skills/engineering/tdd/SKILL.md (copied, adapted)
---

# Test

`test` **writes** a test. `prove` **runs** evidence and records the result. If
the test already exists and the question is whether it passes, this is the wrong
atom.

One operation: one seam, one failing test, the minimum code that makes it pass.

## The seam comes first

No test is written at an unconfirmed seam. If there is no live `seam` record for
this subject, stop and run `seam`. Everything about where the test goes and what
it may reach for lives there — [seam](../seam/SKILL.md).

`recall` the `define` records for the area too, so test names use the project's
own words.

## Rules of the loop

- **Red before green.** Write the failing test first, watch it fail for the right
  reason, then write only enough code to pass it. Do not anticipate the next
  test or add what nothing asks for.
- **One slice at a time.** One seam, one test, one minimal implementation per
  cycle. Each test is a **tracer bullet** that responds to what the last cycle
  taught you.
- **Refactoring is not part of the loop.** It belongs to review — see
  [critique](../critique/SKILL.md).

## What a good test is

A test verifies behaviour through the public interface, not implementation
detail. The code can change entirely and the test should not. A good one reads
like a specification: *"user can checkout with valid cart"* names a capability
and survives refactors because it does not care about internal structure.

Examples of both kinds: [tests.md](tests.md). What to fake and what never to:
[mocking.md](mocking.md).

## Anti-patterns

- **Implementation-coupled** — mocks internal collaborators, tests private
  methods, or verifies through a side channel such as querying the database
  instead of using the interface. The tell: it breaks on a refactor when
  behaviour did not change.
- **Tautological** — the assertion recomputes the expected value the way the code
  does, so it passes by construction and can never disagree with the code.
  Expected values come from an independent source: a known-good literal, a
  worked example, the spec.
- **Horizontal slicing** — all tests first, then all implementation. Bulk tests
  verify *imagined* behaviour: you test the shape of things, the tests go
  insensitive to real change, and you commit to test structure before
  understanding the implementation.

## Emit

One record, `atom: test`, `subject` the capability, `scope` the paths under
test. The gist is the behaviour now covered; the detail is what was faked and
anything the cycle taught that changed the approach. Supersede the previous
`test` record for the same subject.

Then run `prove`. Writing a test is not evidence until it has been run and
recorded. Contract:
[impressions.md](../waterflow/references/impressions.md).
