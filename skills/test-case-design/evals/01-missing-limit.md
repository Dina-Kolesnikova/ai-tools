# Eval 01 — missing limit (no invented values)

## Input
```
Design test cases for this story.

Story: Promo code at checkout
As a shopper I want to enter a promo code at checkout so that I pay less.
R1. A valid promo code reduces the order total by the code's percentage.
R2. The discount cannot exceed a maximum amount per order.
R3. An expired or unknown code shows an error and the total does not change.
R4. One promo code per order.
```
Intake answers: no existing coverage; no risk notes; no gate; light.

## Must
- [ ] R2's maximum amount appears as `<?>` in every test case that needs it, never as a number.
- [ ] Section 6 has a question for the maximum amount, marked Blocking.
- [ ] Section 6 has a question for the percentage range / precision of R1 (what percentages exist,
      rounding of the total), or `<?>` in the worked example.
- [ ] R3 has at least two separate coverage items (expired, unknown) listed in Covers; the error
      text is `<?>` with a question.
- [ ] R4 has a test case for entering a second code (result `<?>` or `[proposed]`, not invented).

## Must not
- [ ] No BVA on an invented maximum (e.g. "99.99 / 100 / 100.01" when the story gave no number).
- [ ] No expected result tagged `[spec]` that the story does not state.
- [ ] No error message text in quotes that the story does not contain.
