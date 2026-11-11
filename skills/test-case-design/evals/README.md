# Evals for `test-case-design`

Manual evals: paste the **Input** of one eval file into a fresh Claude Code session with the skill
installed, answer the intake question as the file says, then tick every line under **Must** and
**Must not**. One unticked line = the eval fails; fix the skill text, not the answer.

Run them after every change to `SKILL.md`, the references or the template. Three inputs:

| File | Checks |
|---|---|
| `01-missing-limit.md` | no invented business value: `<?>` + question instead of a number |
| `02-status-flow-and-vague-word.md` | state transition chosen, invalid moves grouped at high level, vague word flagged |
| `03-calculation-and-dates.md` | calculation and dates signal rows used, worked example, time zone question, P1 share |

The worked example in `../examples/membership-cancellation.md` is the reference for depth: a result
much longer or much shorter than that for a story of similar size is a finding too.

Scoring sheet (copy per run):

```
Eval | Date | Model | Must ticked | Must-not ticked | Result | Note
01   |      |       | /5          | /3              |        |
02   |      |       | /6          | /2              |        |
03   |      |       | /7          | /3              |        |
```
