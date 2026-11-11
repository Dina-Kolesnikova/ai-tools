# Techniques catalog: how to derive coverage items

Source: ISTQB CTFL Syllabus v4.0.1, chapter 4. Paraphrased; section numbers point to the original.
For *which* technique to pick, see `technique-selection.md`. This file is *how* to apply it.

Common vocabulary (§4.1):
- **Test condition**: what to test (an aspect of the test basis).
- **Coverage item**: the countable thing a technique produces (a partition, a boundary value,
  a decision-table column, a transition). Coverage % = exercised items / identified items × 100.
- **Black-box** = from specified behaviour (tests survive refactoring). **White-box** = from code
  structure. **Experience-based** = from tester knowledge; complements the other two.

---

## Equivalence Partitioning (EP) — §4.2.1

**Idea:** values in one partition are processed the same way, so one value per partition is enough.

**Derive:**
1. For each data element (input, output, configuration, internal/time value, interface parameter)
   list partitions. Partitions must not overlap and must not be empty.
2. Mark each partition **valid** or **invalid**. Agree what "invalid" means in the project
   (rejected? ignored? undefined by the spec?).
3. Coverage items = all partitions, valid and invalid.

**Coverage:** partitions exercised / partitions identified. With several inputs, **Each Choice**:
every partition of every input at least once (combinations are not required).

**Test case rules:** combine several *valid* partitions in one test; each *invalid* partition is
executed alone (otherwise the first rejection hides the others). At **high level** one case per
field may list all its invalid partitions in Covers ("reject each invalid document type: P4, P5");
when the case goes low-level or is automated, split it so each invalid item runs on its own.

**Example (generic):** field "Document type" — P1 passport, P2 ID card, P3 driving licence (valid),
P4 empty (invalid), P5 value not in the list via API (invalid). 5 coverage items. High level:
3 valid tests + 1 "reject each invalid document type" case covering P4, P5. Low level: 3 + 2, one
invalid value per test. (With a second input, its valid partitions can ride along in the same 3
valid tests: that is Each Choice.)

---

## Boundary Value Analysis (BVA) — §4.2.2

**Idea:** defects cluster where a boundary is misplaced or missing. Only for **ordered** partitions.

**Derive:**
1. Start from the EP partitions of an ordered element.
2. Boundary values = min and max of each partition.
3. **2-value BVA:** each boundary value + its closest neighbour in the adjacent partition.
   **3-value BVA:** each boundary value + both neighbours.
4. Pick the step: 1 for integers, the smallest unit for money (0.01) or time (1 day / 1 minute) as
   the spec defines it. If the spec does not define the unit or the limit, it is a question (`<?>`).

**Coverage:** exercised boundary items / identified boundary items.

**Why 3-value:** if `x ≤ 10` is coded as `x = 10`, the 2-value set {10, 11} passes; 3-value adds 9,
which fails. Use 3-value for high-risk limits.

**Example (generic):** "Quantity 1..100" → partitions `≤0` | `1..100` | `≥101`.
2-value: 0, 1, 100, 101. 3-value: 0, 1, 2, 99, 100, 101.

---

## Decision Table Testing — §4.2.3

**Idea:** systematically cover combinations of conditions that lead to different actions; reveals
gaps and contradictions in requirements.

**Derive:**
1. Rows: conditions (top) and actions (bottom).
2. Columns: rules = unique combinations. Full table = 2^n columns for n Boolean conditions.
3. Notation: `T` / `F`; `–` = irrelevant; `N/A` = infeasible; action `X` = happens, blank = does not.
4. Remove infeasible columns. Merge columns where a condition does not change the outcome (`–`)
   only if risk allows.
5. Extended-entry tables may use partitions or ranges as condition values.
6. Any column whose action the spec does not define = a gap → question.

**Coverage:** exercised feasible columns / all feasible columns. Each column = at least one test case.

