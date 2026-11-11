# Test Design: <feature / story ID — title>

**Test basis:** <story / spec section / file, version or date> · **Requirements owner:** <PO / PM / spec>
**Defaults used:** <list any skill defaults applied because the project did not define them>
**Existing coverage read:** <test case sets / runs / defect or findings logs read in full, or "No existing coverage provided">

## 1. Analysis

### 1.1 Requirements
| ID | Requirement (quoted) | Oracle | Risk (L×I → level, reason) | Quality characteristics |
|---|---|---|---|---|
| R1 | "..." | spec | High × High → High: money + status logic | Functional correctness |

**Out of scope:** ... · **Unknowns:** ...

### 1.2 Test conditions
| ID | High-level condition | Detailed conditions | Traces to |
|---|---|---|---|
| TC-A | Payout lifecycle | A1 finalize only when ..., A2 paid cannot revert | R2, R3 |

### 1.3 Test basis defects
| ID | Req | Type | Description (quote) | Found by | Question / fix | Blocking |
|---|---|---|---|---|---|---|

## 2. Technique plan  ← gate: confirm before section 3
| Req | Signal in the requirement | Technique | Coverage criterion | Why (syllabus §) |
|---|---|---|---|---|
| R2 | statuses Draft → Finalized → Paid; "cannot go back" | State transition | All transitions + round-trip | Lifecycle with forbidden moves, high risk (CTFL §4.2.4, CTAL-TA §3.2.2) |
| R2 | known bugs in this area | Error guessing | Fault list from history | CTFL §4.4.1 |

## 3. Test models
One subsection per technique: partitions / boundary points / ON-OFF-IN-OUT / pairwise table /
decision table (+ checksum) / state table / CRUD matrix / scenario list / metamorphic relations /
fault list / checklist / charter. Each coverage item has an ID (P1, B1, DT-C1, T1, INV1, S1, MR1, F1 ...).

## 4. Test cases
| ID | Title (objective) | Priority | Level | Preconditions / test data | Steps | Expected result | Covers | Traces | Status | Flags |
|---|---|---|---|---|---|---|---|---|---|---|
| TC-001 | Finalize a Draft payout with all orders delivered | P1 | High | Draft payout; all orders in period delivered | 1. Open payout 2. Finalize | Status = Finalized `[spec]` | T1 | R2 | Tested (run sheet #12) | ⚠ creates data |
| TC-002 | Paid payout cannot return to Finalized | P1 | High | Paid payout (prereq TC-003) | 1. Try to change status to Finalized | Change rejected; status stays Paid; message `<?>` | INV1 | R2 | New | |

**Priority counts:** P1 = n (x %) · P2 = n · P3 = n — if P1 > ~25–30 %, the reason is stated here.
Status: `Tested` / `Partially tested` / `New` vs existing coverage (with evidence). Run list = New + Partially tested.

Level: High = high-level (abstract), Low = low-level (concrete values).
Flags: `⚠ creates data`, `prerequisite: TC-x`, `automation candidate`, keyword steps if requested.

### 4.1 Exploratory charters (if any)
| ID | Explore … | With … | To discover … | Time box | Limitations (must never) | Historical defects |
|---|---|---|---|---|---|---|

## 5. Coverage and residual risk
| Technique | Coverage items | Covered | % | Deliberately not covered (why) |
|---|---|---|---|---|

**Traceability:** R1 → TC-001, TC-004 · R2 → ... · **Gaps:** ...
**Residual risks / not covered:** performance, security, ... → suggested owner.
**Design stopped because:** coverage target reached / residual risk acceptable / constraint.

## 6. Questions for the requirements owner
| # | Req | Question | Blocking | Suggested default |
|---|---|---|---|---|
