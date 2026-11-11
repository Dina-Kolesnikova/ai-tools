# ai-tools

AI tooling for QA work: Claude Code skills (and more to come).

## Skills

| Skill | What it does |
|---|---|
| [`test-case-design`](skills/test-case-design/SKILL.md) | Designs manual test cases from a story / spec / field map / bug fix using ISTQB techniques (CTFL v4.0.1 + CTAL-TA v4.0): picks the technique and coverage per requirement by risk, reviews the spec for defects, reports what is deliberately not covered and the open questions. Light report by default, full on request. |
| [`story-readiness-check`](skills/story-readiness-check/SKILL.md) | Definition-of-Ready gate for a user story: proposed acceptance criteria (rules + Given/When/Then), open questions for the PO, gaps and contradictions, Ready / Ready after answers / Not ready verdict. Used by `test-case-design` before test design when the story is not ready. |
| [`api-test-scenario-generator`](skills/api-test-scenario-generator/SKILL.md) | Turns a REST endpoint spec (OpenAPI fragment, examples or plain text + rules) into a scenario table ready for Postman or automation: contract, per-field validation (EP/BVA), auth and object-level permissions, resource state, business rules, idempotency and concurrency, pagination, side effects, robustness. One request per row, delta from a baseline. |

Shared by all: [`skills/_shared/requirement-smells.md`](skills/_shared/requirement-smells.md)
(ISO 29148 requirement quality, vague words, requirement checklist, defect types).
`api-test-scenario-generator` also reuses the technique and risk references of `test-case-design`.

Each skill folder also has:
- `examples/` — one worked example (input + finished report) that sets the expected depth. All
  three use the same invented story (a gym membership cancellation), so the story, the test design
  and the API scenarios can be read side by side. No real product data anywhere.
- `evals/` — short inputs with must / must-not checklists; run them after every change to the skill

## Install

Clone the repo and **symlink** each skill folder and the shared folder into `~/.claude/skills/`,
then restart Claude Code:

```bash
git clone https://github.com/Dina-Kolesnikova/ai-tools.git ~/Documents/Apps/ai-tools
for s in _shared test-case-design story-readiness-check api-test-scenario-generator; do
  ln -s ~/Documents/Apps/ai-tools/skills/$s ~/.claude/skills/$s
done
```

`_shared` has no `SKILL.md`, so it is not a skill; the symlink only makes the
`../_shared/requirement-smells.md` links inside the two skills resolve.

Then run `/test-case-design` or ask "design test cases for this story".

## Editing workflow (for humans and agents)

- This repo is the **single source of truth**. `~/.claude/skills/<name>` is a symlink to
  `skills/<name>` here — never a copy.
- Edit the skill here; Claude Code sees the change immediately (no copy / rsync step).
- Then run the evals in `skills/<name>/evals/`, commit and push from this repo. If
  `~/.claude/skills` is itself a git repo, keep these symlinks in its `.gitignore` so they are
  never committed there.
- New skill: create `skills/<name>/SKILL.md`, add the symlink, add a row to the table above.
- The repo is **public**: no project- or company-specific content, no credentials, no copyrighted
  source documents (ISTQB syllabi are paraphrased and cited, not copied).

## Notes

- Skills are project-agnostic: they read the current project's `CLAUDE.md` for the oracle owner,
  test-data rules, test layers, save path and output language.
- ISTQB content is paraphrased with section references (`CTFL §x`, `CTAL-TA §x`); the syllabi
  themselves are not included — get them from istqb.org. Every section number in the references
  was checked against the CTFL v4.0.1 and CTAL-TA v4.0 PDFs on 2026-11-10 (see the stamp at the
  top of each reference file). Re-check when a syllabus version changes.

## Changelog

- **2026-11-10** — new skill `api-test-scenario-generator` (nine scenario groups, baseline + delta
  table, example and evals); all examples moved to one invented domain (gym membership), no
  hotel / travel wording left.
- **2026-11-10** — review round: one intake question instead of three stops; light / full report;
  coverage table without a % column; shared requirement-smells file; DoR no longer fails a story
  for missing AC alone; invalid cases grouped at high level; new signal rows for calculations,
  dates / cut-offs and concurrency; optional Layer column; worked examples and evals for both
  skills; dangling skill names removed; ISTQB section numbers verified against the PDFs.
- **2026-11** — first version: `test-case-design` and `story-readiness-check`.
