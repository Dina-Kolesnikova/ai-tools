# Worked example: Guest cancels a hotel booking (light report)

This shows the expected depth of a **light** report for a 6-requirement story: one intake
question, no gate, then sections 1.1, 1.3, 2, 4, 6. The input is first, the report second.
Business values in the input (48 hours, "first night") are part of the example story; the report
never adds a value the story does not give — every unknown is `<?>` plus a question.

---

## Input (as pasted by the user)

```
Story HB-412 — Guest cancels a booking online

As a guest I want to cancel my confirmed hotel booking online so that I get my refund
without calling support.

Requirements
R1. A guest can cancel a booking from the booking details page while the booking is Confirmed.
R2. Free cancellation is allowed until 48 hours before check-in (hotel local time). After that,
    the cancellation fee is the price of the first night.
R3. Refund = total paid − cancellation fee, returned to the original payment method. The refund
    should be processed quickly.
R4. After cancellation the booking status is Cancelled and a confirmation e-mail is sent.
R5. A booking cannot be cancelled twice, and not after check-in has started.
R6. Only the logged-in guest who made the booking can cancel it.

Acceptance criteria
AC1. Given a Confirmed booking with check-in in 72 hours, When the guest cancels, Then the status
     is Cancelled and the refund is 100% of the total paid.
AC2. Given a Confirmed booking with check-in in 24 hours, When the guest cancels, Then the fee is
     the first night's price and the rest is refunded.

Out of scope: cancelling one room of a multi-room booking; cancellation by an agent.
```

**Intake question (one message):** existing coverage? risk notes? gate? light or full?
**User's answers:** no existing tests; refunds are money, treat as high risk; no gate; light.

---

## Report

# Test Design: HB-412 — Guest cancels a booking online

**Test basis:** story HB-412 as pasted, 2026-11-10 · **Requirements owner:** PO (no project rule found)
**Defaults used:** English output; high-level cases; `.md`; no project test layers → no Layer column
**Existing coverage read:** No existing coverage provided

### 1.1 Requirements `[light]`
| ID | Requirement (quoted) | Oracle | Risk (L×I → level, reason) | Quality characteristics |
|---|---|---|---|---|
| R1 | "cancel a booking from the booking details page while the booking is Confirmed" | story | Medium × Medium → Medium: simple flow, but the feature's entry point | Functional completeness |
| R2 | "Free cancellation … until 48 hours before check-in (hotel local time). After that, the cancellation fee is the price of the first night" | story; PO for the boundary | High × High → High: time-zone boundary + money | Functional correctness |
| R3 | "Refund = total paid − cancellation fee, returned to the original payment method … processed quickly" | story (formula); PO ("quickly") | Medium × High → High: money, payment integration | Functional correctness, interoperability |
| R4 | "status is Cancelled and a confirmation e-mail is sent" | story | Medium × Medium → Medium | Functional correctness |
| R5 | "cannot be cancelled twice, and not after check-in has started" | story; PO for the result of a forbidden attempt | Medium × High → High: double-refund risk | Functional correctness |
| R6 | "Only the logged-in guest who made the booking can cancel it" | story; PO for the result | Medium × High → High: permissions | Functional correctness (access) |

**Out of scope:** multi-room partial cancellation; agent cancellation · **Unknowns:** see 1.3

### 1.3 Test basis defects `[light if any]`
| ID | Req | Type | Description (quote) | Found by | Question / fix | Blocking |
|---|---|---|---|---|---|---|
| D1 | R2 | ambiguous | "until 48 hours before check-in": is exactly 48 h free or charged? Counting unit (minute? hour?) not stated | BVA model | Q1 | Yes |
| D2 | R2 | missing | the check-in *time* that anchors the 48 h is not defined (hotel check-in hour? 00:00?) | BVA model | Q2 | Yes |
| D3 | R3 | untestable | "processed quickly" — no number | smells list | Q3 | No |
| D4 | R3 | missing | fee greater than total paid (discounted booking): refund negative? zero? | calculation model | Q4 | Yes |
| D5 | R3 | missing | refund call to the payment provider fails: is the booking cancelled anyway? | scenario exceptions | Q5 | No |
| D6 | R5, R6 | missing | result of a forbidden attempt (message, response) not stated | state model | Q6 | No |
| D7 | R2 | ambiguous | "price of the first night": before or after taxes and discounts? | calculation model | Q7 | Yes |

