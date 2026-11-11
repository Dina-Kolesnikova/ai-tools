# Requirement smells (shared by `story-readiness-check` and `test-case-design`)

One list, used by both skills, so a story gets the same verdict whichever skill reads it.
`story-readiness-check` uses it in Step 3 (requirement quality). `test-case-design` uses it in
Step 2 (test basis defects). Quote the word or sentence you flag; never paraphrase a smell.

## 1. Requirement quality (ISO/IEC/IEEE 29148 characteristics)

Check every requirement, not only the AC:

| Characteristic | Question | Smell |
|---|---|---|
| Necessary | Does it serve the story goal? | requirement unrelated to the goal |
| Unambiguous | Can it be read only one way? | vague words (section 2) |
| Complete | Is anything left for the reader to guess? | "etc.", "TBD", missing error behaviour |
| Singular | Does it state exactly one thing? | "and", "or", "but", "/" joining two rules |
| Feasible | Can it be built and tested at all? | "always", "never", "100%", "all browsers" |
| Verifiable | Can someone say pass / fail? | subjective adjectives |
| Correct / consistent | Does it agree with other requirements and designs? | contradiction |
| Traceable | Does it link to a goal and to AC? | orphan requirement or AC |

## 2. Vague words to flag

- Subjective: fast, quickly, easy, simple, user-friendly, intuitive, nice, modern, clean
- Ambiguous adverbs / adjectives: appropriate, correct, properly, normally, sufficient, relevant, reasonable
- Non-verifiable: support, handle, manage, process, as expected, similar to, work correctly
- Loopholes: if possible, if needed, as appropriate, where applicable, optionally, should
- Open-ended: etc., and so on, including but not limited to, TBD
- Comparatives without a baseline: better, faster, more, improved
- Hidden actor (passive voice): "the booking is validated" — by whom, when?
- Undefined terms: "valid", "active user", "standard rate" without a definition
- "and/or" — two rules in one sentence; which one applies?

## 3. Short requirement checklist (answer yes / no / N/A per requirement)

- Is every expected result stated, including for invalid input and forbidden actions?
- Are all values defined (limits, units, precision, time zone, rounding, currency)?
- Is every role's permission stated (who can see / create / edit / delete)?
- For each status: which events are allowed, which are forbidden, and what happens on a forbidden attempt?
- Are combinations of conditions covered, and do any two rules conflict?
- Is the behaviour across all clients (web, mobile, API, e-mail / notifications) specified and consistent?
- Is what happens to related data on edit / delete specified?
- Are calculations given as a formula with a worked example (inputs → result, rounding rule)?
- For dates and cut-offs: is the reference time zone and the unit (day / hour / minute) named?
- Are vague words present (section 2)?
- Is anything explicitly out of scope?

## 4. Defect types (use these words in the defects table)

missing · ambiguous · inconsistent / contradictory · incorrect · infeasible · untestable · redundant · unnecessary

## 5. Bad → good

| Bad | Why | Good |
|---|---|---|
| The page loads fast | not measurable | Search results appear within 2 s for 95% of requests |
| Show an error for invalid email | which error, where? | Given email "abc", When I submit, Then I see "Enter a valid email" under the field and the form is not sent |
| Add `cancelled_at` column | implementation | When a booking is cancelled, Then the cancellation date is shown in booking details |
| Cancellation works correctly | untestable | (split into rules with examples) |
| Refund the guest the right amount | formula missing | Refund = total paid − cancellation fee; fee = `<?>` % of the first night, rounded to 0.01 `<?>` |
