# Definition of Ready — checklist

> Starter version. Adapt it with the team: remove items you do not need, add your own.
> Items marked (M) are mandatory: if one fails, the verdict is "Not ready". Everything else
> failing gives "Ready after answers" at worst. A project `CLAUDE.md` may list its own mandatory
> items; they replace the (M) set below.

1. (M) **Goal is clear** — who the user is, what they want, why (business value).
2. **Every requirement has AC** — rule + at least one Given/When/Then example. If missing, the
   skill proposes them (Step 4) and the PO confirms: that is "Ready after answers", not "Not ready".
3. (M) **No contradictions** — between requirements, AC, designs and comments.
4. (M) **No blocking questions open.** Blocking = the main flow cannot be built or tested without
   the answer (missing formula or amount, undefined core state, contradiction in the main flow).
   Boundary units, edge-case precedence, error texts and failure paths are non-blocking, except a
   boundary that decides an amount or a right (refund or charge, access granted or denied): blocking.
5. **Negative and boundary cases are covered** for every rule where failure is possible.
6. **Business values are explicit** — limits, amounts, time windows, statuses, error texts.
7. **Scope is clear** — what is out of scope is written down.
8. **Dependencies are known** — other teams, APIs, third parties, feature flags, data migrations.
9. **Designs / mockups attached** if the story changes UI.
10. **Small enough** — fits in one sprint; otherwise split.
11. **Testable on an environment** — test data and accounts are available or can be created.