**Example (generic):** "Discount if member AND order ≥ threshold; free delivery if member OR order ≥ threshold"
→ 2 conditions, 4 columns, 2 actions; check each column's actions against the spec.

---

## State Transition Testing — §4.2.4

**Idea:** model states and events; test the valid flow and attempts at forbidden moves.

**Derive:**
1. List states and events. Label transitions `event [guard] / action`.
2. Build the **state table**: rows = states, columns = events (+ guards). Filled cell = valid
   transition (target state, action). **Empty cell = invalid transition.**
3. Coverage items depend on the criterion:
   - **All states:** each state visited (weakest).
   - **Valid transitions (0-switch):** each valid transition once (most widely used).
   - **All transitions:** all valid transitions + an attempt at every invalid one (minimum for
     critical software).
4. A test case = sequence of events from a start state. One test usually covers several valid
   transitions; **each invalid transition is attempted alone** (avoid defect masking). At high
   level one case per state may list that state's invalid events in Covers ("Paid rejects: edit,
   revert, delete — INV2, INV3, INV4"); split per event at low level.
5. Expected result of an invalid attempt = the spec's rule (rejected, error, no state change).
   If the spec is silent → question.

**Coverage:** exercised (or attempted) transitions / transitions of the chosen kind.
Valid transitions ⊃ all states; all transitions ⊃ both.

**Example (generic):** Draft → Finalized → Paid. Valid: finalize, pay (and delete Draft, if
specified). Invalid attempts: pay a Draft, return Paid → Finalized, edit Paid, delete Paid.

---

## Statement and Branch testing (white-box) — §4.3

- **Statement coverage:** executed statements / executable statements.
- **Branch coverage:** exercised branches (conditional and unconditional) / all branches.
  100% branch ⇒ 100% statement, not vice versa.
- Strength: objective coverage measure, works even with a vague spec, usable in code review.
- Weakness: cannot find **omissions** (requirements never implemented); covering a statement does
  not guarantee a data-dependent failure shows (e.g. division by zero only for 0).
- In this skill: use to find **untested paths**, never to set expected results.

---

## Error Guessing — §4.4.1

**Derive a fault list** from: how the application failed before, typical developer mistakes, failures
in similar applications. Categories from the syllabus:
- **Input:** valid input rejected, parameter missing or wrong
- **Output:** wrong format, wrong result
- **Logic:** missing case, wrong operator
- **Computation:** wrong operand, wrong formula, rounding at the wrong step, currency precision
- **Interfaces:** parameter mismatch, incompatible types (UI ↔ API ↔ mobile)
- **Data:** wrong initialisation, wrong type, duplicates, stale data

Two more groups that recur in web products (not a syllabus category; practical additions):
- **Time:** time zone / DST, off-by-one at a cut-off, system date vs user date, month end, leap day
- **Repetition:** double submit, retry after timeout, back button, two tabs, the same action by two users

**Fault attack:** for each item on the list, design a test that tries to make it fail.
Feed the list with the project's defect history (bug folders, tracker).

---

## Exploratory Testing — §4.4.2

Session-based form:
- **Charter:** "Explore <area> with <resources/data> to discover <information/risks>".
- **Time box** (e.g. 60–90 min), **session sheet** (steps, findings, questions), **debrief**.
- Best when the spec is thin or time is short; can use EP/BVA inside the session.
In this skill: output charters, not scripted steps.

---

## Checklist-Based Testing — §4.4.3

- Items phrased as questions, each checkable separately and directly.
- Do not include items that can be automated, that are entry/exit criteria, or that are too general.
- Keep it short; update from defect analysis (items wear out as developers learn).
- High-level checklists give more variability (coverage) but less repeatability.

---

## Collaboration-based — §4.5

- **User story 3 C's:** Card, Conversation, Confirmation (= acceptance criteria). INVEST.
- **Acceptance criteria** = test conditions; formats: scenario-oriented (Given/When/Then) or
  rule-oriented (bullet list, input-output table).
