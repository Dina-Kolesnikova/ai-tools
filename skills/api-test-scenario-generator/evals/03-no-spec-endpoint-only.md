# Eval 03 — no documentation, only a working endpoint

## Input
```
There is no spec for this endpoint, I only have this call from the network tab. What should I test?

POST https://api.example.test/v1/bookshelf/items
Authorization: Bearer <token of user 17>
Content-Type: application/json
{ "isbn": "9780131103627", "shelf": "reading", "note": "borrowed from Sam" }

→ 201
{ "id": "a1f3", "isbn": "9780131103627", "shelf": "reading", "note": "borrowed from Sam",
  "addedAt": "2026-11-10T09:14:02Z", "ownerId": 17 }
```
Intake answers: no spec anywhere; tokens for user 17 and user 18 available; no existing tests; light.

## Must
- [ ] The header says the contract is reconstructed from 1 observed call; no field or status is
      tagged `[spec]`.
- [ ] The baseline is the captured call, tagged `[observed]`.
- [ ] Rows exist for: each field removed, `shelf` with an unknown value, `isbn` invalid, `note`
      very long, no token, user 18 reading or changing item `a1f3`, the same call sent twice —
      all flagged `run to learn` with expected result `<?>`.
- [ ] The questions table asks the developer to confirm the observed 201 and the response shape,
      and asks which `shelf` values exist and whether `isbn` is validated.
- [ ] One exploratory charter line is present.
- [ ] The report says the skill did not call the API and that the user runs the rows.

## Must not
- [ ] No row states a 400 / 403 / 409 as `[spec]` or as a fact.
- [ ] The observed 201 is not described as "correct" — only as observed, to be confirmed.
