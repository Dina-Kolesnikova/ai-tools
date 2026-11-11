# Worked example: Guest cancels a hotel booking (story readiness)

Same story as `test-case-design/examples/booking-cancellation.md`, but as it looked **before**
refinement: no acceptance criteria yet. The report proposes them. Note the verdict: it is
**Not ready** because four questions are blocking, not because AC are missing — missing AC alone
would have given "Ready after answers".

---

## Input (as pasted by the user)

```
Check this story.

HB-412 — Guest cancels a booking online

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

Out of scope: cancelling one room of a multi-room booking; cancellation by an agent.
```

---

## Report

# Story readiness: HB-412 — Guest cancels a booking online

**Verdict:** Not ready
Four blocking questions (the 48 h boundary, the check-in anchor time, fee above total, what "first
night price" includes). No AC yet; proposed below. With the four answers the story is Ready.

## 1. Inventory
**Goal:** As a guest I want to cancel my confirmed hotel booking online so that I get my refund
without calling support — complete (role, action, benefit).

| ID | Requirement (quoted) | Covered by AC |
|---|---|---|
| R1 | "cancel a booking from the booking details page while the booking is Confirmed" | ❌ none — proposed Rule 1 |
| R2 | "Free cancellation … until 48 hours before check-in (hotel local time). After that, the cancellation fee is the price of the first night" | ❌ none — proposed Rule 2 |
| R3 | "Refund = total paid − cancellation fee, returned to the original payment method. The refund should be processed quickly" | ❌ none — proposed Rule 3 |
| R4 | "status is Cancelled and a confirmation e-mail is sent" | ❌ none — proposed Rule 1 |
| R5 | "cannot be cancelled twice, and not after check-in has started" | ❌ none — proposed Rule 4 |
| R6 | "Only the logged-in guest who made the booking can cancel it" | ❌ none — proposed Rule 5 |

Existing AC without a requirement: none (no AC in the story).

## 2. Gaps and contradictions
- ⚠️ **Vague** R3: "quickly" — not measurable (Q3)
- ⚠️ **Ambiguous** R2: "until 48 hours before" — inclusive or not; unit not stated (Q1)
- ❌ **Missing** R2: the check-in time that anchors the 48 h (Q2)
- ❌ **Missing** R3: fee greater than total paid — refund negative, zero, or fee capped? (Q4)
- ⚠️ **Ambiguous** R2: "price of the first night" — taxes and discounts in or out? (Q7)
- ❌ **Missing** R3: behaviour when the refund to the payment provider fails (Q5)
- ❌ **Missing** R5, R6: what the guest sees on a forbidden attempt (Q6)
- ⚠️ **Singular** R5: two rules in one sentence (double cancel; after check-in) — split into Rule 4a / 4b
- No contradictions found. Story template: no designs linked, no dependencies listed (payment provider, e-mail service).

## 3. Proposed acceptance criteria
### Rule 1: A Confirmed booking can be cancelled from its details page; it becomes Cancelled and the guest gets an e-mail  (R1, R4)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 1.1 | Happy | a Confirmed booking, check-in in 72 h | the guest cancels from booking details and confirms | status is Cancelled; a confirmation e-mail is sent | [story] |
| 1.2 | Negative | the guest opens the cancel dialog | the guest closes it without confirming | status stays Confirmed; no e-mail | [proposed] |
| 1.3 | Concurrency | a Confirmed booking | the guest clicks Cancel / Confirm twice quickly | exactly one cancellation and one e-mail | [proposed] |

### Rule 2: Cancellation is free until 48 h before check-in (hotel local time); later, the fee is the first night's price  (R2)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 2.1 | Happy | check-in in 72 h | the guest cancels | fee = 0 | [story] |
| 2.2 | Happy | check-in in 24 h | the guest cancels | fee = price of the first night `<?>` (taxes? Q7) | [story] |
| 2.3 | Boundary | exactly 48 h before check-in, hotel local time | the guest cancels | fee = `<?>` (Q1) | [proposed] |
| 2.4 | Boundary | 48 h − 1 `<?>` unit before check-in | the guest cancels | fee = first night | [proposed] |
| 2.5 | Data | hotel in a time zone different from the guest's | the guest cancels 47 h before check-in in hotel time (49 h in guest time) | fee = first night (hotel time rules) | [story] |

### Rule 3: Refund = total paid − fee, to the original payment method  (R3)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 3.1 | Happy | fee = 0 | cancellation completes | refund = total paid to the original payment method | [story] |
| 3.2 | Happy | fee = first night | cancellation completes | refund = total paid − first night | [story] |
| 3.3 | Boundary | first-night price ≥ total paid (discounted booking) | cancellation completes | refund = `<?>` (Q4) | [proposed] |
| 3.4 | Integration | the payment provider does not answer | cancellation is requested | `<?>` (Q5) | [proposed] |
| 3.5 | Non-functional | refund requested | — | refund is requested within `<?>` (Q3: "quickly") | [proposed] |

### Rule 4a: A Cancelled booking cannot be cancelled again · Rule 4b: a booking cannot be cancelled once check-in has started  (R5)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 4.1 | State | a Cancelled booking | the guest tries to cancel again (UI or direct request) | rejected; no second refund; message `<?>` (Q6) | [story] |
| 4.2 | State | check-in today at the hotel's check-in hour, now one hour later | the guest tries to cancel | rejected; message `<?>` (Q6) | [story] |
| 4.3 | State | a booking with check-out in the past | the guest tries to cancel | rejected | [story] |

### Rule 5: Only the logged-in guest who made the booking can cancel it  (R6)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 5.1 | Happy | guest A logged in, A's booking | A cancels | allowed | [story] |
| 5.2 | Roles | guest B logged in, A's booking (details URL or direct request) | B tries to cancel | rejected; status unchanged; response `<?>` (Q6) | [story] |
| 5.3 | Roles | not logged in | tries to cancel A's booking | rejected; status unchanged | [story] |

## 4. Open questions for PO
| # | Question | Linked to | Priority | Suggested default |
|---|---|---|---|---|
| Q1 | Is exactly 48 h before check-in free or charged? In what unit do we count (minutes)? | R2 | Blocking | ≥ 48 h free, counted in minutes |
| Q2 | Which check-in time anchors the 48 h: the hotel's check-in hour or 00:00 of the check-in date? | R2 | Blocking | hotel check-in hour |
| Q4 | If the fee is greater than the total paid, is the refund 0 and nothing extra is charged? | R3 | Blocking | fee capped at total paid |
| Q7 | "Price of the first night": including taxes? after discounts? | R2 | Blocking | first night as on the invoice, taxes included |
| Q3 | "Processed quickly": a target in hours or days? | R3 | Non-blocking | requested within 1 h; UI says "5–10 business days" |
| Q5 | If the refund call fails: cancel with refund pending, or stay Confirmed? | R3 | Non-blocking | cancel, mark refund pending, retry |
| Q6 | What does the guest see on a forbidden attempt? | R5, R6 | Non-blocking | "This booking cannot be cancelled"; direct requests get a 4xx |

## 5. Definition of Ready
| Item | Status | Note |
|---|---|---|
| (M) Goal is clear | ✅ | role, action, benefit present |
| Every requirement has AC | ❌ | none in the story; proposed above, PO to confirm |
| (M) No contradictions | ✅ | |
| (M) No blocking questions open | ❌ | Q1, Q2, Q4, Q7 |
| Negative and boundary cases covered | ⚠️ | proposed, not agreed |
| Business values explicit | ❌ | 48 h inclusive?, first-night definition, rounding, messages |
| Scope is clear | ✅ | out of scope stated |
| Dependencies known | ⚠️ | payment provider and e-mail service not listed |
| Designs attached | ❌ | none linked; the story changes a UI page |
| Small enough | ✅ | 5 rules, one flow |
| Testable on an environment | ⚠️ | needs a payment sandbox that can fail on demand |

## 6. Size
OK — five rules around one action. Split only if the refund-failure handling (Q5) turns into its
own flow (retries, support alerts); then it is a second story.