- **ATDD order:** positive → negative → non-functional. Tests cover all characteristics of the
  story and do not go beyond it; no two tests describe the same characteristic.

---
---

# Advanced techniques (CTAL-TA v4.0, chapter 3)

Source: ISTQB Advanced Level Test Analyst Syllabus v4.0. Paraphrased; cite as `CTAL-TA §x`.
These extend the Foundation techniques above.

## Domain Testing — CTAL-TA §3.1.1

**Idea:** EP + BVA generalised to partitions defined by conditions over one or more variables combined
with AND / OR / NOT. Each atomic condition is a **border**. Finds wrong operators and wrong constants.

- **Closed border:** `≤ ≥ =`. **Open border:** `< > ≠`.
- **ON point:** closed border → on the border; open border → inside the partition, closest to the border.
- **OFF point:** closed border → outside, closest to the border; open border → on the border.
- **IN point:** inside, not ON. **OUT point:** outside, not OFF. Precision = the smallest step the spec defines.

**Coverage criteria:**
| Border operator | Simplified domain | Reliable domain |
|---|---|---|
| `< ≤ > ≥` | 1 ON + 1 OFF | 1 ON + 1 OFF + 1 IN + 1 OUT |
| `=` | 1 ON + 2 OFF (both sides) | same |
| `≠` | 1 OFF + 2 ON (both sides) | same |

Reliable gives slightly more items but finds considerably more defects. Points can be shared between
borders (common IN point, ON/OFF pair reused for the adjacent partition).

**Example (generic):** "End date must be on or after start date" → border `end ≥ start` (closed).
ON: end = start. OFF: end = start − 1 day. IN: end = start + 10 days. OUT: end = start − 10 days.

## Combinatorial Testing — CTAL-TA §3.1.2

**Idea:** interaction failures come from specific combinations of parameter values; about 97% are caused
by 1–2 interacting parameters (study cited in the syllabus), so pairwise is effective.

- First reduce each parameter's values with EP. Optionally draw a **classification tree**.
- **Base choice:** pick the most important value of each parameter → base test; then change one
  parameter at a time to each non-base value.
- **Pairwise:** every pair of values of any two parameters appears in at least one test. Use a tool
  (e.g. PICT) for generation; state the tool's output, do not hand-craft large sets.
- Remove infeasible combinations (constraints); add known problematic combinations manually.
- Two uses: combinations of **configurations** (same test case run per configuration) or of **input
  values** (each combination becomes a test case).

## Random Testing — CTAL-TA §3.1.3

Random inputs from a defined distribution (operational profile for validation, usage-agnostic for
verification). No coverage criterion: stop by number of tests or time. Needs an automated oracle.
Strengths: large data volume, avoids tester bias. Limits: ignores data meaning, redundancy,
non-repeatable results. In this skill: recommend only for automation / fuzzing, not as manual test cases.

## CRUD Testing — CTAL-TA §3.2.1

**Idea:** verify the lifecycle of data entities across the functions that touch them.

1. **CRUD matrix:** columns = entities, rows = functions (screens, API endpoints, mobile actions, jobs);
   cells = C, R, U, D. Pay special attention to implicit **R** after C/U/D (lists, details, reports,
   other apps).
2. **Completeness (static):** every entity has all of C, R, U, D somewhere. A missing operation is an
   anomaly → question.
3. **Consistency (dynamic):** test cases per entity that chain functions through its whole lifecycle,
   checking the entity is consistent everywhere it is read. Include negatives: read before create,
   update/read after delete, operations by a role without permission.

**Coverage:** operations executed / operations in the matrix. Stronger: after each U, every R.
Finds data integrity, access control and inconsistency defects. Mainly system level.

## State Transition Testing, extra criteria — CTAL-TA §3.2.2

In addition to CTFL's all states / valid transitions / all transitions:
- **N-switch coverage:** valid sequences of N+1 consecutive transitions. 0-switch = valid transitions.
  1-switch = every valid pair of consecutive transitions. 0- and 1-switch are common; 2-switch+ only
  for high risk from unexpected event sequences (the count grows exponentially).
