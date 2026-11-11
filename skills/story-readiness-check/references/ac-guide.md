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

## Requirement quality (ISO/IEC/IEEE 29148 characteristics)
Check every requirement, not only the AC:
| Characteristic | Question | Smell |
|---|---|---|
| Necessary | Does it serve the story goal? | requirement unrelated to the goal |
| Unambiguous | Can it be read only one way? | vague words (below) |
| Complete | Is anything left for the reader to guess? | "etc.", "TBD", missing error behaviour |
| Singular | Does it state exactly one thing? | "and", "or", "but", "/" joining two rules |
| Feasible | Can it be built and tested at all? | "always", "never", "100%", "all browsers" |
| Verifiable | Can someone say pass / fail? | subjective adjectives |
| Correct / consistent | Does it agree with other requirements and designs? | contradiction |
| Traceable | Does it link to a goal and to AC? | orphan requirement or AC |

## Vague words to flag (requirements smells)
- Subjective: fast, quickly, easy, simple, user-friendly, intuitive, nice, modern, clean
- Ambiguous adverbs / adjectives: appropriate, correct, properly, normally, sufficient, relevant, reasonable
- Non-verifiable: support, handle, manage, process, as expected, similar to, work correctly
- Loopholes: if possible, if needed, as appropriate, where applicable, optionally
- Open-ended: etc., and so on, including but not limited to, TBD
- Comparatives without a baseline: better, faster, more, improved
- Hidden actor (passive voice): "the booking is validated" — by whom, when?
- Undefined terms: "valid", "active user", "standard rate" without a definition

## Bad → good
| Bad | Why | Good |
|---|---|---|
| The page loads fast | not measurable | Search results appear within 2 s for 95% of requests |
| Show an error for invalid email | which error, where? | Given email "abc", When I submit, Then I see "Enter a valid email" under the field and the form is not sent |
| Add `cancelled_at` column | implementation | When a booking is cancelled, Then the cancellation date is shown in booking details |
| Cancellation works correctly | untestable | (split into rules with examples) |
