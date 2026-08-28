---
name: define
description: Settle the words and the hard-to-reverse decisions for an area, and record them. Use when a term is being used two ways, a domain concept needs a name, or a decision will look surprising to a future reader.
source: mattpocock/skills @ 6654f6b — skills/engineering/domain-modeling/CONTEXT-FORMAT.md and ADR-FORMAT.md (adapted)
---

# Define

One operation: fix the language and the decisions for an area so the next loop
inherits them instead of re-deriving them.

There is no glossary file and no ADR directory. A definition is an impression
with `subject` set to the term; a decision is an impression with `scope: []`.
`recall` on the area assembles either. One store, not three.

## Terms

Add a term when it is **specific to this domain**. General programming concepts
do not belong, however heavily the project uses them. The test: would this word
mean something different at another company?

- **Be opinionated.** When several words name one concept, pick one and list the
  others as avoided. Ambiguity in the vocabulary becomes ambiguity in the code.
- **Keep it tight.** One or two sentences. Define what it **is**, not what it
  does.
- **Challenge before recording.** If the code and the owner use a word
  differently, that gap is the finding. Surface it rather than picking a side
  silently.

Record shape — gist is the definition, detail carries the synonyms it displaces:

```
Order: a customer's committed request for goods, priced and accepted.

Avoid: purchase, transaction. "Transaction" is the payment event, not this.
```

## Decisions

Record a decision when **all three** hold:

1. **Hard to reverse.** Changing your mind later costs something real.
2. **Surprising without context.** A future reader will look at the code and ask
   why on earth it was done this way.
3. **A real trade-off.** There were genuine alternatives and one was chosen for
   specific reasons.

Easy to reverse: skip it, you will just reverse it. Unsurprising: nobody will
wonder. No alternative: there is nothing to record beyond doing the obvious
thing.

What qualifies: architectural shape, integration patterns between areas,
technology choices carrying lock-in, ownership and scope boundaries, deliberate
deviations from the obvious path, constraints invisible in the code, and
rejected alternatives whose rejection was non-obvious. The explicit *no*s are as
valuable as the *yes*es.

A decision belongs to the owner, not to you — see
[decision-rights.md](../waterflow/references/decision-rights.md). `define`
records what was settled; it does not settle it.

## Emit

One record per term, one per decision. `atom: define`, `subject` the term or the
decision's subject, `scope: []` — language and decisions are displaced by a
human superseding them, not by a commit landing. Supersede the record you
replace, always. Contract:
[impressions.md](../waterflow/references/impressions.md).
