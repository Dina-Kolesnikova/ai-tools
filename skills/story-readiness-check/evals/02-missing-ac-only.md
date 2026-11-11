# Eval 02 — complete story, no AC

## Input
```
Check the story.

Newsletter unsubscribe link
As a subscriber I want a one-click unsubscribe link in every newsletter so that I stop receiving
it without logging in.
R1. Every newsletter e-mail contains an unsubscribe link in the footer.
R2. Opening the link unsubscribes the address immediately, without login, and shows the page
    "You have been unsubscribed".
R3. The link stays valid for 30 days after the e-mail was sent; after that it shows the page
    "This link has expired".
R4. An already unsubscribed address that opens the link sees "You have been unsubscribed" again
    and nothing changes.
Out of scope: resubscribe flow; preference centre.
Designs: footer and both pages are in the linked Figma.
```

## Must
- [ ] Verdict is **Ready after answers** (or Ready) — not "Not ready": the story has no contradiction
      and every value is given; only AC are missing.
- [ ] One rule per requirement with Given/When/Then examples, each tagged `[story]` or `[proposed]`.
- [ ] R3 has boundary examples at 30 days (day 30, day 31) tagged `[proposed]`, with a non-blocking
      question whether day 30 is still valid.
- [ ] R4 is an example in the "State" category.
- [ ] A non-blocking question or example covers a tampered / unknown token (the story does not say).

## Must not
- [ ] No "Not ready" verdict caused only by missing AC.
- [ ] No page text or time limit the story does not give is written without `<?>`.
