# Worked example: Member cancels a gym membership (light report)

This shows the expected depth of a **light** report for a 6-requirement story: one intake
question, no gate, then sections 1.1, 1.3, 2, 4, 6. The input is first, the report second.
The story is invented for this example (a gym, not any real product). Business values in the
input (30 days, "one monthly fee") are part of the example story; the report never adds a value
the story does not give — every unknown is `<?>` plus a question.

---

## Input (as pasted by the user)

```
Story GM-207 — Member cancels a membership online

As a gym member I want to cancel my monthly membership online so that I stop paying without
visiting the front desk.

Requirements
R1. A member can cancel a membership from the membership page while the membership is Active.
R2. Cancellation is free when requested at least 30 days before the next billing date (club
    local time). Later requests are charged one final monthly fee.
R3. Refund = prepaid amount − final fee, returned to the original payment method. The refund
    should be processed quickly.
R4. After cancellation the membership status is Cancelled and a confirmation e-mail is sent.
R5. A membership cannot be cancelled twice, and not after it has already ended.
R6. Only the logged-in member who owns the membership can cancel it.

Acceptance criteria
AC1. Given an Active membership with the next billing date in 45 days, When the member cancels,
     Then the status is Cancelled and the full prepaid amount is refunded.
AC2. Given an Active membership with the next billing date in 10 days, When the member cancels,
     Then one monthly fee is charged and the rest of the prepaid amount is refunded.

Out of scope: freezing a membership; cancellation by front-desk staff.
```

**Intake question (one message):** existing coverage? risk notes? gate? light or full?
**User's answers:** no existing tests; refunds are money, treat as high risk; no gate; light.

---

## Report

# Test Design: GM-207 — Member cancels a membership online

**Test basis:** story GM-207 as pasted, 2026-11-10 · **Requirements owner:** PO (no project rule found)
**Defaults used:** English output; high-level cases; `.md`; no project test layers → no Layer column
**Existing coverage read:** No existing coverage provided

### 1.1 Requirements `[light]`
| ID | Requirement (quoted) | Oracle | Risk (L×I → level, reason) | Quality characteristics |
|---|---|---|---|---|
| R1 | "cancel a membership from the membership page while the membership is Active" | story | Medium × Medium → Medium: simple flow, but the feature's entry point | Functional completeness |
| R2 | "free when requested at least 30 days before the next billing date (club local time). Later requests are charged one final monthly fee" | story; PO for the boundary | High × High → High: time-zone boundary + money | Functional correctness |
| R3 | "Refund = prepaid amount − final fee, returned to the original payment method … processed quickly" | story (formula); PO ("quickly") | Medium × High → High: money, payment integration | Functional correctness, interoperability |
| R4 | "status is Cancelled and a confirmation e-mail is sent" | story | Medium × Medium → Medium | Functional correctness |
| R5 | "cannot be cancelled twice, and not after it has already ended" | story; PO for the result of a forbidden attempt | Medium × High → High: double-refund risk | Functional correctness |
| R6 | "Only the logged-in member who owns the membership can cancel it" | story; PO for the result | Medium × High → High: permissions | Functional correctness (access) |

**Out of scope:** freezing; staff cancellation · **Unknowns:** see 1.3

### 1.3 Test basis defects `[light if any]`
| ID | Req | Type | Description (quote) | Found by | Question / fix | Blocking |
|---|---|---|---|---|---|---|
| D1 | R2 | ambiguous | "at least 30 days before": is exactly 30 days free? Counting unit (day? hour?) not stated | BVA model | Q1 | Yes |
| D2 | R2 | missing | the time of day that anchors the billing date (00:00 club time? the hour of purchase?) | BVA model | Q2 | Yes |
| D3 | R3 | untestable | "processed quickly" — no number | smells list | Q3 | No |
| D4 | R3 | missing | final fee greater than the prepaid amount (discounted first month): refund negative? zero? | calculation model | Q4 | Yes |
| D5 | R3 | missing | refund call to the payment provider fails: is the membership cancelled anyway? | scenario exceptions | Q5 | No |
| D6 | R5, R6 | missing | result of a forbidden attempt (message, response) not stated | state model | Q6 | No |
| D7 | R2 | ambiguous | "one monthly fee": the member's current plan price or the list price? taxes in or out? | calculation model | Q7 | Yes |

