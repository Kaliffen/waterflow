# What to fake

source: mattpocock/skills @ 6654f6b — skills/engineering/tdd/mocking.md (copied)

Fake at **system boundaries** only:

- external APIs (payment, email)
- databases — sometimes; prefer a test database
- time and randomness
- the file system, sometimes

Never fake your own modules, internal collaborators, or anything you control.
The seam record says what is faked for this subject; this file says what may be.

## Designing for it

**Accept dependencies, do not create them.**

```typescript
// Easy to fake
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// Hard to fake
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**Prefer specific operations over one generic fetcher.** A function per external
operation, not one function with conditional logic inside it.

```typescript
// GOOD — each is independently fakeable
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch("/orders", { method: "POST", body: data }),
};

// BAD — faking it requires conditional logic in the fake
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

Each fake then returns one specific shape, test setup carries no branching, and
the endpoints a test exercises are visible at a glance.
