# Records

Convention for new decisions from here on, kept separate from the
pre-existing plans in `docs/backlogs/` (those stay as they are — see
`docs/0000-TRACKER.md`).

- One file per record: `NNNN-slug.md`, flat numbering, no dots, no
  reuse of a retired number.
- Records may be edited for: a `Status:` change (e.g. `Proposed` →
  `Accepted` → `Implemented`), adding new information (a new section,
  findings, a newly considered alternative, a new implementation note),
  or a small correction. Don't rewrite a record's decision or rationale
  after the fact — if it no longer holds, write a later record that
  supersedes it and says so, linking back with `[NNNN]`.
- First line is a `# Title` — this is what gets copied verbatim into the
  tracker row. Second line is `**Status:** Proposed|Accepted|Implemented|
  Not scheduled`.
- Small items don't need a file at all — a tracker row with an inline
  note is enough. Write a record when there's real rationale, a rejected
  alternative, or an implementation trail worth keeping for later.
- Every record gets exactly one row in `docs/0000-TRACKER.md`, under
  whichever of *In progress / Proposed*, *Implemented*, or *Rejected*
  matches its current `Status:`.
