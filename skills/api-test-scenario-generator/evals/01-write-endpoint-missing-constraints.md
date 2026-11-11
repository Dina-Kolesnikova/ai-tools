# Eval 01 — write endpoint with missing constraints

## Input
```
API test scenarios for this endpoint.

POST /projects/{projectId}/tasks   (bearer token; roles: owner, editor, viewer)
Body: { "title": string (required), "description": string, "dueDate": date, "assigneeId": uuid }
Responses: 201 with the created task { id, title, description, dueDate, assigneeId, status: "Open" }
           400 validation error { error: { field, message } }
           401 no or invalid token
Rules: viewers cannot create tasks; dueDate cannot be in the past; the assignee must be a member
of the project.
```
Intake answers: this text is the whole spec; tokens for owner, editor, viewer of project P and for
a user outside P; no existing collection; light.

## Must
- [ ] `title` and `description` have max-length rows whose limit is `<?>` with a question — no
      number is invented.
- [ ] `dueDate` has rows for yesterday, today and tomorrow (boundary of "in the past") with a question
      about the time zone and whether "today" counts as past.
- [ ] A viewer creating a task is a row with status `<?>` or a `[proposed]` 403 and a question
      (the spec lists no 403).
- [ ] A user outside project P calling the endpoint is a separate row (object-level authorisation),
      with status `<?>` / `[proposed]` and a question (403 vs 404).
- [ ] `assigneeId` of a user outside the project is a row; `assigneeId` unknown uuid is another row.
- [ ] Every negative row names the check that nothing was created (GET list / count).

## Must not
- [ ] No row tags a 403, 404, 409 or 422 as `[spec]`.
- [ ] No row combines two invalid values in one request.
- [ ] No row's expected result comes from "what the service returns today".
