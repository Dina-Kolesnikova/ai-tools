# Worked example: Member cancels a gym membership (story readiness)

Same invented story as `test-case-design/examples/membership-cancellation.md`, but as it looked
**before** refinement: no acceptance criteria yet. The report proposes them. Note the verdict: it
is **Not ready** because four questions are blocking, not because AC are missing — missing AC
alone would have given "Ready after answers".

---

## Input (as pasted by the user)

```
Check this story.

GM-207 — Member cancels a membership online

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

Out of scope: freezing a membership; cancellation by front-desk staff.
```

---

## Report

# Story readiness: GM-207 — Member cancels a membership online

**Verdict:** Not ready
Four blocking questions (the 30-day boundary, the billing-date anchor time, fee above prepaid,
what "one monthly fee" means). No AC yet; proposed below. With the four answers the story is Ready.

## 1. Inventory
**Goal:** As a gym member I want to cancel my monthly membership online so that I stop paying
without visiting the front desk — complete (role, action, benefit).

| ID | Requirement (quoted) | Covered by AC |
|---|---|---|
| R1 | "cancel a membership from the membership page while the membership is Active" | ❌ none — proposed Rule 1 |
| R2 | "free when requested at least 30 days before the next billing date (club local time). Later requests are charged one final monthly fee" | ❌ none — proposed Rule 2 |
| R3 | "Refund = prepaid amount − final fee, returned to the original payment method. The refund should be processed quickly" | ❌ none — proposed Rule 3 |
| R4 | "status is Cancelled and a confirmation e-mail is sent" | ❌ none — proposed Rule 1 |
| R5 | "cannot be cancelled twice, and not after it has already ended" | ❌ none — proposed Rule 4 |
| R6 | "Only the logged-in member who owns the membership can cancel it" | ❌ none — proposed Rule 5 |

Existing AC without a requirement: none (no AC in the story).

## 2. Gaps and contradictions
- ⚠️ **Vague** R3: "quickly" — not measurable (Q3)
- ⚠️ **Ambiguous** R2: "at least 30 days before" — inclusive or not; unit not stated (Q1)
- ❌ **Missing** R2: the time of day that anchors the billing date (Q2)
- ❌ **Missing** R3: final fee greater than the prepaid amount — refund negative, zero, or fee capped? (Q4)
- ⚠️ **Ambiguous** R2: "one monthly fee" — current plan price or list price; taxes in or out? (Q7)
- ❌ **Missing** R3: behaviour when the refund to the payment provider fails (Q5)
- ❌ **Missing** R5, R6: what the member sees on a forbidden attempt (Q6)
- ⚠️ **Singular** R5: two rules in one sentence (double cancel; after end) — split into Rule 4a / 4b
- No contradictions found. Story template: no designs linked, no dependencies listed (payment provider, e-mail service).

## 3. Proposed acceptance criteria
### Rule 1: An Active membership can be cancelled from its page; it becomes Cancelled and the member gets an e-mail  (R1, R4)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 1.1 | Happy | an Active membership, next billing in 45 days | the member cancels from the membership page and confirms | status is Cancelled; a confirmation e-mail is sent | [story] |
| 1.2 | Negative | the member opens the cancel dialog | the member closes it without confirming | status stays Active; no e-mail | [proposed] |
| 1.3 | Concurrency | an Active membership | the member clicks Cancel / Confirm twice quickly | exactly one cancellation and one e-mail | [proposed] |

### Rule 2: Cancellation is free at least 30 days before the next billing date (club local time); later, one final monthly fee is charged  (R2)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 2.1 | Happy | next billing in 45 days | the member cancels | fee = 0 | [story] |
| 2.2 | Happy | next billing in 10 days | the member cancels | fee = one monthly fee `<?>` (which price? Q7) | [story] |
| 2.3 | Boundary | exactly 30 days before the billing date, club local time | the member cancels | fee = `<?>` (Q1) | [proposed] |
| 2.4 | Boundary | 30 days − 1 `<?>` unit before the billing date | the member cancels | fee = one monthly fee | [proposed] |
| 2.5 | Data | club in a time zone different from the member's | the member cancels 29 days before billing in club time (30 days in the member's time) | fee = one monthly fee (club time rules) | [story] |

