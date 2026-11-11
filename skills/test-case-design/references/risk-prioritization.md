# Risk and prioritisation

Sources: ISTQB CTFL Syllabus v4.0.1, §5.1.5 (test case prioritisation) and §5.2 (risk management);
ISTQB CTAL-TA v4.0 chapter 2 (sections 4–5 below). Section numbers without prefix are CTFL.
The 3×3 matrix and the P1–P3 mapping below are a practical qualitative scheme built on §5.2.3;
the syllabus allows quantitative (likelihood × impact) or qualitative (risk matrix) assessment.

## 1. Risk level (§5.2.1, §5.2.3)

Risk level = **likelihood** × **impact**. Assess per requirement (R-number), not per test case.

**Likelihood** — how likely a defect is here:
| Level | Signals |
|---|---|
| High | new or rewritten code, complex logic (many conditions, calculations, statuses), integrations, time zones / dates, previous defects in this area, unclear spec |
| Medium | changed existing behaviour, moderate logic |
| Low | stable area, simple display, no recent change |

**Impact** — what happens if it fails (product risks, §5.2.2):
| Level | Signals |
|---|---|
| High | money (calculation, payout, pricing), data loss or corruption, security / permissions, legal or contractual, blocks a core flow, many users |
| Medium | wrong but recoverable result, workaround exists, one role affected |
| Low | cosmetic, rare path, easy manual fix |

**Matrix:**
| Likelihood \ Impact | Low | Medium | High |
|---|---|---|---|
| **High** | Medium | High | High |
| **Medium** | Low | Medium | High |
| **Low** | Low | Low | Medium |

State the reason in one line, e.g. "High: payout amount (impact) + status logic with known bugs (likelihood)".

## 2. What the risk level changes (§5.2.3)

Risk analysis decides: test scope, test levels/types, **techniques and coverage**, effort,
priority, and whether extra activities (review, static analysis) are needed.
Rigour per level: see `technique-selection.md` section 3.

## 3. Test case priority (§5.1.5)

| Priority | Meaning | Default from risk |
|---|---|---|
| **P1** | Run first; a failure blocks release | High-risk requirement: positive core flow + key negative / invalid transitions |
| **P2** | Run in the same cycle | Medium risk, and the remaining tests of high-risk requirements |
| **P3** | Run if time allows / regression later | Low risk, cosmetic, rare paths |

Strategies the syllabus names:
- **Risk-based** (default here): tests for the highest risks first.
- **Coverage-based**: the test that adds the most coverage first (additional coverage variant).
- **Requirements-based**: follow requirement priorities set by stakeholders, if given.

Always respect dependencies: if a P1 test needs data created by a P2 test, the P2 test runs first
(mark it as a prerequisite). Account for environment and people availability.

## 4. Risk assessment factors and test items (CTAL-TA §2.1)

When estimating risk level with stakeholders, consider:
- frequency of use and criticality of the affected features
- criticality of the affected business objectives
- financial, environmental and reputational damage
- **quality of the test basis** (a vague spec raises likelihood)
- legal or safety needs

Risk is rarely uniform: **split the test object into test items** (features, components, interfaces)
and assess each separately. Categorise each risk by the quality characteristic it affects
(`quality-characteristics.md`). For each risk propose the mitigation: static testing (review, model) or
dynamic testing, with test level, test type, technique, independence and thoroughness — prefer the
earliest activity that mitigates it (shift left). Risks change: re-assess each iteration.

## 5. Regression test selection (CTAL-TA §2.2)

Review regression scope every cycle. For manual execution no single technique is best; combine:
| Technique | Select tests that... |
|---|---|
| **Impact analysis** | touch the changed items (code diff, changed endpoints/screens) — most reliable when known |
| **Risk-based** | trace to the highest risks in the (updated) risk register |
| **History-based** | found defects before or were sensitive to similar changes; plus some not run for a long time |
| **Coverage-based** | give the most coverage with few tests (balance size vs coverage gain) |
| **Requirements traceability matrix** | cover directly changed requirements/AC **and related features** (side effects) |
| **Operational profiles** | follow the most frequent and critical user journeys (quick overall check after a big change) |

After each cycle, keep the selection techniques that found defects and replace those that did not.

## 6. Risk responses beyond testing (CTFL §5.2.4)

Mention when relevant, do not design tests for them: risk acceptance, transfer, contingency plan,
review / static analysis, independent tester, extra test types (performance, security, usability)
for quality characteristics this test set does not cover.
