# Eval 03 — contradiction between requirement and AC

## Input
```
Refine this story please.

Free course withdrawal
As a student I want to withdraw from a course for free so that I can change my mind without
losing money.
R1. Withdrawal is free for courses that start more than 7 days from the withdrawal date.
R2. Within 7 days of the course start, withdrawal costs the standard withdrawal fee.
AC1. Given a course starting in 10 days, When I withdraw, Then no fee is charged.
AC2. Given a course starting in 3 days, When I withdraw, Then no fee is charged.
```

## Must
- [ ] Verdict **Not ready** with the reason "contradiction" in the one-line explanation.
- [ ] The contradiction R2 vs AC2 is quoted on both sides ("costs the standard withdrawal fee" vs
      "no fee is charged") in section 2.
- [ ] A blocking question asks which one is right.
- [ ] A boundary example at exactly 7 days is proposed with `<?>` and a question (inclusive or not).

## Must not
- [ ] The report does not pick a side silently and write AC as if R2 or AC2 were already agreed.
