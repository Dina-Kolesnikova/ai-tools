# Eval 03 — contradiction between requirement and AC

## Input
```
Refine this story please.

Free seat selection
As a traveller I want to pick my seat for free so that I sit with my family.
R1. Seat selection is free for bookings made more than 7 days before departure.
R2. Within 7 days of departure, seat selection costs the standard seat fee.
AC1. Given a booking 10 days before departure, When I select a seat, Then no fee is charged.
AC2. Given a booking 3 days before departure, When I select a seat, Then the seat is free.
```

## Must
- [ ] Verdict **Not ready** with the reason "contradiction" in the one-line explanation.
- [ ] The contradiction R2 vs AC2 is quoted on both sides ("costs the standard seat fee" vs
      "the seat is free") in section 2.
- [ ] A blocking question asks which one is right.
- [ ] A boundary example at exactly 7 days is proposed with `<?>` and a question (inclusive or not).

## Must not
- [ ] The report does not pick a side silently and write AC as if R2 or AC2 were already agreed.
