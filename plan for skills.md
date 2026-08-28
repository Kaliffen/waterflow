# Workflow Skills Design Plan

## Purpose

This document consolidates lessons from two reviewed agent-skill repositories
and turns them into a design plan for improving this repo's Scrum workflow.
It is not an integration plan. The intent is to learn from their workflow
design and adapt the parts that fit Crow City's Creative Director-led process.

Reviewed sources:

- Uncle Bob: `https://github.com/robert-hoffmann/uncle-bob`
- Matt Pocock Skills: `https://github.com/mattpocock/skills`

Local review checkouts:

- `.review/uncle-bob/`
- `.review/mattpocock-skills/`

## Current Local Workflow Shape

This repo currently uses:

- `vision.md` as the Creative Director/Product Owner vision surface.
- `backlog.md` as the Product Owner-owned prioritized outcome list.
- `sprints/sprint-<n>.md` as the Scrum Master-owned sprint plan and ceremony
  log.
- `tech-decisions.md` as an append-only technical decision log.
- Explicit Creative Director gates for plan approval, task sign-off, and
  sprint close.

That workflow is useful, but still naive in four ways:

- It tends to move from backlog item to sprint plan too quickly.
- It does not explicitly separate uncertainty, decisions, specifications, and
  implementation.
- It does not name test seams before implementation.
- It records sign-off, but the proof and learning structure is inconsistent.

## External Models Reviewed

### Uncle Bob

Uncle Bob is an agent operating model built from portable skills, references,
templates, and deterministic validation scripts.

Key source references:

- `.review/uncle-bob/.agents/skills/ub-workflow/SKILL.md`
- `.review/uncle-bob/.agents/skills/ub-governance/SKILL.md`
- `.review/uncle-bob/docs/deep-dives/ub-workflow.md`
- `.review/uncle-bob/docs/deep-dives/ub-governance.md`
- `.review/uncle-bob/docs/deep-dives/workflow-governance.md`
- `.review/uncle-bob/.agents/skills/ub-workflow/scripts/scaffold_workflow.py`

Useful ideas:

- Choose a planning lane before doing work.
- Keep durable artifacts as the source of truth instead of relying on chat.
- Separate workflow readiness from governance/evidence readiness.
- Use simple gate states: `pass`, `fail`, `blocked`.
- Require fresh named proof before claiming objective completion.
- Keep governance lean by default and escalate only when risk or durability
  requires it.

Ideas not to copy wholesale:

- The full `.ub-workflows/` tree is too heavy for this repo right now.
- Waves, initiatives, options boards, final audits, and retained notes would
  overlap with our existing `backlog.md`, `sprints/`, and Creative Director
  gates.

### Matt Pocock Skills

Matt's repo is a composable skill catalog built around alignment, domain
language, vertical slicing, TDD, and review discipline.

Key source references:

- `.review/mattpocock-skills/README.md`
- `.review/mattpocock-skills/CONTEXT.md`
- `.review/mattpocock-skills/skills/engineering/ask-matt/SKILL.md`
- `.review/mattpocock-skills/skills/productivity/grilling/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/domain-modeling/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/to-spec/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/to-tickets/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/tdd/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/code-review/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/wayfinder/SKILL.md`
- `.review/mattpocock-skills/skills/engineering/prototype/SKILL.md`

Useful ideas:

- Start meaningful work with grilling: resolve the decision tree before
  planning implementation.
- Facts are the agent's job; decisions belong to the user.
- Maintain `CONTEXT.md` as a domain glossary, not a spec or task list.
- Use ADRs sparingly: only for hard-to-reverse, surprising, real tradeoffs.
- Split work into tracer-bullet vertical tickets with explicit blockers.
- Treat decision tickets as different from implementation tickets.
- Agree testing seams before writing tests.
- Use TDD as one vertical slice at a time.
- Review on two axes: standards/design quality and spec fidelity.
- Use prototypes as decision evidence, not production code.

Ideas not to copy wholesale:

- The issue-tracker machinery is not needed while this repo is local-only.
- The current sprint files already serve part of the issue/spec role.
- The command vocabulary can inspire our process without becoming our command
  vocabulary.

## Target Workflow Principles

### 1. Creative Director Authority Remains Central

