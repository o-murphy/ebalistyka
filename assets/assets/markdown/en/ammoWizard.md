## New Ammo / Edit Ammo

![Ammo editor](resource:assets/markdown/en/ammoWizard_overview.png)

Create a cartridge or edit the cartridge of a profile. The form is divided into sections: the name and **Projectile** (with the drag model), **Cartridge** (muzzle velocity and powder sensitivity), **Zeroing** and the optional **Coriolis effect**. Fields marked **Required** must be filled in before **Confirm** becomes available; **Discard** leaves without saving.

---

### General

- **Ammo name** — a label to identify this cartridge (required)
- **Vendor** — manufacturer name; used for filtering in the cartridge collection

---

### Projectile

- **Projectile name** — bullet model or free-text designation
- **Caliber** — bullet diameter. It is shared with the weapon of the profile — changing it here changes the weapon too
- **Weight** — bullet weight (required)
- **Length** — overall bullet length; used for the gyroscopic stability calculation (required)

---

### Drag model

![Drag model](resource:assets/markdown/en/ammoWizard_dragModel.png)

Select the ballistic model that describes how the bullet decelerates in air:

| Model | Best for |
|-------|----------|
| **G1** | Flat-base, round-nose or older sporting bullets |
| **G7** | Boat-tail long-range bullets — generally more accurate for modern rifle projectiles |
| **CUSTOM** | Any bullet with a known Mach › Cd drag table (e.g. from Doppler radar or manufacturer data) |

**G1 / G7 — single BC.** Enter one **Ballistic coefficient** that applies at every velocity. Quick to set up; accuracy may drop in the transonic region.

**G1 / G7 — Multi-BC.** Turn on **Enable G1/G7 Multi-BC** to use a table of BC values by velocity. The app interpolates between the breakpoints, which improves accuracy across the whole velocity range. Tap **Edit G1/G7 Multi-BC table** to open the breakpoint editor.

**CUSTOM.** Tap **Edit Custom Drag Table** to enter Mach › Cd pairs. The table must cover the bullet's whole velocity range.

---

### Cartridge

- **Muzzle velocity** — measured or vendor-specified velocity at the muzzle (required)
- **Muzzle velocity temperature** — powder temperature at which that velocity was measured; the reference point for the powder sensitivity correction
- **Powder temperature sensitivity** — switch to apply a temperature correction to the muzzle velocity

When the switch is on, rows appear below the zeroing fields:

![Powder sensitivity](resource:assets/markdown/en/ammoWizard_powderSens.png)

- **Powder temperature sensitivity** — velocity change per 15 °C, in %. Enter it, or let the app calculate it (below)
- **Use different powder temperature** — switch on to set a separate powder temperature (e.g. ammunition kept warm but fired in the cold); when off, the air temperature from the Conditions screen is used
- **Calculate from measurements** — opens the temperature › velocity table; enter at least two pairs measured at the range and the app works out the sensitivity for you

---

### Zeroing

![Zeroing and Coriolis](resource:assets/markdown/en/ammoWizard_zeroing.png)

The conditions at which the weapon was zeroed. The app uses them to compensate for the difference between the zeroing and the current conditions.

- **Zero distance** — the range the weapon was zeroed for
- **Look angle** — angle to the target during zeroing (0 = level)
- **Temperature**, **Pressure**, **Humidity**, **Altitude** — the atmosphere at the zeroing location

**Vertical Offset / Horizontal Offset** — shift of the zero point in the chosen angular unit (MIL, MOA, MRAD, cm/100m, in/100yd; tap the unit to change it). Use it to move the ballistic zero without entering a new zero distance.

---

### Coriolis effect

Switch on **Coriolis effect** to account for Earth's rotation at the zeroing location (relevant beyond 800–1000 m). Two fields appear:

- **Latitude** — geographic latitude (−90° to +90°)
- **Azimuth** — firing direction relative to north (0–360°)
