# Quality characteristics: what to cover beyond "does it work"

Source: ISTQB CTAL-TA v4.0 chapter 4 (based on ISO/IEC 25010:2023). Paraphrased; cite as `CTAL-TA §x`.
Use this to decide which test types the test set needs and to name the residual risks you do not cover.

## 1. Functional suitability (CTAL-TA §4.1)

| Sub-characteristic | Key question | Best techniques | Notes |
|---|---|---|---|
| **Functional completeness** | Is everything that was asked for implemented? | Scenario-based (behaviour-based), other black-box; **traceability** basis → conditions → tests | Start early: review requirements / discuss stories |
| **Functional correctness** | Are results correct (accurate, precise, consistent) for valid and invalid inputs? | All black-box (EP, BVA, domain, decision table), experience-based, ATDD | Needs a detailed test oracle; most of it belongs in component / integration level (shift left) |
| **Functional appropriateness** | Do the functions actually help users do their tasks? | Exploratory, collaboration-based, behaviour-based; UI design review | Demos, system and acceptance level |

## 2. Usability (CTAL-TA §4.2)

Aspects: **interaction capability** (complete tasks effectively, efficiently, satisfactorily),
**user experience** (perception before/during/after use), **accessibility** (disabilities, culture,
language).
- Usability review against a tailored checklist (heuristics).
- Usability test session scenarios from personas, user groups, operational profiles.
- Questionnaires (e.g. SUMI, WAMMI) for satisfaction.
- **Accessibility:** identify the required conformance level — WCAG **A / AA / AAA** — or national law
  (e.g. UK Equality Act, US ADA); derive checks from it (keyboard navigation, labels, contrast, focus,
  screen reader).

## 3. Flexibility (portability) (CTAL-TA §4.3)

- **Adaptability:** works on the intended environments — browser versions, mobile OS versions,
  screen sizes. Identify target environments first, then **combinatorial testing** (pairwise) over
  environment parameters; smoke test per new environment; track environment-specific defects.
- **Installability** (mobile/desktop apps): install, uninstall, **update**, reconfigure under various
  configurations; the app works after install/update; ease of install; installation docs;
  **permissions behaviour on mobile** (granted / denied / revoked later).
- Scalability and replaceability are technical (TTA / performance) — list as residual risk only.

## 4. Compatibility (CTAL-TA §4.4)

- **Interoperability:** two or more systems exchange information and use it correctly. If data is
  transformed (format, units, time zone, mapping, status codes), **verify the transformation**.
  Typical pairs: web client ↔ API, mobile app ↔ API, API ↔ third-party services (e-mail, push,
  chat, payment, maps), exports/imports.
  - Defects found: data transformation, interpretation/use of exchanged data, communication flows and
    protocols, standards compliance, end-to-end functionality, design documentation.
  - Techniques: **data-based** for exchanged data, **behaviour-based** for how data is used,
    **rule-based / end-to-end** for transformations; experience-based to complement. Reuse functional
    and adaptability tests. Usually at integration level.
  - Not all interactions are documented: read architecture/design docs to find them.
- **Coexistence** (sharing an environment without interference) is technical → residual risk.

## 5. How to use in the skill

1. For each requirement, ask which characteristics its risk touches (correctness? interoperability between
   apps? accessibility?).
2. Add test conditions for the relevant non-functional characteristics after positive and negative
   functional tests (CTFL §4.5.3 order).
3. In the coverage report, list the characteristics **not** covered (performance, security, scalability,
   coexistence) as residual risks with the suggested owner (TTA, performance tester, security).
