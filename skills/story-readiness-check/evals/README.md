# Evals for `story-readiness-check`

Manual evals: paste the **Input** of one eval file into a fresh Claude Code session with the skill
installed, then tick every line under **Must** and **Must not**. One unticked line = the eval
fails; fix the skill text, not the answer.

**Run from an empty folder outside this repo** (or use `scripts/run-eval.sh` at the repo root).
A session started inside the repo can open the eval file and tune its answer to the checklist.
After a run, check the transcript for any tool call that touched `evals/` and discard the run if
there is one.

| File | Checks |
|---|---|
| `01-title-only.md` | a bare title is sent back for a description, nothing is invented |
| `02-missing-ac-only.md` | complete story without AC → AC proposed, verdict "Ready after answers" |
| `03-contradiction.md` | requirement vs AC conflict quoted both sides → "Not ready" |

`../examples/membership-cancellation.md` is the depth reference: rules with 3–6 examples each, every
unknown value as `<?>` with a question, verdict reasoned in one sentence.

```
Eval | Date | Model | Must ticked | Must-not ticked | Result | Note
01   |      |       | /2          | /2              |        |
02   |      |       | /5          | /2              |        |
03   |      |       | /4          | /1              |        |
```