### Rule 3: Refund = prepaid amount − fee, to the original payment method  (R3)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 3.1 | Happy | fee = 0 | cancellation completes | refund = prepaid amount to the original payment method | [story] |
| 3.2 | Happy | fee = one monthly fee | cancellation completes | refund = prepaid amount − one monthly fee | [story] |
| 3.3 | Boundary | monthly fee ≥ prepaid amount (discounted first month) | cancellation completes | refund = `<?>` (Q4) | [proposed] |
| 3.4 | Integration | the payment provider does not answer | cancellation is requested | `<?>` (Q5) | [proposed] |
| 3.5 | Non-functional | refund requested | — | refund is requested within `<?>` (Q3: "quickly") | [proposed] |

### Rule 4a: A Cancelled membership cannot be cancelled again · Rule 4b: an ended membership cannot be cancelled  (R5)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 4.1 | State | a Cancelled membership | the member tries to cancel again (UI or direct request) | rejected; no second refund; message `<?>` (Q6) | [story] |
| 4.2 | State | a membership that ended yesterday | the member tries to cancel | rejected; message `<?>` (Q6) | [story] |
| 4.3 | Boundary | a membership ending today at 23:59 club time, now 23:30 | the member cancels | `<?>` — allowed? (Q1 unit) | [proposed] |

### Rule 5: Only the logged-in member who owns the membership can cancel it  (R6)
| # | Category | Given | When | Then | Source |
|---|---|---|---|---|---|
| 5.1 | Happy | member A logged in, A's membership | A cancels | allowed | [story] |
| 5.2 | Roles | member B logged in, A's membership (page URL or direct request) | B tries to cancel | rejected; status unchanged; response `<?>` (Q6) | [story] |
| 5.3 | Roles | not logged in | tries to cancel A's membership | rejected; status unchanged | [story] |

## 4. Open questions for PO
| # | Question | Linked to | Priority | Suggested default |
|---|---|---|---|---|
| Q1 | Is exactly 30 days before the billing date free or charged? In what unit do we count? | R2 | Blocking | ≥ 30 days free, whole days, club time |
| Q2 | What time of day anchors the billing date: 00:00 club time or the hour of purchase? | R2 | Blocking | 00:00 club time |
| Q4 | If the final fee is greater than the prepaid amount, is the refund 0 and nothing extra is charged? | R3 | Blocking | fee capped at the prepaid amount |
| Q7 | "One monthly fee": current plan price or list price? Taxes included? | R2 | Blocking | current plan price, taxes included |
| Q3 | "Processed quickly": a target in hours or days? | R3 | Non-blocking | requested within 1 h; UI says "5–10 business days" |
| Q5 | If the refund call fails: cancel with refund pending, or stay Active? | R3 | Non-blocking | cancel, mark refund pending, retry |
| Q6 | What does the member see on a forbidden attempt? | R5, R6 | Non-blocking | "This membership cannot be cancelled"; direct requests get a 4xx |

## 5. Definition of Ready
| Item | Status | Note |
|---|---|---|
| (M) Goal is clear | ✅ | role, action, benefit present |
| Every requirement has AC | ❌ | none in the story; proposed above, PO to confirm |
| (M) No contradictions | ✅ | |
| (M) No blocking questions open | ❌ | Q1, Q2, Q4, Q7 |
| Negative and boundary cases covered | ⚠️ | proposed, not agreed |
| Business values explicit | ❌ | 30 days inclusive?, fee definition, rounding, messages |
| Scope is clear | ✅ | out of scope stated |
| Dependencies known | ⚠️ | payment provider and e-mail service not listed |
| Designs attached | ❌ | none linked; the story changes a UI page |
| Small enough | ✅ | 5 rules, one flow |
| Testable on an environment | ⚠️ | needs a payment sandbox that can fail on demand |

## 6. Size
OK — five rules around one action. Split only if the refund-failure handling (Q5) turns into its
own flow (retries, support alerts); then it is a second story.
