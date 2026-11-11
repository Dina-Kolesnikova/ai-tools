# Technique selection: signals → technique → coverage criterion

Sources (cite as shown):
- `CTFL §x` — ISTQB Certified Tester Foundation Level Syllabus v4.0.1, chapter 4 (techniques), §5.2 (risk)
- `CTAL-TA §x` — ISTQB Advanced Level Test Analyst Syllabus v4.0, chapter 3 (techniques),
  §3.5.1 (selecting techniques to mitigate product risks)

CTAL-TA §3.5.1 lists the selection factors (section 4 below) but no lookup table. The "Signal"
column is a practical mapping built on the syllabus definitions: what to look for in the requirement text.

## 1. Main table

| Signal in the requirement | Technique | Coverage criterion (default → high risk) | Why (syllabus) |
|---|---|---|---|
| An input/output whose values are processed in groups: types, categories, roles, formats, "allowed / not allowed" | **Equivalence Partitioning** | Each partition once, incl. invalid → Each Choice across inputs | One value represents the whole partition (CTFL §4.2.1) |
| Ordered values with limits on **one** variable: min/max length, amounts, quantities, dates, "at least", "up to", "before", "after" | **Boundary Value Analysis** | 2-value → **3-value** for money, dates, permissions, legal limits | Only for ordered partitions; defects cluster at misplaced boundaries (CTFL §4.2.2) |
| Validity depends on a **condition over several variables**: "end date ≥ start date", "amount ≤ balance + credit", "age > 18 AND country = X", ratios, `≠` rules | **Domain testing** (ON/OFF/IN/OUT points) | Simplified domain → **Reliable domain** | Generalises EP+BVA to multi-variable borders; catches wrong operator or constant (CTAL-TA §3.1.1) |
| Several independent parameters / settings whose **interactions** may fail: browser × OS × role × language, filter combinations, form option combinations, configuration flags | **Combinatorial testing** | Base choice → **Pairwise** → all combinations (only for very high risk, small sets) | Most failures come from 1–2 interacting parameters (CTAL-TA §3.1.2) |
| Outcome depends on a **combination** of conditions under a business rule: "if A and B then X, unless C"; role × status × flag | **Decision Table** | Minimized table → **full table, all feasible columns, no minimization** at high risk | Finds missing combinations, gaps, contradictions (CTFL §4.2.3, CTAL-TA §3.3.1) |
| Object has a **lifecycle / status**: Draft → Finalized → Paid; order statuses; active/blocked user | **State Transition** | Valid transitions (0-switch) → All transitions → **1-switch** / **round-trip** for sequence or loop risks | CTFL §4.2.4; N-switch and round-trip added in CTAL-TA §3.2.2 |
| A forbidden move: "cannot go back", "only from", "once paid" | **State Transition, invalid transitions** | Each invalid transition attempted alone (one low-level case each; a high-level case may group them per state) | Avoids defect masking (CTFL §4.2.4) |
| A status can come back to an earlier one, cycles: reopen, re-assign, resubmit, cancel & restore | **State Transition, round-trip coverage** | Every loop (round trip) once | Loops are where sequence defects hide (CTAL-TA §3.2.2) |
| An **entity** created, viewed, edited and deleted by different functions, roles or apps (CRM, API, mobile): users, orders, assets, payouts | **CRUD testing** | Every C/R/U/D cell in the CRUD matrix → after each U, every R | Finds missing lifecycle operations, data integrity and access-control defects (CTAL-TA §3.2.1) |
| A **user flow / business process**: steps of an actor with branches, "if the user ...", end-to-end journeys, use cases | **Scenario-based testing** (use case / activity diagram) | Every scenario: main + extensions + exceptions; **simple loop coverage** if steps repeat | Realistic end-to-end flows; finds missing features and communication defects (CTAL-TA §3.2.3) |
| Expected result is **hard to know** for one input, but a relation between inputs/outputs is known: totals, sorting, filtering, search, reports, recalculation, rounding | **Metamorphic testing** | Several follow-up tests per metamorphic relation | Works around the test oracle problem (CTAL-TA §3.3.2, §1.3.4) |
| A **calculation**: total, tax, fee, discount, refund, per-unit × quantity, currency conversion, rounding | **EP + BVA per operand, one worked example per formula branch, metamorphic relations for totals** | Every operand boundary (2-value → **3-value**) + one worked example per branch of the formula + every rounding rule the spec states; totals checked by MRs (reorder lines, add a zero item, double all amounts) | Data-based techniques find calculation defects (CTAL-TA §3.5.1); formula, precision and rounding rule come from the spec, never from the UI or code (`<?>` if missing); MRs cover the oracle problem (CTAL-TA §3.3.2) |
| **Dates, times, cut-offs, timers**: check-in / check-out, "within N hours", "until X before", expiry, DST, overnight, month end | **BVA at the spec's unit; Domain testing when two dates relate; State transition when expiry changes a state** | 2-value → **3-value** on both sides of every cut-off, in the reference time zone the spec names (`<?>` if none); `end ≥ start` borders as ON/OFF points; expiry as an event in the state table | Off-by-one and time-zone defects sit on time boundaries (CTFL §4.2.2); a rule over two dates is a domain (CTAL-TA §3.1.1); an expiry is a transition (CTFL §4.2.4) |
| **Concurrency / repeated action**: two users on one resource, double click, retry after timeout, back button, two tabs, duplicate submit | **Error guessing (fault list) + scenario exceptions** | Each shared resource once: the second actor / second attempt gets the spec's result (rejected, idempotent, queued — `<?>` if silent); flag `⚠ creates data` | Typical failure class that specs rarely state (CTFL §4.4.1); exceptions of the scenario model (CTAL-TA §3.2.3) |
| Behaviour known to break before: previous bugs in this module, typical dev mistakes, integrations, time zones, rounding, duplicates, concurrency | **Error Guessing / fault attacks** | Fault list from defect history | Uses knowledge of past failures (CTFL §4.4.1) |
| Spec is thin, outdated or missing; time pressure; new area | **Exploratory, session-based with a charter** | Charter + time box + session sheet + debrief | Useful with few/inadequate specs (CTFL §4.4.2, CTAL-TA §3.4.1) |
| Recurring quality aspects: UI consistency, required markers, error texts, usability, a regression area with recurring defect types | **Checklist-based** | Every checklist item answered yes / no / N/A | Consistency; records past failures (CTFL §4.4.3, CTAL-TA §3.4.2) |
| Story with AC written as Given/When/Then or rules | **ATDD / AC-based** | Every AC at least one test; positive → negative → non-functional | AC are test conditions (CTFL §4.5.2, §4.5.3) |
| Large volume of input data needed, little domain knowledge, automated oracle available | **Random testing** | No coverage criterion: stop by number of tests / time | Mostly for automation and fuzzing; not for manual test cases (CTAL-TA §3.1.3) |
| Code is available and the question is "did we exercise the logic?" | **Branch testing** (white-box) | Branch coverage (subsumes statement) | Objective coverage measure; misses omissions (CTFL §4.3.2, §4.3.3) |