The user remains the final authority for vision, priority, and creative
direction. Agents may gather facts, identify options, recommend paths, and
implement approved work. Agents must not silently settle product-shaping
decisions.

### 2. Choose The Work Lane Before Planning

Every non-trivial request should be routed into one lane before sprint planning:

- `Direct fix`: small, clear, safe work that can finish in one session.
- `Discovery`: unclear product/domain/design question that needs facts and
  Creative Director decisions.
- `Spec`: bounded work where the decision is mostly clear, but implementation
  shape and proof need to be written down before sprinting.
- `Sprint`: implementation-ready work that can be planned as vertical tasks.
- `Decision map`: large foggy work where multiple decisions must be resolved
  before a coherent sprint or spec exists.

This is the main change. It prevents the workflow from treating every backlog
item as immediately sprint-ready.

### 3. Separate Decisions From Delivery

Decision work should produce decisions, not implementation.

Use decision work for questions like:

- What is the correct ontology for physical presence?
- Is a vehicle a persistent world entity or a projection artifact?
- Which events are durable simulation facts versus renderer interpolation?
- What test seam should own proof for a cross-layer behavior?

Only after the decision is clear should the work move into a spec or sprint.

### 4. Keep Domain Language As Infrastructure

Add a root `CONTEXT.md` for glossary-level domain language.

Rules:

- It defines terms, relationships, and rejected synonyms.
- It contains no implementation plan, task list, or sprint scope.
- It is updated when a term is settled, not batched until later.
- It should be read before planning, test naming, or domain-facing code.

Likely first terms:

- `Person`
- `Place`
- `Organization`
- `Tenancy`
- `EmploymentRelationship`
- `Household`
- `Institution`
- `Obligation`
- `Occupancy`
- `Journey`
- `Leg`
- `Vehicle`
- `Projection`
- `Durable Event`

### 5. Use ADRs Sparingly

Continue using `tech-decisions.md` as the current decision log unless a later
workflow update creates `docs/adr/`.

A decision belongs in `tech-decisions.md` when all are true:

- It is hard to reverse.
- A future reader would reasonably ask why it was done this way.
- There was a real tradeoff between alternatives.

Do not record ordinary implementation choices as ADR-like decisions.

### 6. Make Sprint Tasks Vertical

Each sprint task should deliver a narrow, complete capability slice. Avoid
horizontal tasks such as "build all domain types," "write tests," or "update
renderer" unless the task is explicitly a wide mechanical refactor.

Each sprint task should state:

- Outcome: the visible/domain capability it delivers.
- Blocked by: prior tasks or decisions required first.
- Test seam: the public seam where proof will be written.
- Proof: command, test, screenshot, review, or live check expected.
- Out of scope: what the task deliberately will not do.
- Owner: role responsible for the work.

### 7. Agree Test Seams Before Implementation

Before coding a behavior-changing sprint task, name the proof seam.

Crow City seams:

- Domain model seam.
- Simulation system seam.
- Projection/read-model seam.
- Determinism/replay seam.
- Renderer pure-logic seam.
- Live renderer/manual visual seam.
- Console/UI behavior seam.

The test seam should be as high as possible while still giving deterministic,
specific proof.

### 8. Keep Evidence Lightweight But Explicit

Each task should carry a proof state:

- `not run`
- `pass`
- `fail`
- `blocked`

Evidence should be named, not vague:

- `dotnet test CrowCity.slnx`
- targeted test command
- renderer smoke run
- screenshot path
- code-review pass
- Creative Director sign-off note

Borrow Uncle Bob's discipline without adopting its full evidence machinery:
objective proof must be fresh and named before a task is called done.

### 9. Split Review Into Two Axes

Task sign-off and sprint close should distinguish:

- Spec fidelity: did the change implement the accepted objective?
- Design quality: did it preserve architecture, domain model, value semantics,
  determinism, and code quality?

This prevents "the code is clean" from hiding "it built the wrong thing," and
prevents "it works" from hiding architectural damage.

### 10. Treat Prototypes As Decision Evidence

Prototypes are allowed when a design question is hard to settle in prose.

Prototype rules:

- It answers one explicit question.
- It is marked as throwaway.
- It is easy for the Creative Director to run or inspect.
- It exposes the relevant state.
- The validated decision is folded into real work.
- The prototype itself does not become production code by inertia.

Good Crow City prototype candidates:

- Embodied travel feel.
- Day/night pacing.
- Traffic visualization readability.
- Inspection UI shape.
- Agent daily routine presentation.
- Institutional process debugging views.

### 11. Match Model Strength To Work Type

Use model tiers as the stable policy. Concrete model names are current
preferences, not the durable contract.

Current preferred mapping:

- `best`: Opus. Use for planning, strategy, architecture, workflow design,
  contested scope, product-shaping decisions, and any reasoning where a bad
  decision would redirect multiple sprints.
- `good`: Sonnet. Use for review, normal coding, bug fixing, and codebase
  analysis where quality matters but the path is already bounded.
- `normal`: default coding model or Sonnet, depending on risk. Use for ordinary
  implementation tasks with clear acceptance criteria and known seams.
- `low`: Haiku. Use for bookkeeping, status updates, formatting, inventory,
  simple artifact maintenance, and other clerical work where judgment risk is
  low.

Escalate to a stronger tier when:

- product direction is involved;
- the domain model or architecture may change;
- test seams are unclear;
- a decision is hard to reverse;
- the agent is synthesizing multiple sources or resolving conflicting evidence;
- the cost of a wrong answer is more than local rework.

Downgrade to a cheaper tier when:

- the work is mechanical;
- the decision has already been made;
- the output is easy to verify deterministically;
- the task is clerical or formatting-only;
- the work only updates status, links, checkboxes, or simple ceremony logs.

Review should not be underpowered. A review model must be strong enough to
challenge the implementation, not merely summarize it. Planning should use the
best available reasoning because it shapes all downstream work.

### 12. Keep Skills Small, Routed, And Progressively Loaded

Use Uncle Bob's skill architecture lesson without copying the full workflow
tree: keep skill entrypoints small, route deliberately, and load deeper
references only when the active task needs them.

Target local shape:

```text
sprint skill
  -> routes work and enforces gates
    -> role prompts provide role authority and boundaries
      -> focused workflow references load only by trigger
        -> task artifacts record durable state and proof
```

Design rules:

- The `sprint` skill should orchestrate, not contain every workflow rule.
- Role prompts should stay concise and role-specific.
- Reference docs should be split by topic only when the main prompt becomes too
  large or too broad.
- Reference loading should be trigger-based: intake, planning, discovery,
  implementation dispatch, review, closeout, or retrospective.
- Avoid always-loading large process documents for simple tasks.
- Avoid hidden coupling where one skill silently depends on another skill's
  private rules.
- Keep every workflow artifact owned by one file or prompt, with clear
  cross-references instead of duplicated rules.

Candidate reference surfaces:

- `scrum-conventions.md`: compact public workflow contract.
- `.codex/skills/sprint/SKILL.md`: router and lifecycle executor.
- `.codex/agents/*.md`: role-specific authority, boundaries, and task behavior.
- Optional `docs/workflow/model-tiers.md`: model tier matrix and escalation
  policy, created only if `scrum-conventions.md` becomes too dense.
- Optional `docs/workflow/skill-interactions.md`: routing and reference loading
  map, created only if prompt interactions become hard to audit.
- Optional `docs/workflow/review-and-evidence.md`: proof states, review axes,
  and closeout evidence rules, created only if those rules outgrow
  `scrum-conventions.md`.

The efficient framework goal is not fewer files at all costs. It is fewer
always-loaded rules, clearer ownership, and enough reference structure that an
agent can load the right detail without dragging the whole process into every
turn.

## Proposed Artifact Changes

### Update `scrum-conventions.md`

Add sections for:

- Intake lanes.
- Discovery/grilling ceremony.
- Decision work versus delivery work.
- Sprint task template.
- Evidence states.
- Two-axis task and sprint closeout.
- Model tiering policy.
- Skill/reference interaction policy.

### Add `CONTEXT.md`

Create a glossary-only domain file.

Do not make it a planning document.

### Optionally Add `docs/adr/`

Only do this if `tech-decisions.md` becomes too dense or if decisions need
individual ownership, supersession, or local scope. For now, sharpen
`tech-decisions.md` rules first.

