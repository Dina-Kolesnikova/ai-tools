# Test analysis and test design process

> Section numbers verified 2026-11-10 against the CTAL-TA v4.0 PDF.

Source: ISTQB CTAL-TA v4.0 chapter 1 (and §5.3 for the feedback loop). Paraphrased; cite as `CTAL-TA §x`.

## 1. Test analysis (CTAL-TA §1.2.1)

**Entry criteria — check, and say which are missing:**
- test scope, objectives and approach are clear
- the test basis (requirements, stories) is defined
- known product risks are evaluated

**Tasks:**
1. Check the test basis for **completeness and testability**; collect extra information, including
   verbal (comments, chat answers from the requirements owner). Document test-basis defects that are
   not fixed directly (→ `test-basis-review.md`).
2. Determine the **test oracles** needed (section 5 below).
3. Define and prioritise **test conditions**, traceable to the test basis and shaped by product risks.
   In iterative work, include the **regression scope from impact analysis**. In Agile, test conditions
   can be written as acceptance criteria reflecting the story's risks.
4. **Work in stages:** high-level test conditions first ("Functionality of the payout screen"), then
   detailed ones ("Payout cannot be finalized while an order in the period is not delivered").
   This lets design start early, even when a story is still being refined.
5. Have stakeholders review the test conditions.

## 2. Test design (CTAL-TA §1.2.2)

- Decide per area: **high-level** or **low-level** test cases (section 3). Both need clear pass/fail criteria.
- Design new/changed test conditions against the quality criteria (section 4).
- For **regression**: select existing high-level tests or adapt existing low-level ones by priority —
  do not redesign.
- Capture **traceability**: test basis → test condition → test case.
- Define **test environment requirements** (section 6) and **test data requirements** (section 7).
- **When to stop designing:** the exit criteria from planning (e.g. coverage reached), residual risk
  level, or project constraints (time, budget). State which one ended the design.
- Stay tool- and technology-agnostic. Test cases must be understandable by other testers, developers
  who automate or rerun them, and auditors.

## 3. High-level vs low-level test cases (CTAL-TA §1.3.1)

| | High-level (abstract / logical) | Low-level (concrete / physical) |
|---|---|---|
| Contains | which test conditions are covered; abstract preconditions, inputs, expected results | concrete preconditions, input data, expected results, postconditions |
| Example | "Order more than one book with a total that gives a discount → discount is assigned" | "Order B1 ($10) + B2 ($20), total $30 → 10% discount, total $27" |
| Good for | checking that all test conditions are covered; charters; regression selection; stories still changing | execution by anyone; automation; precise expected results |

Design high-level first; one high-level case → one or more low-level cases. Going low-level is a step from
conceptual to technical and is often deferred to implementation when specific test data is needed.
Hybrid cases are normal (trade-off: maintainability vs comprehensibility).

**In this skill:** default to high-level cases in the plan, low-level cases only where the spec gives
concrete values or the user asks. Never invent concrete business values to make a case low-level.

## 4. Test case quality criteria (CTAL-TA §1.3.2) — self-check before output

| Criterion | Check |
|---|---|
| Correctness | the case really verifies its test condition |
| Feasibility | it can be executed (data, environment, permissions exist) |
| Necessity | clear objective in the title; no duplicates; nothing out of scope |
| Understandability | another tester can run it; no obvious explanations; split complex cases |
| Traceability | linked to requirement, test condition, coverage item, risk |
| Consistency | same terms everywhere (use the project glossary), same format |
| Precision | one interpretation only; no "suitable", "as needed", "several", "correct" |
| Completeness | required test data and a clear expected result present |
| Conciseness | small cases focused on few coverage items, so one failure does not block others |

## 5. Test oracles (CTAL-TA §1.3.4)

Ideally the test basis gives the expected result. If it cannot (missing or ambiguous requirements,
complex data, non-determinism), that is the **test oracle problem**. Options:
- **Human oracle** — ask the requirements owner / domain expert (default; raise a question)
- **Pseudo-oracle** — an independent system with the same spec (legacy system, old UI, a spreadsheet)
- **Model-based** — expected outputs from a state/scenario model
- **Property-based** — a property every result must satisfy (e.g. total ≥ 0, sorted list stays sorted)
- **Metamorphic relations** — `techniques-catalog.md`
Never use the current implementation as the oracle.

## 6. Test environment requirements (CTAL-TA §1.3.3)

When a test needs something special, state per item: identifier, description, who provides it, when
and how long it is needed, **fidelity** (how close to production). Types: hardware, software,
virtualised services, network, interfaces, tools, security, configuration. Cover setup, backup/restore,
roles and authorisation. Reference existing environments instead of re-describing them. Before
execution, a **smoke test** confirms the environment is ready (§1.2.3).

## 7. Test data requirements (CTAL-TA §1.3.5)

For each test case or group, state:
- **Purpose** — preconditions, system state, permissions, relations between records, system date/time
- **Coverage** — valid and invalid data matching the technique's coverage items
- **Similarity to production** — synthetic data with realistic patterns, outliers; personas help
- **Confidentiality** — never real personal data; pseudonymised or anonymised only (GDPR)
- **Dependencies** — data that needs steps to create first (→ prerequisite tests)
- **Time sensitivity / data aging** — dates relative to "today", expiring records, periods
- **Format** — e.g. JSON / CSV for API tests
- **Maintainability** — separate test logic from test data; avoid hard-coding in low-level cases

## 8. Keyword-driven test cases (CTAL-TA §1.3.6) — optional, for automation handoff

When the user plans to automate, express steps as keywords:
- **Action keywords** interact with the test object or environment ("Create Payout", "Log In As Role").
  **Verification keywords** assert results ("Verify Payout Status").
- Layers: **domain** keywords (business terms) on top of **test-interface** keywords (technical).
- Keyword rules: verb (+ noun), imperative, unique meaning, documented, domain vocabulary, reusable.
- Reuse existing keywords / page-object methods of the project's automation framework when known;
  add missing keywords explicitly. Keyword test cases also help manual testing move to automation later.

## 9. Test implementation notes (CTAL-TA §1.2.3)

Test procedures add: setup of preconditions (load data), verification of postconditions, and **reset /
cleanup steps** (reset data, environment). Note execution-order constraints and dependencies.

## 10. Feedback loop after execution (CTAL-TA §1.2.4, §5.3)

If the user brings test results or defects back:
- Analyse anomalies: a failure may be a product defect, or missing preconditions, wrong test data,
  a broken script/environment, or a misread spec.
- **Defect clusters**: compare predicted vs actual defect-prone areas (weight by severity); test
  harder where more defects appeared than predicted.
- Suggest additional tests from what was learned; identify new risks; propose regression suite changes.
- **Test gap analysis**: focus on recent changes not yet tested rather than all low-coverage areas.
- Classify defects consistently (severity, defect type / taxonomy, affected quality characteristic) to
  support root cause analysis (five whys, cause-effect diagram, Pareto).
- Add new fault types to the project's error-guessing list and checklists.