Note on **use case testing**: removed from CTFL v4.0 (Release Notes); in CTAL-TA v4.0 it is part of
scenario-based testing (§3.2.3).

## 2. Combination rules

1. **EP and BVA come together.** Partition first, then add boundaries for ordered partitions.
   Unordered partitions (role, document type) get EP only.
2. **One variable → BVA; condition over several variables → domain testing.**
3. **Decision table cells are partitions.** Extended-entry tables use partitions or ranges as
   condition values, so BVA / domain testing can feed the table.
4. **State transition + BVA / decision table for guards** (CTAL-TA §3.5.1: "BVA can be used for guard
   conditions"). A guard with several conditions → decision table.
5. **Scenario + EP/BVA/domain:** one scenario may need several test cases for its variables
   (CTAL-TA §3.2.3). **Scenario + round-trip** for cyclical business processes (CTAL-TA §3.5.1).
6. **CRUD + roles:** run the CRUD matrix per role when permissions differ; reading data that was never
   created / already deleted is a mandatory negative test.
7. **Error guessing is always added** on top of systematic techniques; never the only technique when a
   spec exists (CTFL §4.1).
8. **Exploratory complements, not replaces.** Write a charter, not a script.
9. **White-box finds missing tests, not expected results** (CTFL §4.3.3).

## 3. Rigour by risk level (CTFL §5.2.3, CTAL-TA §3.5.1)

Risk level from `risk-prioritization.md`. "The higher the risk level, the more rigorous coverage may
be required", always weighed against effort (CTAL-TA §3.5.1).

| Technique | Low | Medium | High |
|---|---|---|---|
| EP | valid + main invalid | all partitions incl. invalid | all partitions incl. invalid |
| BVA | 2-value, main limit only | 2-value | **3-value** |
| Domain | simplified, main border | simplified | **reliable** |
| Combinatorial | base choice | pairwise | pairwise + known risky combos (all combinations only for small sets) |
| Decision table | minimized | minimized, checksum verified | **full table, no minimization** (CTAL-TA §3.3.1) |
| State transition | all states | valid transitions + key invalid | **all transitions**; + 1-switch / round-trip for sequence/loop risk |
| CRUD | every cell | every cell + key negatives | every cell, after each U every R, per role |
| Scenario | main + exceptions | all scenarios | all scenarios + loop coverage + EP/BVA on scenario variables |
| Experience-based | checklist | error guessing | fault list from bug history + exploratory session |

Experience-based testing alone is acceptable when coverage is hard to define, risk is low, or the
schedule is tight (CTAL-TA §3.5.1).

## 4. Selection factors to state when they decide the choice (CTAL-TA §3.5.1)

- **Test objectives** (what aspect to evaluate)
- **Product risks** — data-based techniques find data handling / calculation / combination defects;
  behaviour-based find missing features and processing defects; rule-based find logic defects
- **Test basis** — a model in the spec (statuses, flow diagram) → use the model-based technique;
  no oracle derivable → metamorphic or experience-based
- **Recurring defect types** → checklist-based / the techniques that found them before
- **Tester knowledge** — do not use an unfamiliar technique on critical work; little domain knowledge
  makes exploratory testing weak
- **SDLC** — iterative → lighter techniques; sequential → more formal
- **Contract / regulatory requirements** and **project constraints** (time, budget)

## 5. Anti-patterns (stop and correct yourself)

- BVA on an unordered partition, or on one variable when the rule involves two (use domain testing).
- One test that *executes* several invalid values in one step: the first error hides the rest.
  (A high-level case may *list* several invalid items in Covers; it is split before execution.)
- A calculation tested only with "the total looks right": no worked example, no rounding rule,
  no boundary on the operands.
- A date cut-off tested at one side only, or without naming the time zone.
- Minimizing a decision table for a high-risk rule; minimized table without the checksum check.
- State model with only the happy path, or without loops when the status can return.
- Combinatorial "all combinations" on many parameters (explodes) — use pairwise.
- Scenario test cases that only cover the main scenario.
- Duplicate test cases checking the same characteristic (CTFL §4.5.3, CTAL-TA §1.3.2 necessity).
- Expected result copied from what the code does today (the code is under test, not the oracle).
- Inventing a limit to make BVA possible: if the spec gives no number, it is `<?>` and a question.

## 6. Quick decision path

1. A status / lifecycle? → State transition (loops? → round-trip).
2. An entity handled by several functions or apps? → CRUD.
3. A multi-step user flow? → Scenario-based.
4. Result depends on 2+ conditions together? → Decision table.
5. Inputs with groups of values? → EP; ordered one-variable limits → BVA; multi-variable condition → Domain.
6. Many independent parameters / configurations? → Combinatorial (pairwise).
7. Expected result hard to compute? → Metamorphic relations.
8. Bug history or fragile area? → Error guessing (always at least a short fault list).
9. Thin spec? → Exploratory charter + questions. Recurring UI/quality aspects? → Checklist.
10. A formula or a money amount? → EP/BVA per operand + worked example per branch + MRs for totals.
11. A date, time, cut-off or timer? → BVA at the spec's unit, in the spec's time zone; two dates →
    Domain; expiry → an event in the state table.
12. A shared resource or a repeatable action? → Error guessing fault list + a scenario exception.
