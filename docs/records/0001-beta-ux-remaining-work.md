# Beta UX — remaining work

**Status:** In progress

Carried over from `docs/backlogs/7.BETA_UX.md` (pre-existing, unchanged) —
this record tracks only what's still open there, not the parts already
shipped:

- Display of corrections in clicks (Home AdjPanel, Tables, ReticleViewScreen)
- `ammo.zeroOffset` (`zeroOffsetX/Y` in Ammo, UI in AmmoWizard)
- Filter panel (Weapon/Ammo/Sight lists + collections)
- Notepad — Note button on Home (currently `showNotAvailableSnackBar`);
  storage TBD
- Help Overlay — coach marks; library TBD
- Tools Screen — "More" button on Home; composition TBD
- Legal links — Privacy Policy, Terms of Use, Changelog
- Custom drag function editor — `CustomDragTableEditor` is read-only; full
  editing/validation/saving pending (low priority, UX needs rethink first)
- Help screenshots pending for: `ammoWizard` (7 images), `weaponWizard`,
  `sightWizard`, `myAmmo`, `mySights`, collection screens
- Platform builds & signing: Android APK, macOS, iOS, Windows
- Auto-update: Windows msix, macOS, Android Play Store, Linux
  Flatpak/deb/rpm/Winget (see [0008] for the Windows msix blocker
  specifically)
- Database resilience — corruption handling