## 2. Technique plan `[light]`
| Req | Signal in the requirement | Technique | Coverage criterion | Why (technique, ISTQB ref) |
|---|---|---|---|---|
| R1, R4 | user flow with AC | Scenario-based / AC-based | main scenario + each AC once; e-mail as the non-functional check | AC are test conditions; positive → negative → non-functional (CTFL §4.5.2–4.5.3, CTAL-TA §3.2.3) |
| R2 | cut-off "30 days before the next billing date", club time zone | BVA, 3-value, in club local time | 30 days + 1 unit, exactly 30 days, 30 days − 1 unit (unit `<?>`, Q1); partitions free / fee | High-risk time boundary: 3-value catches `<` coded as `≤` (CTFL §4.2.2); time zone is named by the spec |
| R2, R3 | formula "refund = prepaid − fee", fee = one monthly fee | Calculation: EP on the fee partitions + one worked example per branch + metamorphic relation | worked example for free and for fee; MR: the fee does not depend on how many months were prepaid; the fee ≥ prepaid case (D4) | Data-based techniques find calculation defects (CTAL-TA §3.5.1); "right amount" is an oracle problem → MR (CTAL-TA §3.3.2) |
| R4, R5 | statuses Active → Cancelled; "cannot be cancelled twice"; "not after it has ended" | State transition, all transitions | valid: cancel from Active; invalid: cancel from Cancelled, from Ended | Forbidden moves with double-refund risk (CTFL §4.2.4) |
| R6 | "only the logged-in member who owns the membership" | EP on the actor | owner / other member / not logged in | Unordered partitions, each once, invalid ones alone (CTFL §4.2.1) |
| R3, R5 | money + status + integration | Error guessing (fault list) | double click on Cancel; refund provider timeout; DST on the cut-off day | Typical failures the spec does not state (CTFL §4.4.1) |

