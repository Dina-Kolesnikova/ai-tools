# API scenario checklist: nine groups, technique per group

> Techniques and section numbers are those of `test-case-design/references/` (CTFL v4.0.1,
> CTAL-TA v4.0, verified 2026-11-10). The nine groups themselves are a practical structure for
> REST endpoints, not a syllabus list.

## 1. The nine groups (walk them in this order)

| # | Group | What the rows check | Technique (ISTQB ref) | Typical rows |
|---|---|---|---|---|
| A | **Contract and happy path** | a minimal valid request and a full valid request succeed; response status, body shape, field types, required fields, content-type all match the spec | AC-based, positive first (CTFL §4.5.3); schema check as the oracle | 2–3 per endpoint |
| B | **Per-field validation** | for every parameter: required missing, null, empty string, wrong type, below / at / above min and max (length, value, array size), enum value not in the list, format (e-mail, ISO date, UUID), leading / trailing spaces, unicode, very long value, unknown extra field | EP for the classes, BVA 2-value (3-value for money, dates, permission limits) (CTFL §4.2.1–4.2.2) | 3–8 per field; one request per invalid class |
| C | **Auth and permissions** | no token, expired token, malformed token, valid token with the wrong role or scope, valid user acting on another user's resource (object-level authorisation), valid | EP on the actor; each invalid alone (CTFL §4.2.1) | 4–6 per endpoint |
| D | **Resource state** | resource not found, resource in a terminal state (already cancelled, deleted), state that forbids the action, dependency missing (parent not found) | State transition: invalid transitions attempted alone (CTFL §4.2.4) | 1 per forbidden state |
| E | **Business rules** | the rules of the story on this endpoint: combinations of conditions, thresholds, calculations returned in the body | Decision table for combinations (CTFL §4.2.3), BVA / domain on thresholds, worked example for a calculation (`test-case-design` calculation row) | 1 per decision-table column; 3 per threshold |
| F | **Idempotency, concurrency, repetition** | the same request sent twice; the same idempotency key with a different body; two parallel requests on one resource; retry after a timeout | Error guessing, repetition group (CTFL §4.4.1); HTTP semantics (section 3) | 2–4 per state-changing endpoint |
| G | **Lists, pagination, filtering** | page 0 / 1 / last / beyond last; page size min, max, max + 1, missing (default `<?>`); sort by each allowed field and an unknown one; each filter alone; filter combinations pairwise when there are three or more, with the pairwise rows listed explicitly (or the tool, e.g. PICT, and its output) and a note that all combinations were not run; empty result; total count matches | BVA on page and size; EP on sort / filter values; pairwise for filter combinations (CTAL-TA §3.1.2) | 8–15 per list endpoint |
| H | **Side effects** | after a successful write: GET shows the change; e-mail / event / audit record exists if specified; after every failed request: nothing changed (GET, count) | CRUD consistency: after each U, every R (CTAL-TA §3.2.1) | 1 per write row (can be a check column) |
| I | **Robustness** | malformed JSON, wrong content-type, empty body on POST, oversized payload, unsupported method on the path, unsupported media type, duplicated query parameter | Error guessing, input group (CTFL §4.4.1) | 4–6 per endpoint |

Group H is usually a **check inside other rows** (the "Side effect / state check" column), not
separate rows; make it a row only when the side effect is the thing under test (e-mail content,
event payload).

## 2. Spec defects to look for (Step 2)

- A constraint without a number: "short description", "reasonable size", "valid e-mail".
- A field whose type differs between request and response, or between two endpoints.
- No statement on unknown extra fields (ignored? rejected?).
- No error body format, or error codes listed without saying when each one is returned.
- No auth statement, or roles named but not mapped to endpoints.
- No behaviour for a repeated request (second POST, second DELETE).
- A list endpoint with no default page size, no maximum, or no stated sort order.
- A status code used for two different meanings.
- Dates without time zone or format; money without currency or precision.

Defect types and wording: `../../_shared/requirement-smells.md` section 4.

## 3. HTTP method semantics (what "repeat" should do)

| Method | Safe | Idempotent | Second identical request should … |
|---|---|---|---|
| GET | yes | yes | return the same result, change nothing |
| PUT | no | yes | leave the resource in the same state as after the first |
| DELETE | no | yes | leave the resource deleted; response `<?>` (spec: 204 again? 404?) |
| POST | no | no | `<?>` — the spec decides: duplicate created, rejected (409), or deduplicated by an idempotency key |
| PATCH | no | not by definition | `<?>` — depends on the operation; test it |

Every `<?>` in this table is a question for the spec owner, not a default.

## 4. Typical status codes — offer only as `[proposed]`

When the spec is silent, a row may offer the usual code **tagged `[proposed]`** and a question:
400 validation / malformed, 401 missing or invalid token, 403 authenticated but not allowed,
404 not found (also used by some APIs instead of 403 to hide existence — ask), 405 method not
allowed, 409 state conflict or duplicate, 413 payload too large, 415 unsupported media type,
422 semantically invalid (some APIs use 400 for this — ask), 429 rate limited.

## 5. When there is no spec: what to capture first

Ask the user for, in this order, and stop as soon as you have enough for a baseline:
1. One successful call: full request (method, URL, headers minus secrets, body) and full response
   (status, headers, body). This is the baseline, tagged `[observed]`.
2. One failed call if they have one (any 4xx) — it shows the error body format.
3. The roles / tokens they can get, and one id that belongs to a different user.
4. Where the data lands (a GET endpoint, a UI page, a table) so side effects can be checked.
Then produce the table with `run to learn` rows; the user runs them and reports back. Treat every
response as a fact about today's build, not as the requirement: the questions table asks the
developer to confirm each one.

## 6. Baseline request

Define one **baseline**: the minimal valid request that returns the happy-path response, with
every value coming from the spec or marked `<?>`. Each scenario row states only its **delta**
("body.reason = 201 characters", "no Authorization header", "path id = other user's membership").
This keeps the table short and maps one-to-one onto Postman requests built from one saved example.
