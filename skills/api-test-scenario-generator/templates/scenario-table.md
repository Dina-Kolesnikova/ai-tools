# API Test Scenarios: <service / feature — endpoint(s)>

**Spec:** <file / page / ticket, version or date — or "none, contract reconstructed from N observed calls on <date>"> · **Owner of expected results:** <spec / PO / dev lead>
**Tags:** `[spec]` stated in the spec · `[observed]` seen on the running service, to be confirmed · `[proposed]` typical, not stated · `<?>` unknown, question raised
**Defaults used:** <skill defaults applied because the project did not define them>
**Existing coverage read:** <collection / tests / bug list read in full, or "none provided">

> `[light]` sections are printed by default; `[full]` sections on request or for several endpoints.

## 1. Endpoint inventory `[light]`
| Endpoint | Auth / roles | Parameters (location, type, required, constraints) | Responses (status → body) | Side effects | Unknowns |
|---|---|---|---|---|---|

## 2. Spec defects `[light if any]`
| ID | Field / response | Type | Quote | Question | Blocking |
|---|---|---|---|---|---|

## 3. Baseline request `[light]`
```
<METHOD> <path>
Authorization: <role / token variable>
Content-Type: application/json

{ minimal valid body, values from the spec or <?> }
```
Expected: `<status> [spec]` with `<body shape>`.

## 4. Scenario table `[light]`
| ID | Group | Scenario | Delta from baseline | Expected status | Expected body / contract check | Side effect / state check | Technique | Priority | Flags |
|---|---|---|---|---|---|---|---|---|---|
| A-01 | A | minimal valid request | — | 201 `[spec]` | schema: status, refundAmount, feeAmount; types per spec | GET shows status Cancelled | AC-based | P1 | ⚠ creates data |
| B-03 | B | reason above max length | body.reason = max + 1 chars (`<?>` max) | 400 `[spec]` | error.field = "reason" `<?>` | nothing changed (GET) | BVA 2-value | P2 | |
| C-04 | C | another user's resource | path id = resource of user B, token of user A | `<?>` (403 or 404 `[proposed]`) | no resource data in the body | nothing changed | EP on actor | P1 | |

**Priority counts:** P1 = n (x %) · P2 = n · P3 = n — reason stated if P1 > ~30 %.
Flags: `⚠ creates data`, `needs: <data / role>`, `blocked by Q<n>`, `run to learn` (no-spec mode: not yet observed), `postman: <note>`.

## 5. Field matrix `[full]`
| Field | Valid partitions | Invalid partitions | Boundaries | Rows |
|---|---|---|---|---|

## 6. Coverage and residual risk `[full]`
| Group | Rows | Deliberately not covered (why) |
|---|---|---|

**Residual risks:** performance, rate limiting, security depth → suggested owner.

## 7. Questions for the spec owner `[light]`
| # | Field / rule | Question | Blocking | Suggested default |
|---|---|---|---|---|
