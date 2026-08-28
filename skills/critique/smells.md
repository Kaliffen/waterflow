# Smell baseline

source: mattpocock/skills @ 6654f6b — skills/engineering/code-review/SKILL.md (copied)

A fixed set of Fowler code smells (*Refactoring*, ch. 3) that the Standards axis
carries even when a repository documents nothing. Paste this file in full into
the Standards subagent's prompt.

Two rules bind it. **The repository overrides**: a documented standard always
wins, and where it endorses something the baseline would flag, the smell is
suppressed. **Always a judgement call**: each entry is a labelled heuristic
("possible Feature Envy"), never a hard violation. Skip anything tooling already
enforces.

Each reads *what it is* → *how to fix*. Match against the diff.

- **Mysterious Name** — a function, variable, or type whose name does not reveal
  what it does or holds. → Rename it; if no honest name comes, the design is
  murky.
- **Duplicated Code** — the same logic shape in more than one hunk or file. →
  Extract the shape, call it from both.
- **Feature Envy** — a method reaching into another object's data more than its
  own. → Move the method onto the data it envies.
- **Data Clumps** — the same few fields or parameters keep travelling together, a
  type wanting to be born. → Bundle them into one type and pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain
  concept that deserves its own type. → Give the concept its own small type.
- **Repeated Switches** — the same switch or if-cascade on the same type recurs
  across the change. → Replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many
  files. → Gather what changes together into one module.
- **Divergent Change** — one file is edited for several unrelated reasons. →
  Split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs
  the spec does not have. → Delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller should not
  depend on. → Hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly delegates onward. → Cut it,
  call the real target directly.
- **Refused Bequest** — a subclass or implementer ignoring or overriding most of
  what it inherits. → Drop the inheritance, use composition.
