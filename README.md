# ai-tools

AI tooling for QA work: Claude Code skills (and more to come).

## Skills

| Skill | What it does |
|---|---|
| [`test-case-design`](skills/test-case-design/SKILL.md) | Designs manual test cases from a story / spec / field map / bug fix using ISTQB techniques (CTFL v4.0 + CTAL-TA v4.0): picks the technique and coverage per requirement by risk, reviews the spec for defects, reports coverage. |
| [`story-readiness-check`](skills/story-readiness-check/SKILL.md) | Definition-of-Ready gate for a user story: proposed acceptance criteria (rules + Given/When/Then), open questions for the PO, gaps, Ready / Not ready verdict. Used by `test-case-design` before test design when the story is not ready. |

## Install

Copy (or symlink) a skill folder into `~/.claude/skills/` and restart Claude Code:

```bash
git clone https://github.com/Dina-Kolesnikova/ai-tools.git
cp -R ai-tools/skills/test-case-design ai-tools/skills/story-readiness-check ~/.claude/skills/
```

Then run `/test-case-design` or ask "design test cases for this story".

## Notes

- Skills are project-agnostic: they read the current project's `CLAUDE.md` for the oracle owner, test-data rules, save path and output language.
- ISTQB content is paraphrased with section references (`CTFL §x`, `CTAL-TA §x`); the syllabi themselves are not included — get them from istqb.org.
