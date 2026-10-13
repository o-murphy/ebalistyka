# Home Note / Help / More buttons

**Status:** Proposed

All three Home-screen buttons (Note, Help, More) are still stubs
(`showNotAvailableSnackBar` or equivalent). Note → Notepad, Help → Help
Overlay, and More → Tools Screen are tracked as their own open items in
[0001]; this record is just the placeholder-buttons wiring itself, listed
separately since it was tracked as its own phase in the old master
document.

**Update (2026-10-13):** the **Help** button on Home now opens the screen's
help dialog (`showHelpDialog(helpId: HelpData.homeScreen)`) — done. **Note**
and **More** are still `showNotAvailableSnackBar` stubs
(`home_screen.dart`); a Help *overlay* (coach marks) is still open under
[0001].
