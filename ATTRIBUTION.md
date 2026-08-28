# Attribution

Waterflow borrows from two MIT-licensed repositories. This file carries their
notices, as MIT requires, and records the convention that keeps each borrow
traceable.

## Provenance convention

Every file copied or adapted from an upstream source carries a `source:` line,
in its frontmatter where it has frontmatter and immediately under its title
where it does not:

```
source: mattpocock/skills @ <commit> — skills/productivity/grilling/SKILL.md (copied)
```

The tier is one of `copied`, `adapted`, or `cited`, matching the borrow ledger
in `docs/pre-plan-analysis.md` §7.4. The commit is what makes upstream drift
diffable later: it is the point you compare against when checking whether the
source has moved.

A borrowed file must also be audited on arrival for dependencies that do not
travel: references to upstream skills, upstream config paths such as
`docs/agents/*.md`, and upstream label vocabularies. Several of Matt's skills
instruct the reader to run `/setup-matt-pocock-skills`; copied verbatim, that
ships a pointer to a skill the consumer does not have.

## Sources

### mattpocock/skills

MIT License, Copyright (c) 2026 Matt Pocock
<https://github.com/mattpocock/skills>

Waterflow's authoring standard is a copy of `writing-for-agents` and its
`SKILL-MECHANICS.md`. `skills/waterflow/references/topology.md` adapts
`ask-matt/PHASE-BOUNDARIES.md`, and `skills/setup-waterflow/` adapts
`setup-matt-pocock-skills`. Further borrows are listed in the ledger and marked
in each file.

### robert-hoffmann/uncle-bob

MIT License, Copyright (c) 2026 Robert Hoffmann
<https://github.com/robert-hoffmann/uncle-bob>

Waterflow adapts the distribution-boundary rule, the `pass | fail | blocked`
gate vocabulary, the evidence freshness rule, the objective-complete rule, and
the trigger-token convention for reference loading.

## MIT License text

Both sources are distributed under the MIT License, reproduced here:

```
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Waterflow itself is MIT, Copyright (c) 2026 Adam Boes. See `LICENSE`.