## 2. Technique plan `[light]`
| Req | Signal in the requirement | Technique | Coverage criterion | Why (technique, ISTQB ref) |
|---|---|---|---|---|
| R1, R4 | user flow with AC | Scenario-based / AC-based | main scenario + each AC once; e-mail as the non-functional check | AC are test conditions; positive → negative → non-functional (CTFL §4.5.2–4.5.3, CTAL-TA §3.2.3) |
| R2 | cut-off "48 hours before check-in", hotel time zone | BVA, 3-value, in hotel local time | 48 h + 1 unit, 48 h exactly, 48 h − 1 unit (unit `<?>`, Q1); partitions free / fee | High-risk time boundary: 3-value catches `<` coded as `≤` (CTFL §4.2.2); time zone is named by the spec |
| R2, R3 | formula "refund = total paid − fee", fee = first night | Calculation: EP on the fee partitions + one worked example per branch + metamorphic relation | worked example for free and for fee; MR: fee does not depend on nights beyond the first; the fee ≥ total case (D4) | Data-based techniques find calculation defects (CTAL-TA §3.5.1); "right amount" is an oracle problem → MR (CTAL-TA §3.3.2) |
| R4, R5 | statuses Confirmed → Cancelled; "cannot be cancelled twice"; "not after check-in" | State transition, all transitions | valid: cancel from Confirmed; invalid: cancel from Cancelled, from Checked-in, from past | Forbidden moves with double-refund risk (CTFL §4.2.4) |
| R6 | "only the logged-in guest who made the booking" | EP on the actor | owner / other guest / not logged in | Unordered partitions, each once, invalid ones alone (CTFL §4.2.1) |
| R3, R5 | money + status + integration | Error guessing (fault list) | double click on Cancel; refund provider timeout; DST on the cut-off day | Typical failures the spec does not state (CTFL §4.4.1) |

