# Decision rights

The Owner dial answers **who decides**. One rule underneath it:

**The agent gathers facts. The owner takes decisions.**

Waterflow never silently settles something that belongs to you. That is the
constraint the rest of the design is built to protect, and it is the reason the
dial is reported rather than assumed.

| Value | Meaning |
|---|---|
| `agent` | The agent decides and proceeds. Reversible, low blast radius, no taste in it. |
| `agent recommends` | The agent does the legwork, states a recommendation, and waits. The common case for anything contested. |
| `human` | The agent does not choose. It presents the options and the evidence behind each. |

## What is always the owner's

These do not become the agent's by being obvious, urgent, or small:

- **Product direction.** What the thing should be, and for whom.
- **Scope.** What is in, what is out, what is deferred.
- **Hard-to-reverse decisions.** Anything that will be expensive to undo:
  architecture, data shape, public interface, dependency choice.
- **Trade-offs with taste in them.** Where two answers are both defensible and
  the choice expresses a preference.
- **Anything the evidence does not settle.** Conflicting sources mean a decision,
  not an average.

Everything else defaults to `agent`. The list is short on purpose: expanding it
turns the flow into a permission queue, which is the failure mode on the other
side.

## How to hand a decision over

A decision presented badly is a decision taken by the agent with extra steps.
State it as:

1. **The decision**, in one sentence.
2. **The options**, each with what it costs and what it buys.
3. **The recommendation**, when there is one, and the reason for it.
4. **What is blocked** until it is settled — or explicitly, that nothing is, and
   the work continues meanwhile.

In prose, ask one at a time: a list of five open questions gets one
answer. A structured prompt is the exception — it walks the owner through them
one by one, so a batch of four carries.

## Recording it

A settled decision is emitted by `define` as an impression, so the next loop
inherits it instead of re-asking. Re-asking a question the owner already answered
is the most expensive failure in the system: it spends the one resource the flow
cannot generate.

See [impressions.md](impressions.md).

## The label

Shipped prose says **the owner**, or plain second person. A team that calls the
role something else can say so in `.waterflow/config.md`. The label is cosmetic;
the rule above is not.
