# ai-tools

AI tooling for QA work: Claude Code skills (and more to come).

## Skills

| Skill | What it does |
|---|---|
| [`test-case-design`](skills/test-case-design/SKILL.md) | Designs manual test cases from a story / spec / field map / bug fix using ISTQB techniques (CTFL v4.0 + CTAL-TA v4.0): picks the technique and coverage per requirement by risk, reviews the spec for defects, reports coverage. |
| [`story-readiness-check`](skills/story-readiness-check/SKILL.md) | Definition-of-Ready gate for a user story: proposed acceptance criteria (rules + Given/When/Then), open questions for the PO, gaps, Ready / Not ready verdict. Used by `test-case-design` before test design when the story is not ready. |

## Install

Clone the repo and **symlink** each skill folder into `~/.claude/skills/`, then restart Claude Code:

```bash
git clone https://github.com/Dina-Kolesnikova/ai-tools.git ~/Documents/Apps/ai-tools
for s in test-case-design story-readiness-check; do
  ln -s ~/Documents/Apps/ai-tools/skills/$s ~/.claude/skills/$s
done
```

Then run `/test-case-design` or ask "design test cases for this story".

## Editing workflow (for humans and agents)

- This repo is the **single source of truth**. `~/.claude/skills/<name>` is a symlink to
  `skills/<name>` here — never a copy.
- Edit the skill here; Claude Code sees the change immediately (no copy / rsync step).
- Then commit and push from this repo. If `~/.claude/skills` is itself a git repo, keep these
  symlinks in its `.gitignore` so they are never committed there.
- New skill: create `skills/<name>/SKILL.md`, add the symlink, add a row to the table above.
- The repo is **public**: no project- or company-specific content, no credentials, no copyrighted
  source documents (ISTQB syllabi are paraphrased and cited, not copied).

## Notes

- Skills are project-agnostic: they read the current project's `CLAUDE.md` for the oracle owner, test-data rules, save path and output language.
- ISTQB content is paraphrased with section references (`CTFL §x`, `CTAL-TA §x`); the syllabi themselves are not included — get them from istqb.org.