## 4. Test cases `[light]`
| ID | Title (objective) | Priority | Level | Preconditions / test data | Steps | Expected result | Covers | Traces | Status | Flags |
|---|---|---|---|---|---|---|---|---|---|---|
| TC-01 | Cancel a Confirmed booking more than 48 h before check-in: full refund, status Cancelled, e-mail | P1 | High | Confirmed booking, check-in in 72 h (AC1) | 1. Open booking details 2. Cancel 3. Confirm | status Cancelled; refund = total paid `[spec]`; e-mail received `[spec]` | S1, T1 | R1, R3, R4 | New | ⚠ creates data |
| TC-02 | Cancel less than 48 h before check-in: fee = first night, rest refunded | P1 | High | Confirmed booking, check-in in 24 h (AC2) | as TC-01 | refund = total paid − first-night price `[spec]`; status Cancelled | S2, EX1 | R2, R3 | New | ⚠ creates data |
| TC-03 | Cut-off boundary: cancel at 48 h + 1 unit, exactly 48 h, 48 h − 1 unit before check-in, hotel local time | P1 | High | three bookings; hotel time zone ≠ tester's | cancel each at its offset | +1: free `[spec]`; exactly 48 h: `<?>` (Q1); −1: fee `[spec]` | B1, B2, B3 | R2 | New | ⚠ creates data; unit `<?>` |
| TC-04 | Worked example of the refund formula with PO numbers | P2 | Low | total `<?>`, first night `<?>` (Q7) | cancel inside the fee window | refund = total − first night, to 0.01 `<?>` rounding | EX2 | R3 | New | blocked by Q7 |
| TC-05 | Metamorphic: a 3-night and a 1-night booking with the same first-night price pay the same fee | P2 | High | two bookings, same first night, different length | cancel both inside the fee window | fees identical; refunds differ by the extra nights `[proposed]` | MR1 | R2, R3 | New | ⚠ creates data |
| TC-06 | Fee greater than or equal to total paid (discounted booking) | P2 | High | booking where first-night price > total paid | cancel inside the fee window | `<?>` (Q4); refund must not be negative `[proposed]` | EX3 | R3 | New | blocked by Q4 |
| TC-07 | Cancelled booking rejects a second cancel | P1 | High | booking cancelled in TC-01 | try to cancel again, in the UI and by direct request | rejected; status stays Cancelled; no second refund `[spec]`; message `<?>` (Q6) | INV1 | R5 | New | prerequisite: TC-01 |
| TC-08 | Booking with check-in started or in the past cannot be cancelled | P2 | High | check-in today 14:00 hotel time, now 15:00; a booking with past check-out | try to cancel each | rejected `[spec]`; message `<?>` (Q6) | INV2, INV3 | R5 | New | split per state at low level |
| TC-09 | Only the owner can cancel: another logged-in guest, not logged in | P1 | High | booking of guest A; guest B session; anonymous session | B tries from the details URL and by direct request; anonymous tries | both rejected; status unchanged `[spec]`; response `<?>` (Q6) | P2, P3 | R6 | New | split per actor at low level |
| TC-10 | Double click on Cancel | P2 | High | Confirmed booking | click Cancel / Confirm twice quickly | one cancellation, one refund, one e-mail `[proposed]` | F1 | R3, R5 | New | ⚠ creates data |
| TC-11 | Refund provider times out | P2 | High | provider sandbox set to time out | cancel | `<?>` (Q5): not cancelled with a retry message, or cancelled with refund pending `[proposed]` | F2 | R3 | New | blocked by Q5 |
| TC-12 | Cut-off on a DST change day in the hotel time zone | P3 | High | hotel in a DST zone; check-in two days after the clock change | cancel 48 h 30 min before | free `[spec]`, computed in hotel local time | F3 | R2 | New | ⚠ creates data |

**Priority counts:** P1 = 5 (42 %) · P2 = 6 · P3 = 1 — P1 above 30 %: re-checked with the release-blocker
question; the five P1 are the full refund, the fee refund, the cut-off, the double refund and the
permission check — each failure is money or security, so they stay P1.
**Gaps:** none (R1–R6 each have at least one test case).
Status: all `New` (no existing coverage). Run list = all 12; TC-04, TC-06, TC-11 blocked until Q7, Q4, Q5 are answered.

## 6. Questions for the requirements owner `[light]`
| # | Req | Question | Blocking | Suggested default |
|---|---|---|---|---|
| Q1 | R2 | Is exactly 48 h before check-in free or charged? In what unit do we count (minutes)? | Yes | ≥ 48 h free, counted in minutes |
| Q2 | R2 | Which check-in time anchors the 48 h: the hotel's check-in hour or 00:00 of the check-in date? | Yes | hotel check-in hour |
| Q4 | R3 | If the fee is greater than the total paid, is the refund 0 and nothing extra is charged? | Yes | fee capped at total paid |
| Q7 | R2 | "Price of the first night": including taxes? after discounts? | Yes | first night as shown on the invoice, taxes included |
| Q3 | R3 | "Processed quickly": is there a target (hours to request the refund, days to show it)? | No | refund requested within 1 h; UI says "5–10 business days" |
| Q5 | R3 | If the refund call fails, is the booking cancelled with the refund pending, or does it stay Confirmed? | No | cancel, mark refund pending, retry automatically |
| Q6 | R5, R6 | What does the guest see on a forbidden attempt (message, response)? | No | "This booking cannot be cancelled"; direct requests get a 4xx |

---

## Why this depth

- 12 cases for 6 requirements: every requirement has one positive case, every forbidden move and
  every actor partition is covered, the money boundary gets 3-value, and the fault list has three
  concrete attacks. No case repeats another's characteristic.
- Seven `<?>` and seven questions: the story gives no answer for them, so the report does not either.
- Nothing in the Expected result column comes from a UI or from code.
