# Evals for `api-test-scenario-generator`

Manual evals: paste the **Input** of one eval file into a fresh Claude Code session with the skill
installed, answer the intake question as the file says, then tick every line under **Must** and
**Must not**. One unticked line = the eval fails; fix the skill text, not the answer.

**Run from an empty folder outside this repo** (or use `scripts/run-eval.sh` at the repo root).
On the first run of these evals the session was started inside the repo, this skill listed the
folder and read the eval file, and the report said so. After a run, check the transcript for any
tool call that touched `evals/` and discard the run if there is one.

| File | Checks |
|---|---|
| `01-write-endpoint-missing-constraints.md` | no invented limits or status codes; object-level auth row; one request per row |
| `02-list-endpoint-pagination.md` | pagination and filter boundaries; pairwise named for 3+ filters; no invented default page size |
| `03-no-spec-endpoint-only.md` | no documentation: contract reconstructed from one captured call, everything `[observed]` or `<?>`, `run to learn` rows, dev confirmation questions |

`../examples/membership-cancellation-api.md` is the depth reference: about 20–25 rows for one
write endpoint with business rules, fewer for a plain CRUD endpoint.

```
Eval | Date | Model | Must ticked | Must-not ticked | Result | Note
01   |      |       | /6          | /3              |        |
02   |      |       | /6          | /2              |        |
03   |      |       | /6          | /2              |        |
```
