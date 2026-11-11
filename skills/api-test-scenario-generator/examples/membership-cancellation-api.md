# Worked example: `POST /memberships/{id}/cancellation` (light)

The API side of the invented gym story used by the other two skills. Input first, report second.
Every value in the report comes from the spec fragment below or is `<?>`.

---

## Input (as pasted by the user)

```yaml
# OpenAPI fragment, membership-service v2.3
POST /memberships/{id}/cancellation
summary: Cancel the member's own membership
security: bearerAuth (role: member)
parameters:
  - in: path
    name: id
    schema: { type: string, format: uuid }
    required: true
requestBody:
  application/json:
    schema:
      type: object
      properties:
        reason: { type: string, maxLength: 200 }
responses:
  '201':
    description: Cancellation created
    content:
      application/json:
        schema:
          type: object
          required: [status, feeAmount, refundAmount, currency]
          properties:
            status: { type: string, enum: [Cancelled] }
            feeAmount: { type: number }
            refundAmount: { type: number }
            currency: { type: string }
  '400': { description: Validation error, body: { error: { code, field, message } } }
  '401': { description: Missing or invalid token }
  '404': { description: Membership not found }
  '409': { description: Membership is not Active }
Business rules: cancellation is free when requested at least 30 days before the next billing
date (club local time); later, feeAmount = one monthly fee; refundAmount = prepaid − feeAmount.
```

**Intake answers:** spec is the fragment above; roles: member tokens for two members, one admin;
no existing collection; light.

---

## Report

# API Test Scenarios: membership-service — POST /memberships/{id}/cancellation

**Spec:** OpenAPI fragment, membership-service v2.3 (pasted 2026-11-10) · **Owner of expected results:** spec; PO for the business rules
**Defaults used:** English; 2-value BVA except 3-value on the 30-day cut-off and the amounts
**Existing coverage read:** none provided

## 1. Endpoint inventory `[light]`
| Endpoint | Auth / roles | Parameters | Responses | Side effects | Unknowns |
|---|---|---|---|---|---|
| POST /memberships/{id}/cancellation | bearer, role member | path `id` uuid required; body `reason` string ≤ 200, optional | 201 {status, feeAmount, refundAmount, currency}; 400; 401; 404; 409 | membership → Cancelled; refund to payment provider; e-mail (story, not in the spec) | 403 not listed: another member's id → 404 or 403?; second POST on a Cancelled membership → 409?; admin role allowed?; unknown body fields; empty body vs `{}`; rounding of amounts; what if fee > prepaid |

## 2. Spec defects `[light if any]`
| ID | Field / response | Type | Quote | Question | Blocking |
|---|---|---|---|---|---|
| D1 | responses | missing | no 403; "role: member" only | Another member's id: 404 (hide) or 403? Admin: allowed? | Yes |
| D2 | business rule | ambiguous | "at least 30 days before" | Exactly 30 days free? Unit? Anchor time of the billing date? | Yes |
| D3 | refundAmount | missing | "refundAmount = prepaid − feeAmount" | fee > prepaid → negative? capped? rounding? | Yes |
| D4 | requestBody | missing | no statement on extra fields / empty body | Extra field ignored or 400? Empty body allowed? | No |
| D5 | 409 | ambiguous | "Membership is not Active" | second cancel of a Cancelled membership → 409? an Ended one → 409? | No |

## 3. Baseline request `[light]`
```
POST {{baseUrl}}/memberships/{{membershipA_active_45d}}/cancellation
Authorization: Bearer {{token_memberA}}
Content-Type: application/json

{ "reason": "moving" }
```
Expected: `201 [spec]`, body `{status: "Cancelled", feeAmount: 0, refundAmount: <prepaid>, currency: <?>}`.

