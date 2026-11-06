## Settings

![Settings](resource:assets/markdown/en/settingsScreen_main.png)

---

### Language

Select the interface language (English or Ukrainian). The change is applied immediately. Until you choose one, the app follows your device language.

---

### Appearance

Theme selector: **System** · **Light** · **Dark**.

---

### Units of Measurement

![Units](resource:assets/markdown/en/settingsScreen_units.png)

Opens a separate screen with a drop-down for each type of quantity:

| Quantity | Options |
|---|---|
| Velocity | m/s, fps, km/h, mph |
| Distance | metre, yard, foot |
| Sight Height | mm, cm, inch |
| Pressure | hPa, mmHg, inHg, psi |
| Temperature | Celsius, Fahrenheit |
| Drop / Windage | m, cm, mm, inch, foot |
| Drop / Windage angle | mil, MOA, mRad, cm/100m, in/100yd |
| Energy | joule, ft·lb |
| Projectile Weight | grain, gram |
| Projectile Length | mm, cm, inch |
| Projectile Diameter | mm, cm, inch |
| Target Size | mil, MOA, mRad, cm/100m, in/100yd |

---

### Home screen

![Adjustments](resource:assets/markdown/en/settingsScreen_adjustment.png)

**Adjustment Display** — opens a screen with the look of the corrections on Home:

- **Format** — how the direction is shown: arrows (up/down), +/− (signs), U/D · R/L (letters)
- **Show units** — which units to display: MRAD · MOA · MIL · cm/100m · in/100yd · Clicks

**Show subsonic transition** — marks the point where the bullet goes subsonic on the Home trajectory chart.

**Table distance step** and **Chart distance step** — interval between the rows of the Home table and the points of the chart (in the current distance unit). A smaller value means more detail but slower calculation.

---

### Backup

- **Export** — saves all profiles (with their weapons, cartridges and scopes) and the settings to one `.ebcp` file
- **Import** — reads an `.ebcp` file and asks what to import:
  - **Import N profiles** — pick which of the file's profiles to add (they are added to yours, nothing is replaced)
  - **Settings only** — replaces your current settings after a confirmation
  - **Everything** — the profile selection first, then the settings

A section that isn't in the file is greyed out.

On the web version your data lives in the browser, so **export a backup from time to time** — clearing the site data or the browser's own cleanup removes it. Exporting downloads the file.

---

### Collection

The collection is the built-in database of weapons, cartridges and scopes for quick profile creation. **Collection version** shows the short code of the version in use; **Update collection** checks for a newer one and downloads it.

---

### Links

- **GitHub** — project source code
- **Privacy Policy** and **Terms of Use**
- **License (GPLv3)** — the license of the app (opens the full text in a browser)
- **Open source licenses** — licenses of the fonts and libraries used in the app

---

### About

- **Version** — current version of the app
- **Check for updates** — looks for a new release on GitHub; press and hold to include pre-releases (you'll be warned first). Not shown on the web version
- **Install as app** — web version in desktop browsers that support it
- **Download the app** — web version only: opens the page with downloads for your platform
- **Changelog** — opens the list of changes in a browser
