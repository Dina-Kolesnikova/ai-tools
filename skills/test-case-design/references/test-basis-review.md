# Reviewing the test basis (find spec defects before writing tests)

> Section numbers verified 2026-11-10 against the CTAL-TA v4.0 PDF. The five review techniques
> (ad hoc, checklist-based, scenario-based, role-based, perspective-based reading) are CTAL-TA
> §5.2.2 "Applying Review Techniques"; CTFL v4.0.1 does not list them.

Source: ISTQB CTAL-TA v4.0 §5.1, §5.2 (phase containment), §1.2.1. Paraphrased.

Goal: detect defects in requirements while they are cheap to fix (shift left). Every test model built
in Step 4 of the skill is also a review tool: building it shows gaps. Report them as
**Test basis defects**, separately from test cases.

## 1. Defects that each model reveals (CTAL-TA §5.2.1)

| Model | Typical spec defects it reveals |
|---|---|
| EP / domain model | overlapping partitions, gaps between partitions, empty partitions, missing or inconsistent boundary values, unclear precision (step) |
| Combinatorial model | missing or incorrect parameter combinations, undocumented constraints |
| CRUD matrix | entity without a full lifecycle (no delete, no edit, never read), inconsistent use across functions/apps, missing access rules |
| State model | missing or wrong states, missing/improper transitions, wrong guard conditions or actions, unreachable or redundant states, dead-end states, nondeterminism (same event → two targets), endless loops |
| Scenario / activity model | missing, unreachable or dead-end actions, wrong order, wrong / non-exclusive / incomplete decision conditions, missing exception handling, parallel flows not synchronised |
| Decision table | missing combinations, missing actions for a combination, overlapping, inconsistent, redundant or infeasible rules, overly complex logic |
| Metamorphic relations | business rules that contradict each other |
| Any model | inconsistent naming, inconsistent values, missing / ambiguous / unnecessary information, duplicates, typos |

## 2. Review techniques (CTAL-TA §5.2.2)

Pick by goal, test basis type and risk:
| Technique | How | Best when |
|---|---|---|
| **Ad hoc** | read and note anomalies, no structure | quick look, low risk |
| **Checklist-based** | check against a checklist tailored to basis type and risk; not limited to it | recurring defect types; use the shared checklist (section 3) |
| **Scenario-based** | dry-run the expected usage step by step, then think beyond it | the basis is a use case, flow or activity diagram |
| **Role-based** | review as specific user types / org roles (persona: admin, dispatcher, driver, new user, experienced user) | several roles with different permissions |
| **Perspective-based reading** | review from a stakeholder viewpoint **and try to produce that stakeholder's work product** (as tester: draft acceptance tests) | the most in-depth individual review; default for this skill |

**Default for this skill:** perspective-based reading as a tester — the act of deriving test conditions and
models is the review. Whatever blocks deriving a test (no expected result, undefined value, conflict) is a
test basis defect.

## 3. Requirement checklist and vague words

Shared with `story-readiness-check`: `../../_shared/requirement-smells.md` (ISO 29148
characteristics, vague-words list, the yes/no requirement checklist, defect types). Use it for the
checklist-based review above and quote the word you flag.

## 4. Output format for test basis defects

| ID | Requirement | Defect type | Description (quote the source) | Found by | Suggested question / fix | Blocking? |
|---|---|---|---|---|---|---|
| D1 | R3 | Missing transition | "Paid" has no rule for edit/revert | State model | "Can a Paid payout be edited or reverted? If not, what error is shown?" | Yes |

Defect types: the list in `requirement-smells.md` section 4.
