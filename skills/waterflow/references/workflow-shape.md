# Workflow Shape

Waterflow keeps process proportional. Pick the smallest workflow shape that can finish the objective and preserve the decision trail.

## Lanes

- `direct`: small, clear, one-session work.
- `discovery`: facts or decisions are missing.
- `spec`: bounded work needs a written plan before implementation.
- `sprint`: implementation-ready work split into vertical tasks.
- `decision-map`: a large foggy effort where decisions must be resolved before delivery work exists.

## Skill And Reference Design

- Skills route and enforce contracts.
- References hold deeper phase-specific guidance.
- Agents apply role judgment inside a bounded task.
- Artifacts carry state that should outlive chat.

## Efficient Loading

Load references by trigger:

- intake and planning: lane, owner, model tier;
- discovery: decision owner, facts needed, artifact target;
- implementation: task seam, proof, constraints;
- review: spec fidelity, design quality, evidence;
- closeout: proof, learning, next-route impact;
- bookkeeping: low-tier artifact update rules.
