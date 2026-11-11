# Acceptance Criteria Guide

## Terms
- **Requirement** — WHAT the system must do and WHY. Business language. Not directly testable.
- **Acceptance criterion (AC)** — a condition that must be true for the story to be accepted. Pass / fail.
- **Use case** — the full interaction story (actor, main flow, alternative flows). Bigger than AC.
- **Test case** — HOW to verify one AC: steps, data, expected result. Written after the story is ready.

One requirement → several AC → each AC → several test cases.

## Two formats (use both)
**Rule-based** — one sentence, good for simple rules:
> Free cancellation is allowed until 48 hours before check-in.

**Scenario-based (Given / When / Then)** — concrete example under a rule:
> Given a confirmed booking with check-in in 72 hours
> When the guest cancels it
> Then the booking status is "cancelled" and the guest is refunded 100%

Given = starting state (Arrange). When = one action (Act). Then = observable result (Assert).
One When per example. Then must be observable by a user or an API client.

## Categories to cover
| Category | Ask | Example |
|---|---|---|
| Happy path | Does the main flow work? | Cancel 72 h before → 100% refund |
| Negative | What happens on invalid input or a failed action? | Cancel with invalid booking ID → error, nothing changes |
| Boundary | What happens exactly at the limit, just before and just after? | 48 h exactly, 47 h 59 min, 48 h 1 min |
| State | What if the object is already in another state? | Cancel an already cancelled / past / unpaid booking |
| Roles / permissions | Who may do it? Who may not? | Guest cancels someone else's booking → forbidden |
| Data | Empty, max length, special characters, formats, time zones, currency | Check-in time in hotel time zone vs guest time zone |
| Integration | What if a dependency fails or is slow? | Payment provider timeout during refund |
| Concurrency | Two actions at the same time? | Two users book the last room |
| Non-functional | Messages, e-mails, logs, audit, performance, accessibility | Cancellation e-mail is sent; refund shown in the UI |

## Good AC checklist
- Testable: someone can say pass or fail without arguing.
- Unambiguous: no vague words.
- Behaviour, not implementation.
- Independent: each AC can be checked on its own.
- Includes at least one negative example per rule where failure is possible.

## Requirement quality, vague words, bad → good
Shared with `test-case-design`: see `../../_shared/requirement-smells.md` (ISO 29148
characteristics, the vague-words list, the yes/no requirement checklist, defect types, bad → good).
Both skills must flag the same smells, so the list lives in one place.
