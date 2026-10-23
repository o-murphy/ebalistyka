## Tables

### Trajectory Tab

![Trajectory table](resource:assets/markdown/en/tablesScreen_trajectory.png)

The tab shows ballistic data for the current profile and shooting conditions across distances. The left column (range) is fixed — the remaining columns scroll horizontally.

It has up to two sections:

- **Zero crossings** — the distances where the trajectory crosses the line of sight: an up arrow marks the first crossing (the bullet rising through the line of sight), a down arrow the second (coming down). Can be turned off in the table settings
- **Trajectory** — one row per distance, from the start to the end distance with the chosen step

**Row highlighting:**
- Accent colour, bold — the zero distance (the distance the weapon is zeroed for)
- Red — a zero crossing
- Subdued accent colour — the subsonic transition

**Tap a row** to open a dialog with all values for that distance, including the corrections in every unit you have enabled.

![Row details](resource:assets/markdown/en/tablesScreen_rowDetail.png)

**Top-right buttons:**
- **Table settings** (sliders icon, Trajectory tab only) — opens the table configuration
- **Share** — exports the table as an HTML page; it opens in your browser (in a new tab on the web version), where you can print or save it

---

### Details Tab

![Profile details](resource:assets/markdown/en/tablesScreen_details.png)

The parameters used for the calculation:

- **Weapon** — name, caliber, twist rate, zero distance
- **Cartridge** — zero muzzle velocity and current muzzle velocity (it differs when powder temperature changes the velocity)
- **Projectile** — drag model, ballistic coefficient, length, caliber, weight, form factor, sectional density, gyroscopic stability factor (Sg)
- **Conditions** — temperature, humidity, pressure, wind speed and direction

---

### Table Settings

![Table settings](resource:assets/markdown/en/tablesScreen_config.png)

Opened with the **sliders** button on the Trajectory tab. Lets you customise the distance range and the columns.

**Range** — Start distance, End distance and Distance step define the rows of the table.

**Extra:**
- **Show zero crossings table** — adds the separate Zero crossings section
- **Show subsonic transition** — highlights the row where the bullet goes subsonic

**Visible columns** — switch individual metrics on or off:
Time · Velocity · Height · Drop · Drop° · Wind · Wind° · Mach · Drag · Energy

(Drop and Wind are the linear values; the columns marked ° are the same corrections as angles, in the units chosen below.)

**Adjustment columns** — which angular units to show for the Drop° and Wind° columns:
MRAD · MOA · MIL · cm/100m · in/100yd · Clicks