### Keep Existing Artifacts

Do not replace:

- `vision.md`
- `backlog.md`
- `sprints/sprint-<n>.md`
- `tech-decisions.md`

The update should strengthen these, not introduce a parallel operating system.

### Optional Workflow References

Create these only if the conventions or skill prompts become too large:

- `docs/workflow/model-tiers.md`: stable model tier names, current preferred
  model mapping, escalation/downgrade rules, and examples.
- `docs/workflow/skill-interactions.md`: which skill or role prompt routes
  which phase, and which references load by trigger.
- `docs/workflow/review-and-evidence.md`: proof states, review axes, and
  closeout evidence details.

Do not create optional references in the first pass just because they are
available. Start with the smallest durable rule set, then split only when it
improves context efficiency or auditability.

## Proposed Sprint Task Template

Use this shape inside future `sprints/sprint-<n>.md` files:

```markdown
- [ ] <Task title> - Owner: <Role> - Status: Not Started - Backlog: <source>

  Outcome:
  <The end-to-end capability or decision this task delivers.>

  Blocked by:
  <None, or specific prior task/decision.>

  Test seam:
  <Domain model | simulation system | projection/read-model | determinism/replay | renderer pure logic | live renderer | console/UI | none, with reason.>

  Proof expected:
  <Named tests, build, screenshot, review, live run, or other evidence.>

  Out of scope:
  <Explicit exclusions.>
```

For pure discovery work, replace `Test seam` with `Decision proof`:

```markdown
Decision proof:
<What artifact records the settled decision and what alternatives were rejected.>
```

## Proposed Ceremony Updates

### Intake

Before planning non-trivial work:

1. Identify lane.
2. Gather facts locally.
3. Ask Creative Director only for decisions the agent cannot make.
4. Update `CONTEXT.md` or `tech-decisions.md` if language or durable decisions
   crystallize.

### Planning

Sprint planning should:

1. Pull from `backlog.md`.
2. Confirm whether the item is sprint-ready.
3. Split into vertical tasks.
4. Name blockers and test seams.
5. Draft proof expectations.
6. Wait for Creative Director approval.

### Sign-Off

Per task:

1. Implementation agent stages changes.
2. Review reports spec fidelity and design quality separately.
3. Proof state is recorded.
4. Creative Director approves or sends back.

### Sprint Close

Sprint close should record:

- What changed.
- What proof passed.
- What was not proven.
- What was learned.
- Whether the next planned sprint still makes sense.
- Any backlog or `CONTEXT.md` updates needed.

## Migration Plan

### Step 1: Write The Workflow Update

Edit `scrum-conventions.md` with the new lane, discovery, proof, and closeout
rules. Keep it concise.

### Step 2: Create `CONTEXT.md`

Seed it with only stable terms already proven by the repo. Do not speculate
ahead of implemented ontology unless the Creative Director explicitly settles
the term.

### Step 3: Update Role Prompts

Review:

- `.codex/agents/product-owner.md`
- `.codex/agents/scrum-master.md`
- `.codex/agents/domain-model-architect.md`
- `.codex/agents/developer.md`

Add only the minimum needed so each role follows the new lane/proof/seam rules.

### Step 4: Update The Sprint Skill

Review `.codex/skills/sprint/SKILL.md`.

Teach it to:

- route through intake lanes;
- use discovery before sprint planning when needed;
- draft vertical task templates;
- require test seams and proof expectations;
- report two-axis review notes at sign-off and sprint close.
- choose an explicit model tier per phase or delegated task;
- load only the workflow references required by the current phase.

### Step 5: Update Model And Reference Routing

Define the first model tier matrix in the workflow contract:

- Planning, strategy, architecture, contested scope: `best` / Opus.
- Review and quality judgment: `good` / Sonnet.
- Normal implementation: `normal` or `good`, selected by risk.
- Bookkeeping and simple ceremony updates: `low` / Haiku.

Then define the minimum reference-loading rules:

- Intake/planning loads lane-selection and Creative Director gate rules.
- Discovery loads grilling, domain-language, and decision-record rules.
- Implementation dispatch loads role prompt plus task-specific proof/seam
  expectations.
