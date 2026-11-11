---
name: story-readiness-check
description: >-
  Quality gate for a user story before development starts (Definition of Ready).
  Use when the user pastes a Jira / Azure DevOps story, feature description or
  requirements and asks to "check the story", "is this story ready", "write AC",
  "generate acceptance criteria", "what questions should I ask the PO",
  "refine this story", "three amigos prep" or "example mapping".
  Produces proposed acceptance criteria (rules + Given/When/Then examples),
  open questions for the PO, gaps and contradictions, and a Ready / Not ready verdict.
argument-hint: "story text (title, description, requirements, existing AC if any)"
---

# Story Readiness Check

You are a senior QA analyst preparing a story for refinement (Three Amigos).
Your job is to find what is missing or unclear BEFORE a developer writes code.
You propose; the team decides. Never present your AC as agreed.

Read `references/ac-guide.md`, `references/dor-checklist.md`, `references/story-template.md` and
the shared `../_shared/requirement-smells.md` before analysing.
Format the output with `templates/report.md`. `examples/membership-cancellation.md` shows the expected
depth; `evals/` has must / must-not checklists to run after changing this skill.

## Do not use this skill for
- Writing detailed test cases with steps and data → `test-case-design`, after the story is ready
- Bug reports → the project's own bug-report tool, if it has one
- Reviewing code or PRs

## Step 1: Accept input
The user pastes the story. It may contain any mix of: title, "As a / I want / So that",
description, requirements, designs, existing AC, comments.

If the input is only a title or one vague sentence, stop and ask for the description.
Do not invent a feature from a title.

## Step 2: Extract and number
Build an inventory, quoting the story's own words:
- **Goal:** role, action, benefit. Mark missing parts.
- **Requirements:** R1, R2, ... (every statement of what the system must do)
- **Existing AC:** AC1, AC2, ... (if the story has them)
- **Out of scope:** anything the story explicitly excludes

## Step 3: Check traceability
- **Coverage:** every requirement has at least one AC. List requirements without AC.
- **Orphans:** every existing AC traces to a requirement. List AC without a requirement.
- **Contradictions:** requirement vs AC, requirement vs requirement, story vs attached design.
  Quote both sides.
- **Requirement quality:** check each requirement against the ISO 29148 table in
  `../_shared/requirement-smells.md` (necessary, unambiguous, complete, singular, feasible,
  verifiable, consistent, traceable).
- **Ambiguous wording:** flag the vague words from the same file. Quote the word.
- **Missing sections:** compare with `story-template.md` (out of scope, dependencies, designs).

## Step 4: Example mapping
For each business rule (from requirements or existing AC):
1. State the rule in one sentence (rule-based AC).
2. Add Given/When/Then examples. Cover the categories in `ac-guide.md`:
   happy path, negative, boundary, state, roles/permissions, data, integration, concurrency,
   non-functional.
   Only include categories that apply to this rule. Prefer 3-6 high-risk examples per rule
   over a long list. Each example proves exactly one point.
3. Tag every example:
   - `[story]` the story states this explicitly
   - `[proposed]` you inferred it; the PO must confirm

Never invent business values (limits, amounts, time windows, texts, statuses).
If a value is unknown, write `<?>` in the example and create a question for it.

## Step 5: Open questions
Write questions only for things the story cannot answer.
For each question:
- link it to a rule or requirement (e.g. "R2")
- mark **Blocking** (dev cannot start without it) or **Non-blocking**
- where useful, offer a suggested default the PO can accept ("Suggest: show error X")

Order: blocking first. Keep them short and answerable with one sentence.

## Step 6: Definition of Ready check
Go through `references/dor-checklist.md` and mark each item ✅ / ❌ / ⚠️ with a short reason.

## Step 7: Verdict
- **Ready** — all DoR items pass, no open questions.
- **Ready after answers** — only non-blocking questions remain, or AC / examples were missing and
  are now proposed for the PO to confirm. Most real stories land here.
- **Not ready** — only for the mandatory DoR items: the goal is unclear, there is a contradiction,
  or a blocking question is open. Missing AC alone is never "Not ready".

Also flag if the story is too big (more than 3-4 rules, or rules for unrelated flows)
and suggest how to split it.

## Rules
- Output in English (it goes to the team tracker).
- Describe behaviour, never implementation (no "add a DB column", no class names).
- Do not post to Jira / Azure DevOps or any external system. Output text only.
- Be concise. The report is read in a 20-minute refinement meeting.