## 4. Scenario table `[light]`
| ID | Group | Scenario | Delta from baseline | Expected status | Expected body / contract check | Side effect / state check | Technique | Priority | Flags |
|---|---|---|---|---|---|---|---|---|---|
| A-01 | A | happy path, 45 days before billing | — | 201 `[spec]` | all 4 required fields; status = Cancelled; feeAmount = 0; refundAmount = prepaid `[spec]`; number types | GET membership → status Cancelled; one refund at the provider | AC-based | P1 | ⚠ creates data |
| A-02 | A | happy path without body | no body | `<?>` (D4) — 201 `[proposed]` | as A-01 | as A-01 | EP (optional field absent) | P2 | ⚠ creates data |
| B-01 | B | reason at max length | reason = 200 chars | 201 `[spec]` | as A-01 | as A-01 | BVA 2-value | P2 | ⚠ creates data |
| B-02 | B | reason above max length | reason = 201 chars | 400 `[spec]` | error.field = "reason" `[spec]`; code / message `<?>` | nothing changed (GET → Active) | BVA 2-value | P2 | |
| B-03 | B | reason wrong type | reason = 123 | 400 `[spec]` | error.field = "reason" | nothing changed | EP | P3 | |
| B-04 | B | reason null | reason = null | `<?>` — 201 or 400 (D4) | | nothing changed if 400 | EP | P3 | |
| B-05 | B | unknown extra field | body + `"foo": 1` | `<?>` (D4) | | | EP | P3 | |
| B-06 | B | id not a uuid | path id = "abc" | 400 `[spec]` | error.field = "id" | nothing changed | EP (format) | P2 | |
| C-01 | C | no token | no Authorization header | 401 `[spec]` | no membership data in the body | nothing changed | EP on actor | P1 | |
| C-02 | C | expired token | `{{token_expired}}` | 401 `[spec]` | | nothing changed | EP on actor | P2 | |
| C-03 | C | another member's membership | id = membership of B, token of A | `<?>` (D1) — 404 `[proposed]` | body must not reveal B's data | B's membership unchanged | EP on actor (object-level auth) | P1 | |
| C-04 | C | admin token | `{{token_admin}}` | `<?>` (D1) | | | EP on actor | P2 | |
| D-01 | D | membership not found | id = random uuid | 404 `[spec]` | | | state | P2 | |
| D-02 | D | already Cancelled | id = membership cancelled in A-01 | 409 `[spec]` (D5 to confirm) | no second refund | provider shows one refund | state, invalid transition | P1 | prerequisite: A-01 |
| D-03 | D | Ended membership | id = membership ended last month | 409 `[spec]` (D5) | | nothing changed | state, invalid transition | P2 | |
| E-01 | E | 30 days + 1 day before billing | id = membership billing in 31 days | 201 `[spec]` | feeAmount = 0 | | BVA 3-value | P1 | ⚠ creates data |
| E-02 | E | exactly 30 days before billing, club time | id = membership billing in exactly 30 days | 201 | feeAmount = `<?>` (D2) | | BVA 3-value | P1 | ⚠ creates data; blocked by Q2 |
| E-03 | E | 29 days before billing | id = membership billing in 29 days | 201 `[spec]` | feeAmount = one monthly fee `[spec]`; refundAmount = prepaid − fee `[spec]`, rounding `<?>` | | BVA 3-value + worked example | P1 | ⚠ creates data |
| E-04 | E | fee greater than prepaid | id = discounted membership, fee > prepaid, billing in 10 days | `<?>` (D3) | refundAmount must not be negative `[proposed]` | | calculation, D3 case | P2 | blocked by Q3 |
| F-01 | F | same request twice, fast | send A-01 twice within 1 s | first 201, second 409 `[proposed]` (D5) | | exactly one refund, one e-mail | error guessing, repetition | P1 | ⚠ creates data |
| F-02 | F | retry after a provider timeout | provider sandbox set to time out, then retry | `<?>` (story Q5) | | no double refund | error guessing | P2 | blocked |
| I-01 | I | malformed JSON | body = `{ "reason": ` | 400 `[spec]` | | nothing changed | error guessing, input | P3 | |
| I-02 | I | wrong content type | Content-Type: text/plain | `<?>` — 415 `[proposed]` | | nothing changed | error guessing, input | P3 | |
| I-03 | I | unsupported method | GET on the same path | `<?>` — 405 `[proposed]` | | | error guessing | P3 | |

**Priority counts:** P1 = 8 (33 %) · P2 = 10 · P3 = 6 — P1 slightly above 30 %: the eight are the
contract, the two auth gates, the double cancel, the three cut-off rows and the double submit; each is
money or access, kept.
Group G not applicable (not a list endpoint). Group H is covered by the "Side effect / state check" column.

## 7. Questions for the spec owner `[light]`
| # | Field / rule | Question | Blocking | Suggested default |
|---|---|---|---|---|
| Q1 | responses | Another member's id: 404 or 403? Is an admin allowed to call this endpoint? | Yes | 404 for other members' ids; admin not allowed here |
| Q2 | business rule | Is exactly 30 days before billing free? Unit (days? hours)? What time of day anchors the billing date? | Yes | ≥ 30 whole days, 00:00 club time |
| Q3 | refundAmount | fee > prepaid: capped at 0? Rounding rule and currency source? | Yes | capped at 0; 2 decimals; membership currency |
| Q4 | requestBody | Extra fields ignored or rejected? Empty body allowed? `reason: null` allowed? | No | ignored; allowed; treated as absent |
| Q5 | 409 | Does 409 cover both Cancelled and Ended memberships, and a second POST? | No | yes to all three |

---

## Why this depth
- 24 rows for one write endpoint: every field class once, every actor once, every forbidden state
  once, 3-value on the money cut-off, repetition and robustness attacks. Groups A–F and I all present;
  G skipped with a reason; H folded into a column.
- Five blocking or non-blocking questions, each tied to a row that is blocked or `[proposed]`.
