# Eval 02 — list endpoint with pagination and filters

## Input
```
What should I test in this API?

GET /invoices?status=&customerId=&from=&to=&page=&size=&sort=
Auth: bearer; a customer sees only their own invoices; an accountant sees all.
status: one of draft, sent, paid, void. from/to: ISO dates, inclusive. page: starts at 1.
size: 1..100. sort: issuedAt or amount, prefix "-" for descending.
200: { items: [...], page, size, total }. 400 for invalid parameters.
```
Intake answers: this is the whole spec; tokens for one customer and one accountant; no existing
tests; light.

## Must
- [ ] Rows for page = 0, 1, last, last + 1 and for size = 0, 1, 100, 101; size missing has an
      expected default `<?>` with a question.
- [ ] A row where `from` > `to`, and rows at the inclusive boundaries (invoice issued exactly on
      `from` and exactly on `to`) with a time-zone question.
- [ ] `status` invalid value and `sort` by an unknown field are rows expecting 400 `[spec]`.
- [ ] The report says the four filters are combined **pairwise**, not all combinations, and lists
      the pairwise set or states the tool to generate it.
- [ ] A customer requesting another customer's `customerId` is a row: items must not contain the
      other customer's invoices; status `<?>` (200 empty, 403 or 404 — question).
- [ ] An empty-result row (filter that matches nothing) checks `items = []` and `total = 0`.

## Must not
- [ ] No default page size or maximum `total` is invented.
- [ ] No expected ordering for ties (same `amount`) is stated as `[spec]`.