- **Round-trip coverage:** every loop that starts and ends in the same state with no other state
  repeated. Highly effective; use when statuses can return (reopen, restore, resubmit).
- First check that the model in the spec has the detail needed for testing; adapt it if not.

## Scenario-Based Testing (incl. use cases) — CTAL-TA §3.2.3

**Idea:** realistic workflows through the test item, from user research, user stories, personas,
journey maps. Models: **use case** or **activity diagram** (also flowchart, BPMN, sequence diagram).

**Use case scenarios:**
- **Main scenario** (happy path) — exactly one per use case.
- **Extension / alternative** — a different path that still reaches the goal.
- **Exception** — the goal is not reached (abnormal use, invalid input).

**Activity diagram elements:** start/end, actions, decision and merge nodes, fork/join (parallel work),
swim lanes (actors / systems).

**Coverage:** executed scenarios / identified scenarios. Without loops, one test case per scenario.
With loops use **simple loop coverage**: loop 0 times, 1 time, a typical number, the maximum.
A scenario may need several test cases for EP/BVA of its variables. Usually system / acceptance level,
end-to-end.

## Decision Table Testing, advanced — CTAL-TA §3.3.1

- Full table: number of rules = product of the numbers of values of all conditions.
- **Minimization:** merge action-equivalent rules that differ in one condition and cover all its values;
  replace that condition with `–`. Remove infeasible rules first. Check whether further merging is possible.
- **Review criteria:** consistency (same combination → same actions), feasibility, completeness,
  correctness; rules should not overlap.
- **Checksum:** each minimized rule scores 1 × (number of values of each `–` condition). Sum must equal
  the full table's rule count: less = gap, more = overlap / infeasible rules. Equal sums do not prove
  equivalence.
- Implementing a `–`: choose a concrete value and state it.
- **High risk: do not minimize** — cover all feasible columns of the full table.

## Metamorphic Testing — CTAL-TA §3.3.2

**Idea:** when the exact expected result is hard to know, test a **metamorphic relation (MR)**: how a
change of input must change (or not change) the output.

- Source test case → follow-up test case(s) by applying the MR → evaluate them together.
- Generic MRs useful for business apps: reordering input rows does not change a total; filtering by A
  then B equals filtering by B then A; a subset filter never returns more rows than the full list;
  doubling all line amounts doubles the total; adding a zero-amount item does not change the total;
  exporting then importing gives the same data.
- No coverage measure; one test per MR is not enough. Combines well with random testing in automation.
- Preferred technique when there is a test oracle problem (CTAL-TA §1.3.4) and for AI-based systems.

## Test Charters for session-based testing — CTAL-TA §3.4.1

Mission format: **"Explore [target] with [resources] to discover [information]"**.
Optional parts: duration, objectives, scope (areas, techniques, test ideas, what is out of scope),
entry criteria, product information, **limitations (what the product must never do)**, environment,
data sources, **historical defects**, constraints and risks. Results go to a session sheet (questions,
observations, ideas, results). More detail = less freedom; stating what the system must never do
reduces false positives.

## Checklists, advanced — CTAL-TA §3.4.2

- Decide scope and type: **read-do** (concrete items, e.g. specific invalid inputs) or **do-confirm**
  (thinking aid, e.g. "are search results relevant?").
- Sources: experienced testers, defect taxonomies, documentation, risks, existing test cases.
- Items: clear, specific, actionable, answerable **yes / no / N/A**, each with a priority.
- Group by functional area, role or test level. Never finished: refine after each cycle.

## Crowd testing — CTAL-TA §3.4.3

An approach, not a design technique: many diverse testers / devices. Good for usability and environment
diversity; risks are uneven quality, communication, confidentiality. Mention only if the user asks.

---

Test case quality criteria, test data and test oracles: see `test-analysis-process.md`.
