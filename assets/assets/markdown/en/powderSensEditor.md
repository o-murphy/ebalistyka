## Powder Sensitivity Measurements

![Powder sensitivity measurements](resource:assets/markdown/en/powderSensEditor.png)

A table of **temperature › muzzle velocity** pairs measured at the range. The app calculates the powder sensitivity from them and uses it to correct the muzzle velocity at any temperature.

The banner at the top shows the **Calculated Sensitivity** live, in %/15°C ("No measurements yet" until there are valid rows).

---

### Filling the table

- Enter the temperature (°C) in the left column and the measured muzzle velocity (m/s) in the right column
- There are five rows; rows with a non-positive velocity are ignored. The temperature may be negative, zero or positive
- The sensitivity is averaged across all valid pairs, so you need at least two pairs measured at different temperatures
- **Save** keeps the table and updates the cartridge's powder sensitivity; **Discard** leaves it unchanged

---

### Tips

- Measure the velocity at two or more clearly different temperatures (for example +5 °C and +25 °C) for a reliable coefficient
- When the cartridge already has a reference velocity and temperature, the first row starts pre-filled with them
