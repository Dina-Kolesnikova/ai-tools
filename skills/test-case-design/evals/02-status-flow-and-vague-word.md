# Eval 02 — status flow, grouped invalid moves, vague word

## Input
```
Write test cases for this.

Purchase order approval
R1. A purchase order goes Draft → Submitted → Approved. The requester submits; a manager approves.
R2. A manager can also reject a Submitted order; it goes back to Draft.
R3. An Approved order cannot be edited or deleted.
R4. Only a manager can approve or reject.
R5. The orders list should load quickly.
```
Intake answers: no existing coverage; no risk notes; no gate; light.

## Must
- [ ] Section 2 chooses **State transition** for R1–R3 and names the coverage criterion
      (valid transitions / all transitions) with a CTFL §4.2.4 reference.
- [ ] Round-trip or loop is mentioned for R2 (Submitted → Draft → Submitted).
- [ ] Invalid moves on Approved (edit, delete, and any other the model shows) appear either as one
      high-level case listing them in Covers with a "split at low level" flag, or as one case each.
      Not as one executed step with several actions.
- [ ] The result of a forbidden attempt is `<?>` with a question (the story does not say what happens).
- [ ] R4 is tested with the non-manager actor trying approve and reject (EP on actor).
- [ ] "quickly" (R5) is in section 1.3 as untestable and in section 6 as a question; no response-time
      number is invented.

## Must not
- [ ] No test case claims a message, status code or redirect the story does not state as `[spec]`.
- [ ] No duplicate: the happy path Draft → Submitted → Approved is one case, not three.
