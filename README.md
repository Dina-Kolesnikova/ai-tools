# ai-tools

AI tooling for QA work: Claude Code skills (and more to come).

## Skills

| Skill | What it does |
|---|---|
| [`test-case-design`](skills/test-case-design/SKILL.md) | Designs manual test cases from a story / spec / field map / bug fix using ISTQB techniques (CTFL v4.0.1 + CTAL-TA v4.0): picks the technique and coverage per requirement by risk, reviews the spec for defects, reports what is deliberately not covered and the open questions. Light report by default, full on request. |
| [`story-readiness-check`](skills/story-readiness-check/SKILL.md) | Definition-of-Ready gate for a user story: proposed acceptance criteria (rules + Given/When/Then), open questions for the PO, gaps and contradictions, Ready / Ready after answers / Not ready verdict. Used by `test-case-design` before test design when the story is not ready. |
| [`api-test-scenario-generator`](skills/api-test-scenario-generator/SKILL.md) | Turns a REST endpoint spec (OpenAPI fragment, examples or plain text + rules) into a scenario table ready for Postman or automation: contract, per-field validation (EP/BVA), auth and object-level permissions, resource state, business rules, idempotency and concurrency, pagination, side effects, robustness. One request per row, delta from a baseline. Works without documentation too: the contract is reconstructed from a captured call and tagged `[observed]`, to be confirmed by the developer. |

Shared by all: [`skills/_shared/requirement-smells.md`](skills/_shared/requirement-smells.md)
(ISO 29148 requirement quality, vague words, requirement checklist, defect types).
`api-test-scenario-generator` also reuses the technique and risk references of `test-case-design`.

Each skill folder also has:
- `examples/` — one worked example (input + finished report) that sets the expected depth. All
  three use the same invented story (a gym membership cancellation), so the story, the test design
  and the API scenarios can be read side by side. No real product data anywhere.
- `evals/` — short inputs with must / must-not checklists; run them after every change to the skill

## Install (plugin, one time)

In any Claude Code chat (terminal, desktop, VS Code or JetBrains panel):

```
/plugin marketplace add Dina-Kolesnikova/ai-tools
/plugin install ai-tools@ai-tools
```

The skills are then called with the plugin prefix: `/ai-tools:test-case-design`,
`/ai-tools:story-readiness-check`, `/ai-tools:api-test-scenario-generator`, or just ask in words
("design test cases for this story").

The whole repo is installed, so the shared folder `skills/_shared/` and the cross-skill links
(`../test-case-design/references/...`) work without any extra step.

If you used an earlier copy or symlink of these skills in `~/.claude/skills/`, remove it after
installing the plugin; otherwise every skill appears twice.

## Update

Claude Code installs a copy of the plugin, pinned to its `version`. To get a newer release:

```
/plugin marketplace update ai-tools
/plugin update ai-tools@ai-tools
```

Then restart Claude Code. The changelog below lists what each version changed.

## Developing the skills

Claude Code works from the installed copy, so edits in a clone are not visible until they are
released. To try your edits before releasing, start a session with the plugin loaded straight from
your clone (this session only; nothing is installed):

```
claude --plugin-dir <path-to-your-clone-of-ai-tools>
```

Release workflow:
- This repo is the **single source of truth**; never copy skill folders around.
- Edit, run the evals in `skills/<name>/evals/` (`scripts/run-eval.sh <skill> <eval-file>
  <out-prefix>` runs one eval headless from an empty folder, with the plugin loaded from your
  clone), and check the manifests with `claude plugin validate .`
- Bump `version` in both `.claude-plugin/plugin.json` and `.claude-plugin/marketplace.json`
  (same value; without a new version, `/plugin update` does not see the change) and add a
  changelog line.
- Commit and push to `main`. Users then run the two update commands above.
- New skill: create `skills/<name>/SKILL.md` (+ `references/`, `templates/`, `examples/`,
  `evals/`), add a row to the table above and a line to the changelog.
- The repo is **public**: no project- or company-specific content, no credentials, no copyrighted
  source documents (ISTQB syllabi are paraphrased and cited, not copied). Examples use an invented
  domain only.

## Notes

- Skills are project-agnostic: they read the current project's `CLAUDE.md` for the oracle owner,
  test-data rules, test layers, save path and output language.
- ISTQB content is paraphrased with section references (`CTFL §x`, `CTAL-TA §x`); the syllabi
  themselves are not included — get them from istqb.org. Every section number in the references
  was checked against the CTFL v4.0.1 and CTAL-TA v4.0 PDFs on 2026-11-10 (see the stamp at the
  top of each reference file). Re-check when a syllabus version changes.

## Changelog

- **1.0.1, 2026-11-10** — after the first live eval round: skills no longer list `evals/` as a reference and are told never to open it (one api run had read its own checklist); story-readiness answers a bare title in one line with no verdict, caps questions at ~8 and keeps them inside the story, writes `<?>` for unsettled boundaries; api scenario table folds P3 rows in light mode; `scripts/run-eval.sh` runs an eval from an empty folder; two eval inputs corrected.
- **1.0.0, 2026-11-10** — packaged as a Claude Code plugin (`.claude-plugin/`); install via
  `/plugin`, no symlinks.
- **2026-11-10** — new skill `api-test-scenario-generator` (nine scenario groups, baseline + delta
  table, example and evals); all examples moved to one invented domain (gym membership), no
  hotel / travel wording left.
- **2026-11-10** — review round: one intake question instead of three stops; light / full report;
  coverage table without a % column; shared requirement-smells file; DoR no longer fails a story
  for missing AC alone; invalid cases grouped at high level; new signal rows for calculations,
  dates / cut-offs and concurrency; optional Layer column; worked examples and evals for both
  skills; dangling skill names removed; ISTQB section numbers verified against the PDFs.
- **2026-11** — first version: `test-case-design` and `story-readiness-check`.

## License

[MIT](LICENSE) © 2026 Dina Kolesnikova
