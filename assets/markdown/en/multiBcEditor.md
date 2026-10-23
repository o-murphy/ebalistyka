## Multi-BC Table

![Multi-BC table](resource:assets/markdown/en/multiBcEditor.png)

Defines how the ballistic coefficient (BC) changes with bullet velocity, for the G1 or G7 model chosen in the cartridge editor. More breakpoints give a more accurate drag model across the whole velocity range.

Each row is a **velocity › BC** pair. The table is sorted by velocity, highest first, when you save.

---

### Filling the table

- Enter the velocity (in the unit shown in the column header) in the left column and the corresponding BC in the right column
- There are five rows; leave unused rows at 0 — rows where any value is 0 are ignored on save
- When the cartridge already has a muzzle velocity and a single BC, the first row starts pre-filled with them
- **Save** keeps the table, **Discard** leaves the cartridge unchanged; saving an empty table clears the Multi-BC data

---

### Tips

- Add at least 2–3 breakpoints from manufacturer data or measurements to see a real improvement over a single BC
