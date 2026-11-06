## Home Screen

![Home Screen](resource:assets/markdown/en/homeScreen_overview.png)

The Home Screen is your main workspace. This is where you enter shooting conditions and get ready-to-use scope adjustments.

---

### Profile bar

![Profile bar](resource:assets/markdown/en/homeScreen_profile.png)

- **Profile button** (name and **…**) — shows the active profile. Tap it to open the **Profiles** screen, where you can switch profiles or edit the weapon, cartridge and scope.
- **Cartridge button** (rocket icon, on the right) — opens the editor of the current cartridge. Shown when the profile is complete.

Below the bar, a line with the cartridge name, muzzle velocity, drag model, ballistic coefficient and gyroscopic stability (Sg) summarises the current setup.

---

### Environmental Conditions

![Environmental conditions](resource:assets/markdown/en/homeScreen_sideControls.png)

Current atmospheric conditions are displayed on both sides of the wind indicator:

- **Temperature** and **altitude** — left column
- **Humidity** and **atmospheric pressure** — right column

These values are edited on the **Conditions** screen.

The four round buttons next to the wind indicator:

| Button | Action |
|---|---|
| **i** (top left) | Opens **Shot info** |
| **Note** (bottom left) | Notes — not available yet |
| **?** (top right) | Opens this guide |
| **…** (bottom right) | More tools — not available yet |

---

### Wind Direction Indicator

![Wind indicator](resource:assets/markdown/en/homeScreen_wind.png)

A circular dial for setting the **wind direction**:

- **Drag** the arrow — or **swipe** along the circle — to change the direction.
- **Double-tap** the dial to reset the direction to zero.
- **Tap the degrees** in the center to enter an exact value manually.
- Direction is shown simultaneously in **degrees** (0–360°) and **clock format** (e.g. 03:00).

---

### Quick Actions

![Quick actions](resource:assets/markdown/en/homeScreen_quickActions.png)

Three buttons below the wind indicator for the most common adjustments:

| Button | Tap | Long press |
|---|---|---|
| **Wind speed** | Opens value input | Resets to 0 |
| **Look angle** | Opens value input | Resets to 0 |
| **Target range** | Opens value input | — |

---

### Result Pages

The bottom section is a carousel of three pages. Switch by swiping or with the arrows and dots at the bottom.

#### Holdovers

![Holdovers](resource:assets/markdown/en/homeScreen_pageHoldovers.png)

Shows the reticle with the scope adjustments for the current conditions:

- **Hold** — vertical adjustment (up/down arrow)
- **Windage** — horizontal adjustment (left/right arrow)

Values are shown in the units selected in **Settings → Adjustment Display** (MIL, MOA, cm/100m, clicks, …). **Tap the reticle** to open it full-screen. **Press and hold** the values to jump straight to the Adjustment Display settings.

#### Trajectory info

![Trajectory info](resource:assets/markdown/en/homeScreen_pageTable.png)

A compact table of the distances around the target range (the target column is highlighted): height, elevation, drop, wind and velocity, with the corrections in the units you selected.

For the full table open the **Tables** screen.

#### Trajectory chart

![Trajectory chart](resource:assets/markdown/en/homeScreen_pageChart.png)

At the top: target range, velocity, energy, time of flight, height, drop, windage and Mach number at the target. Below: the bullet's height over distance (solid), its velocity (dashed green) and the line of sight (dashed). The point where the bullet goes subsonic can be marked (see **Settings → Show subsonic transition**).

---

### Shot Info

![Shot info](resource:assets/markdown/en/homeScreen_shotInfo.png)

Opened with the **i** button. Shows computed ballistic values for the current conditions and target range.

**Velocity**
- **Current MV** — muzzle velocity at the current powder temperature
- **Zero MV** — muzzle velocity at zeroing conditions
- **Speed of sound** — for the current atmosphere
- **Velocity at target** — remaining bullet speed at the set distance

**Energy**
- **Energy at muzzle velocity** — kinetic energy at the muzzle
- **Energy at target** — kinetic energy at the set distance

**Gyroscopic stability factor (Sg)** — stability for the current conditions. Values below 1.0 indicate the bullet may not stabilise.

**Trajectory**
- **Target range** — the distance used for all calculations
- **Trajectory apex** — maximum bullet rise above the line of sight
- **Trajectory apex distance** — distance at which the apex occurs
- **Windage** — horizontal wind drift at the target
- **Time to target** — bullet flight time to the set distance
