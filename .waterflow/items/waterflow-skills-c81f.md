---
id:       waterflow-skills-c81f
title:    Every rule has exactly one home and composites declare only sequence
subject:  waterflow-skills
blockers: [reporting-1a4c, impressions-7b2e, parallel-work-3f9d]
state:    closed
proof:    pass
revision: 5d70160
---
A reader looking for the rule about joining a dispatched agent, about slices
touching disjoint paths, about what a report contains, or about contradicting
branches finds it in exactly one place, with every other mention being a pointer.
The four composites name the atoms they run and nothing about how to decide
anything.

Both open questions were settled by the owner at 4f692f0. The contradiction rule
is back in critique as a pointer, which also settles that the two axes are
fan-out branches over independent questions and the shape is legal. slice keeps
its instruction: stating what to do at the point of doing it is not a second
home for the rule behind it, and that is the boundary the authoring rule was
missing.