## 4. Test cases `[light]`
| ID | Title (objective) | Priority | Level | Preconditions / test data | Steps | Expected result | Covers | Traces | Status | Flags |
|---|---|---|---|---|---|---|---|---|---|---|
| TC-01 | Cancel an Active membership more than 30 days before billing: full refund, status Cancelled, e-mail | P1 | High | Active membership, next billing in 45 days (AC1) | 1. Open membership page 2. Cancel 3. Confirm | status Cancelled; refund = prepaid amount `[spec]`; e-mail received `[spec]` | S1, T1 | R1, R3, R4 | New | ⚠ creates data |
| TC-02 | Cancel less than 30 days before billing: one monthly fee charged, rest refunded | P1 | High | Active membership, next billing in 10 days (AC2) | as TC-01 | refund = prepaid − one monthly fee `[spec]`; status Cancelled | S2, EX1 | R2, R3 | New | ⚠ creates data |
| TC-03 | Cut-off boundary: cancel at 30 days + 1 unit, exactly 30 days, 30 days − 1 unit before billing, club local time | P1 | High | three memberships; club time zone ≠ tester's | cancel each at its offset | +1: free `[spec]`; exactly 30 days: `<?>` (Q1); −1: fee `[spec]` | B1, B2, B3 | R2 | New | ⚠ creates data; unit `<?>` |
| TC-04 | Worked example of the refund formula with PO numbers | P2 | Low | prepaid `<?>`, monthly fee `<?>` (Q7) | cancel inside the fee window | refund = prepaid − fee, to 0.01 `<?>` rounding | EX2 | R3 | New | blocked by Q7 |
| TC-05 | Metamorphic: a 3-month prepaid and a 1-month prepaid membership on the same plan pay the same final fee | P2 | High | two memberships, same plan, different prepaid length | cancel both inside the fee window | fees identical; refunds differ by the extra months `[proposed]` | MR1 | R2, R3 | New | ⚠ creates data |
| TC-06 | Final fee greater than or equal to the prepaid amount (discounted first month) | P2 | High | membership where the monthly fee > prepaid amount | cancel inside the fee window | `<?>` (Q4); refund must not be negative `[proposed]` | EX3 | R3 | New | blocked by Q4 |
| TC-07 | Cancelled membership rejects a second cancel | P1 | High | membership cancelled in TC-01 | try to cancel again, in the UI and by direct request | rejected; status stays Cancelled; no second refund `[spec]`; message `<?>` (Q6) | INV1 | R5 | New | prerequisite: TC-01 |
| TC-08 | Membership that has already ended cannot be cancelled | P2 | High | membership ended yesterday; membership ending today at 23:59 club time, now 23:30 | try to cancel each | ended: rejected `[spec]`; ending today: allowed `[proposed]`; message `<?>` (Q6) | INV2, B4 | R5 | New | split per state at low level |
| TC-09 | Only the owner can cancel: another logged-in member, not logged in | P1 | High | membership of member A; member B session; anonymous session | B tries from the page URL and by direct request; anonymous tries | both rejected; status unchanged `[spec]`; response `<?>` (Q6) | P2, P3 | R6 | New | split per actor at low level |
| TC-10 | Double click on Cancel | P2 | High | Active membership | click Cancel / Confirm twice quickly | one cancellation, one refund, one e-mail `[proposed]` | F1 | R3, R5 | New | ⚠ creates data |
| TC-11 | Refund provider times out | P2 | High | provider sandbox set to time out | cancel | `<?>` (Q5): not cancelled with a retry message, or cancelled with refund pending `[proposed]` | F2 | R3 | New | blocked by Q5 |
| TC-12 | Cut-off on a DST change day in the club time zone | P3 | High | club in a DST zone; billing date two days after the clock change | cancel 30 days + 12 h before | free `[spec]`, computed in club local time | F3 | R2 | New | ⚠ creates data |

**Priority counts:** P1 = 5 (42 %) · P2 = 6 · P3 = 1 — P1 above 30 %: re-checked with the release-blocker
question; the five P1 are the full refund, the fee refund, the cut-off, the double refund and the
permission check — each failure is money or security, so they stay P1.
**Gaps:** none (R1–R6 each have at least one test case).
Status: all `New` (no existing coverage). Run list = all 12; TC-04, TC-06, TC-11 blocked until Q7, Q4, Q5 are answered.

## 6. Questions for the requirements owner `[light]`
| # | Req | Question | Blocking | Suggested default |
|---|---|---|---|---|
| Q1 | R2 | Is exactly 30 days before the billing date free or charged? In what unit do we count (days? hours)? | Yes | ≥ 30 days free, counted in whole days, club time |
| Q2 | R2 | What time of day anchors the billing date: 00:00 club time or the hour of the original purchase? | Yes | 00:00 club time |
| Q4 | R3 | If the final fee is greater than the prepaid amount, is the refund 0 and nothing extra is charged? | Yes | fee capped at the prepaid amount |
| Q7 | R2 | "One monthly fee": the member's current plan price or the list price? Taxes included? | Yes | the member's current plan price, taxes included |
| Q3 | R3 | "Processed quickly": is there a target (hours to request the refund, days to show it)? | No | refund requested within 1 h; UI says "5–10 business days" |
| Q5 | R3 | If the refund call fails, is the membership cancelled with the refund pending, or does it stay Active? | No | cancel, mark refund pending, retry automatically |
| Q6 | R5, R6 | What does the member see on a forbidden attempt (message, response)? | No | "This membership cannot be cancelled"; direct requests get a 4xx |

---

## Why this depth

- 12 cases for 6 requirements: every requirement has one positive case, every forbidden move and
  every actor partition is covered, the money boundary gets 3-value, and the fault list has three
  concrete attacks. No case repeats another's characteristic.
- Seven `<?>` and seven questions: the story gives no answer for them, so the report does not either.
- Nothing in the Expected result column comes from a UI or from code.
