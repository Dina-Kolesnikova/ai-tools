# Eval 03 — calculation and date cut-off

## Input
```
Test design for this rule, please.

Late payment fee
R1. An invoice is due 30 days after the invoice date.
R2. From the day after the due date, a late fee of 2% of the invoice amount is added for every
    started week of delay.
R3. The late fee never exceeds 10% of the invoice amount.
R4. The fee is shown on the invoice page and included in the amount to pay.
R5. Invoices of less than 50 EUR get no late fee.
```
Intake answers: no existing coverage; known risk: fee disputes with customers; gate: yes; light.

## Must
- [ ] The run stops once at the gate with the technique plan table and continues after "ok".
- [ ] Section 2 uses the **calculation** signal row for R2–R3 (EP/BVA per operand, worked example
      per branch, metamorphic relation) and the **dates** signal row for R1–R2 (BVA at the day unit).
- [ ] A worked example exists with concrete numbers only where the story gives them (2 %, 10 %,
      50 EUR, 30 days) and `<?>` for rounding (the story gives no rounding rule).
- [ ] Day boundaries are tested on both sides: due date, due date + 1, and the week starts
      (day 1 and day 7/8 of delay), plus the cap week (week 5 vs week 6).
- [ ] R5 gets 3-value BVA around 50 EUR (49.99, 50.00, 50.01) and a question whether 50.00 is
      "less than 50".
- [ ] A question asks which time zone / calendar defines "day" and whether the invoice date counts
      as day 0 or day 1.
- [ ] P1 is at most ~30 % of the cases, or the report states why it is higher.

## Must not
- [ ] No rounding rule stated as `[spec]`.
- [ ] No expected fee amount derived from "what the UI shows today".
- [ ] No second stop between the gate and the final report.
