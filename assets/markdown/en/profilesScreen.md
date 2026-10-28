## Profiles

![Profiles screen](resource:assets/markdown/en/profilesScreen_overview.png)

A profile combines a **weapon**, **cartridge** and **scope** into one preset. Switch between profiles to instantly switch between different rifle setups.

The screen has two tabs — swipe or tap to switch:

- **Profile** — the active profile (the one used on the Home screen): its card and the details of its weapon, cartridge and scope
- **My Profiles** — the list of all your profiles

---

### Profile tab

![Profile card](resource:assets/markdown/en/profilesScreen_card.png)

The profile name is shown above the card. The card has four buttons:

| Button | Location | Action |
|---|---|---|
| **⋮** (more) | Top-right | Opens the profile menu |
| **Scope icon** | Top-left | Replace the scope |
| **Weapon icon** | Bottom-left | Replace the weapon |
| **Cartridge icon** | Bottom-right | Replace the cartridge |

If the profile has no weapon, cartridge or scope yet, its button shows a hint ("Select weapon", "Select ammo", "Select sight") instead.

Below the card are the **Weapon**, **Ammo** and **Sight** sections with their current values. Tap the pencil icon of a section to edit it. The caliber is shared between the weapon and the cartridge — changing it in one changes it in the other.

#### Replacing a weapon, cartridge or scope

If the profile already has the item, a warning appears first:

- **Duplicate** — copies the whole profile (named `[COPY] …`), makes the copy active and applies the change to the copy, so the original stays untouched
- **Replace** — discards the current item's data and replaces it

Then choose where the new item comes from:

- **Create new** — fill in a new one from scratch
- **From collection** — pick a preset (for a cartridge: a whole cartridge, or just a bullet)
- **Import from file** — take it from an `.a7p` file

If the new weapon's caliber differs from the cartridge's, the app offers to update the cartridge's caliber to match.

---

### Profile menu (⋮)

| Action | Description |
|---|---|
| **Duplicate** | Create a copy with a name you choose (suggested: `[COPY] …`) |
| **Export** | Save the profile as a file |
| **Edit Profile Name** | Rename the profile |
| **Eject Ammo** | Detach the cartridge from the profile without deleting it — useful to edit the weapon's caliber freely |
| **Remove** | Permanently delete the profile |

---

### My Profiles tab

![My Profiles](resource:assets/markdown/en/profilesScreen_list.png)

Every profile is a card showing its weapon, caliber, cartridge and scope. The active profile is highlighted.

- **Tap a card** — make that profile active and go back to the Profile tab
- **Search** field — filters the list by profile or weapon name
- **⋮** on a card — **Edit Profile Name**, **Duplicate**, **Export**, **Remove**

---

### Adding a profile

Tap **+** (on the My Profiles tab) to open the add sheet:

- **Create new** — set up a new weapon from scratch, then name the profile (suggested: the weapon's name)
- **From collection** — pick a weapon from the built-in collection, then name the profile (suggested: the weapon's name)
- **Import from file** — load a `.ebcp` or `.a7p` file

---

### Exporting a profile

Choose a format in the export sheet:

- **.ebcp (eBalistyka)** — native format; keeps all data including the scope
- **.a7p (Archer Ballistic Profile)** — requires a cartridge and scope to be set. Choose a distance range for the embedded trajectory table:

| Range | Distances |
|---|---|
| Subsonic | 25–400 m |
| Low | 100–700 m |
| Middle | 100–1000 m |
| Long | 100–1700 m |
| Ultra long | 100–2185 m |

On the web version exporting downloads the file through your browser.