- Review loads two-axis review and evidence rules.
- Closeout loads proof, learning, and next-route impact rules.

Keep this as a design policy first. Only split it into separate
`docs/workflow/*.md` files if the sprint skill or conventions become too dense.

### Step 6: Apply To The Next Sprint Only

Do not rewrite old sprint history. Apply the new workflow to the next draft or
active planning event. Historical files remain historical evidence.

### Step 7: Inspect After One Sprint

After one sprint using the updated workflow, review:

- Did lane selection prevent premature implementation?
- Did `CONTEXT.md` reduce repeated explanation?
- Were task seams useful or ceremonial?
- Did evidence states improve sign-off?
- Did two-axis review catch anything normal review missed?
- Did model tiering spend strong models where they mattered?
- Did low-tier bookkeeping remain accurate?
- Did reference loading reduce context bloat without hiding important rules?

Then tighten the conventions.

## Risks

### Too Much Ceremony

Risk: importing the weight of Uncle Bob's workflow without needing it.

Mitigation: add lane selection and proof states, not a parallel `.ub-workflows`
system.

### Glossary Drift

Risk: `CONTEXT.md` becomes a scratchpad or speculative ontology wishlist.

Mitigation: glossary only; no task plans; rejected synonyms allowed; update
only when terms are settled.

### Fake Vertical Slices

Risk: tasks claim to be vertical but remain layer-by-layer.

Mitigation: every task must state the end-to-end capability and proof seam.

### Evidence Theater

Risk: proof states become checkboxes without meaningful validation.

Mitigation: evidence must name the command, review, screenshot, or artifact.

### Decision Work Never Ends

Risk: decision maps/discovery become a way to avoid building.

Mitigation: every discovery has a target decision and next allowed lane.

### Overusing Expensive Models

Risk: planning-tier models are used for clerical work because "best" feels
safer.

Mitigation: require a reason when escalating routine work above its default
tier.

### Underpowering Planning Or Review

Risk: cheap models make plausible but weak strategic decisions, or review only
summarizes the diff.

Mitigation: planning and review default to stronger tiers; downgrade only when
the work is mechanical and easy to verify.

### Model Name Drift

Risk: Opus, Sonnet, Haiku, or their relative strengths change over time.

Mitigation: store durable tier names separately from current preferred model
examples.

### Skill And Reference Sprawl

Risk: many small reference files make the workflow harder to follow.

Mitigation: split only when a rule set becomes too large, too rarely needed, or
phase-specific enough to justify progressive loading.

### Hidden Skill Coupling

Risk: one skill relies on another skill's private assumptions without a clear
contract.

Mitigation: keep shared rules in `scrum-conventions.md` or explicit workflow
references; role prompts should link to shared rules instead of duplicating or
silently depending on them.

## Recommended First Workflow Update Scope

Make one focused workflow-improvement pass:

1. Update `scrum-conventions.md`.
2. Add `CONTEXT.md`.
3. Update the Scrum Master and sprint skill prompts.
4. Add the model tier matrix to the workflow contract.
5. Design skill/reference interaction before expanding the sprint skill.
6. Leave old sprint files alone.
7. Use the new workflow on the next sprint planning gate.

Avoid doing these in the first pass:

- Adding a full ADR directory.
- Adding issue tracker machinery.
- Adding `.ub-workflows/`.
- Rewriting historical sprints.
- Creating deterministic scaffold scripts before the new template proves useful.
- Creating many workflow reference files before prompt size or reuse pressure
  justifies them.

## Summary Recommendation

Adopt Matt's alignment and slicing discipline, plus Uncle Bob's explicit
readiness/evidence discipline.

The target shape for Crow City should be:

```text
intake lane
  -> grilling/discovery when needed
    -> glossary and decision updates
      -> spec or sprint plan
        -> vertical tasks with blockers and seams
          -> model tier selected by phase/risk
            -> implementation with named proof
              -> two-axis sign-off
                -> closeout learning
```

This keeps the Creative Director in control, improves agent reliability, and
avoids replacing the repo's current Scrum cycle with someone else's operating
system. It also keeps agent cost proportional: best models shape direction,
good models review and build where judgment matters, normal models do bounded
implementation, and low-cost models handle bookkeeping.
