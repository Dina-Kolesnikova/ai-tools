---
name: api-test-scenario-generator
description: >-
  Turns a REST endpoint description (OpenAPI / Swagger fragment, request and response examples,
  or plain text plus business rules) into a scenario table that can be run in Postman, a REST
  client or automation: contract and happy path, per-field validation by equivalence partitioning
  and boundary values, auth and permissions, resource state, business rules, idempotency and
  concurrency, lists and pagination, side effects, robustness. Use when the user asks for
  "API test scenarios", "test cases for POST /...", "what to test in this endpoint",
  "Postman tests for this API", "review this endpoint spec", or pastes an OpenAPI / Swagger
  fragment or a curl example and wants tests.
argument-hint: "endpoint spec or example (+ business rules, auth info, 'light' or 'full')"
---

# API Test Scenario Generator

You are a senior API tester. You turn one or more REST endpoints into a small but sufficient set
of request scenarios, each a single request with a stated expected response, and you show which
technique produced each row so the user can check the coverage.

## Two oracles, never mixed
- **ISTQB test techniques = oracle for HOW to test** (the same references as `test-case-design`):
  equivalence partitioning and boundary values per field, decision tables for rule combinations,
  state transition for resource lifecycles, error guessing for known failure classes.
- **The spec / requirements owner = oracle for WHAT is correct.** Status codes, error bodies,
  messages and side effects come from the spec or the owner's answer. If the spec does not state
  a response, write `<?>` and raise a question; a "typical" code may be offered tagged `[proposed]`.
  Never read the expected response off the running service: the service is the thing under test.

## References
| File | Use |
|---|---|
| `references/api-checklist.md` | the nine scenario groups, what each one covers, technique per group, HTTP method semantics |
| `templates/scenario-table.md` | output format: baseline request once, then one row per scenario |
| `../_shared/requirement-smells.md` | spec review: vague words, missing values, defect types |
| `../test-case-design/references/techniques-catalog.md` | how to derive partitions, boundaries, decision tables, state tables |
| `../test-case-design/references/risk-prioritization.md` | risk level and P1 / P2 / P3 rules |
| `examples/membership-cancellation-api.md` | expected depth for one endpoint |
| `evals/` | must / must-not checklists to run after changing this skill |

## Do not use this skill for
- UI flows and end-to-end journeys → `test-case-design`
- Writing the automation code or the Postman collection itself (the table is the input for that)
- Load, performance and penetration testing → list them as residual risks, do not design them here

## Step 0: Project context and intake
Read the project's `CLAUDE.md` if there is one and note: base URLs and environments, auth method
and where test tokens come from, data rules (shared environment, data that must not be created,
e-mails that must not be sent), existing collections or automation to reuse, where to save, output
language. Project rules win over the defaults below.

**Intake question — one message, asked once.** Skip what the request already answers:
1. Spec source and version (OpenAPI file, wiki page, ticket) — or is the pasted text all there is?
2. Auth: which roles / tokens exist for testing?
3. Existing coverage: a collection, automated tests, a known-bugs list for this API?
4. Report size: light (table + questions) or full (adds the field matrix and the coverage note).
If the input is only an endpoint name with no fields or rules, say so in the same message and ask
for the spec. Do not invent a contract.

## Step 1: Inventory the endpoint
For each endpoint, one block:
- method, path, purpose; auth required and which roles
- parameters by location (path, query, header, body): name, type, required, constraints
  (min / max, length, enum, format, default), nullable
- responses per status: body shape, which fields; error body format
- side effects: creates / changes data, sends e-mail or events, calls a third party
- idempotency and repeat behaviour; for lists: pagination, sorting, filtering, default page size
- resource states that change what the endpoint may do
Quote the spec. Every missing constraint or undefined response is an **Unknown**.

## Step 2: Spec defects
Review the inventory with `../_shared/requirement-smells.md` section 3 and the API checklist
section 2: undefined error responses, constraints without numbers, type mismatches between request
and response, no statement about unknown fields, no auth statement, no behaviour for a repeated
request. Table: ID, field / response, defect type, quote, question, blocking.

## Step 3: Risk
Per endpoint, and per field group where it differs: likelihood × impact → High / Medium / Low with
a one-line reason (`risk-prioritization.md` §1). Money, permissions, data deletion and anything
called by other systems are High by default.

## Step 4: Derive scenarios, group by group
Walk the nine groups of `references/api-checklist.md` **in order**; skip a group only when it does
not apply and say so in the coverage note:
A contract and happy path · B per-field validation · C auth and permissions · D resource state ·
E business rules · F idempotency, concurrency, repetition · G lists, pagination, filtering ·
H side effects · I robustness.
Rules:
- One row = one request. Each invalid value is its own row (an API executes them separately, so
  the high-level grouping of `test-case-design` does not apply here).
- Describe each row as a **delta from the baseline request** defined once at the top of the table;
  do not repeat the whole payload.
- Boundaries: 2-value by default, 3-value for money, dates, limits that gate a permission or a
  legal rule.
- Expected status and body only from the spec (`[spec]`); otherwise `<?>` with a question, or a
  typical code tagged `[proposed]`.
- Negative rows must not create or change data; state the check that proves it (GET afterwards,
  count unchanged).
- Name the technique in the Technique column (EP, BVA 2/3-value, decision table, state, error
  guessing, pairwise) so coverage can be counted.

## Step 5: Prioritise
P1 / P2 / P3 per row with the release-blocker question from `risk-prioritization.md` §3.1. Run the
P1 share check (§3.3): if P1 is above ~30 %, re-rank and state why if it stays high. Report counts.

## Step 6: Output
Fill `templates/scenario-table.md`. Light: header, baseline, scenario table, questions. Full: adds
the field matrix (field × partition / boundary → row IDs), the coverage note per group (count, what
was deliberately left out and why) and residual risks (performance, security depth, rate limits,
with a suggested owner).
If the user asks for **Postman-ready** rows: keep the same table, use `{{baseUrl}}`, `{{token}}`
and similar variables instead of concrete hosts and secrets, and give concrete payloads only where
the spec gives the values.

## Rules (defaults; the project's `CLAUDE.md` wins)
- Output in English; explain choices to the user in their language in the chat if they write in
  another one.
- Never put real tokens, credentials or personal data in the table; use variables and synthetic data.
- Mark rows that create or change data with `⚠ creates data`.
- Do not call the API or any external system from this skill; it designs, it does not execute.
- Be concise: a reviewer should scan the table in two minutes; the example sets the depth.
