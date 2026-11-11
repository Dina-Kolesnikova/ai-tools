# Test Design: <feature / story ID — title>

**Test basis:** <story / spec section / file, version or date> · **Requirements owner:** <PO / PM / spec>
**Defaults used:** <list any skill defaults applied because the project did not define them>
**Existing coverage read:** <test case sets / runs / defect or findings logs read in full, or "No existing coverage provided">

> Sections marked `[light]` are printed in light mode (the default); `[full]` sections only in full mode.
> Section numbers stay the same in both, so "section 4" always means the test cases.

## 1. Analysis

### 1.1 Requirements `[light]`
| ID | Requirement (quoted) | Oracle | Risk (L×I → level, reason) | Quality characteristics |
|---|---|---|---|---|
| R1 | "..." | spec | High × High → High: money + status logic | Functional correctness |

**Out of scope:** ... · **Unknowns:** ...

### 1.2 Test conditions `[full]`
| ID | High-level condition | Detailed conditions | Traces to |
|---|---|---|---|
| TC-A | Payout lifecycle | A1 finalize only when ..., A2 paid cannot revert | R2, R3 |

### 1.3 Test basis defects `[light if any]`
| ID | Req | Type | Description (quote) | Found by | Question / fix | Blocking |
|---|---|---|---|---|---|---|

## 2. Technique plan `[light]`  ← gate (if wanted): confirm before section 3
| Req | Signal in the requirement | Technique | Coverage criterion | Why (syllabus §) |
|---|---|---|---|---|
| R2 | statuses Draft → Finalized → Paid; "cannot go back" | State transition | All transitions + round-trip | Lifecycle with forbidden moves, high risk (CTFL §4.2.4, CTAL-TA §3.2.2) |
| R2 | known bugs in this area | Error guessing | Fault list from history | CTFL §4.4.1 |

## 3. Test models `[full]`
One subsection per technique: partitions / boundary points / ON-OFF-IN-OUT / pairwise table /
decision table (+ checksum) / state table / CRUD matrix / scenario list / metamorphic relations /
fault list / checklist / charter. Each coverage item has an ID (P1, B1, DT-C1, T1, INV1, S1, MR1, F1 ...).

## 4. Test cases `[light]`
| ID | Title (objective) | Priority | Level | Layer | Preconditions / test data | Steps | Expected result | Covers | Traces | Status | Flags |
|---|---|---|---|---|---|---|---|---|---|---|---|
| TC-001 | Finalize a Draft payout with all orders delivered | P1 | High | UI | Draft payout; all orders in period delivered | 1. Open payout 2. Finalize | Status = Finalized `[spec]` | T1 | R2 | Tested (run sheet #12) | ⚠ creates data |
| TC-002 | Paid payout rejects every forbidden move (edit, revert, delete) | P1 | High | API | Paid payout (prereq TC-003) | For each: 1. Try the move | Each attempt rejected; status stays Paid; message `<?>` | INV1, INV2, INV3 | R2 | New | split per move at low level |

**Priority counts:** P1 = n (x %) · P2 = n · P3 = n — if P1 > ~25–30 %, the reason is stated here.
**Gaps:** <R-numbers with no test case, or "none"> (light mode; full mode repeats it in section 5).
Status: `Tested` / `Partially tested` / `New` vs existing coverage (with evidence). Run list = New + Partially tested.

Level: High = high-level (abstract), Low = low-level (concrete values).
Layer: only when the project defines test layers (e.g. API / UI / UI+logs); omit the column otherwise.
Rule: the lowest layer that can observe the expected result, unless the project rule says otherwise.
Flags: `⚠ creates data`, `prerequisite: TC-x`, `automation candidate`, `split per item at low level`,
keyword steps if requested.

### 4.1 Exploratory charters `[light if any]`
| ID | Explore … | With … | To discover … | Time box | Limitations (must never) | Historical defects |
|---|---|---|---|---|---|---|

## 5. Coverage and residual risk `[full]`
| Technique | Coverage items (count) | Deliberately not covered (why) |
|---|---|---|

**Traceability:** R1 → TC-001, TC-004 · R2 → ... · **Gaps:** ...
**Residual risks / not covered:** performance, security, ... → suggested owner.
**Design stopped because:** coverage target reached / residual risk acceptable / constraint.

## 6. Questions for the requirements owner `[light]`
| # | Req | Question | Blocking | Suggested default |
|---|---|---|---|---|
