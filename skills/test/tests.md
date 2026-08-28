# Good and bad tests

source: mattpocock/skills @ 6654f6b — skills/engineering/tdd/tests.md (copied)

Examples are TypeScript; the shapes are language-independent.

## Good

Test through real interfaces, not mocks of internal parts.

```typescript
test("user can checkout with valid cart", async () => {
  const cart = createCart();
  cart.add(product);
  const result = await checkout(cart, paymentMethod);
  expect(result.status).toBe("confirmed");
});
```

- Tests behaviour callers care about
- Uses the public interface only
- Survives internal refactors
- Describes WHAT, not HOW
- One logical assertion

## Bad: coupled to implementation

```typescript
// BAD
test("checkout calls paymentService.process", async () => {
  const mockPayment = jest.mock(paymentService);
  await checkout(cart, payment);
  expect(mockPayment.process).toHaveBeenCalledWith(cart.total);
});
```

Red flags: mocking internal collaborators, testing private methods, asserting on
call counts or order, a name that describes HOW, and a test that breaks on a
refactor with no behaviour change.

## Bad: verifying through a side channel

```typescript
// BAD — bypasses the interface to verify
test("createUser saves to database", async () => {
  await createUser({ name: "Alice" });
  const row = await db.query("SELECT * FROM users WHERE name = ?", ["Alice"]);
  expect(row).toBeDefined();
});

// GOOD — verifies through the interface
test("createUser makes user retrievable", async () => {
  const user = await createUser({ name: "Alice" });
  const retrieved = await getUser(user.id);
  expect(retrieved.name).toBe("Alice");
});
```

## Bad: tautological

The expected value restates the implementation, so the test passes by
construction.

```typescript
// BAD
test("calculateTotal sums line items", () => {
  const items = [{ price: 10 }, { price: 5 }];
  const expected = items.reduce((sum, i) => sum + i.price, 0);
  expect(calculateTotal(items)).toBe(expected);
});

// GOOD — an independent, known literal
test("calculateTotal sums line items", () => {
  expect(calculateTotal([{ price: 10 }, { price: 5 }])).toBe(15);
});
```
