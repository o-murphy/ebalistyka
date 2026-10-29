## Shooting Conditions

![Shooting conditions](resource:assets/markdown/en/conditionsScreen_overview.png)

The Conditions screen lets you set atmospheric parameters, powder temperature sensitivity, and the Coriolis effect correction. All values immediately affect the adjustments calculated on the Home screen.

---

### Temperature

![Temperature](resource:assets/markdown/en/conditionsScreen_temperature.png)

Air temperature at the top. Use the **−** and **+** buttons to change it step by step, or **tap the value** to enter an exact number (type it or scroll the wheel, then **Confirm**).

---

### Altitude, Humidity, Pressure

![Altitude, humidity, pressure](resource:assets/markdown/en/conditionsScreen_atmo.png)

Three buttons for entering atmospheric conditions:

- **Altitude** — elevation above sea level
- **Humidity** — relative air humidity (%)
- **Pressure** — atmospheric pressure

Tap any button to open the value input.

---

### Powder Temperature Sensitivity

![Powder sensitivity](resource:assets/markdown/en/conditionsScreen_powderSens.png)

This section accounts for the change in muzzle velocity depending on powder temperature.

**"Enable powder temperature sensitivity" toggle** — switches the correction on or off. When it is on, the screen shows the **Powder temperature sensitivity** of the current cartridge (read-only — it is set in the cartridge properties) and the **Muzzle velocity** that results.

**"Use different powder temperature" toggle:**
- **Off** — the air temperature entered above is used (the line below says "Uses atmospheric temperature")
- **On** — a separate **Powder temperature** field appears (e.g. when ammunition is kept somewhere warm but fired in the cold)

The last line shows the muzzle velocity for the chosen temperature.

---

### Coriolis Effect

![Coriolis effect](resource:assets/markdown/en/conditionsScreen_coriolis.png)

Accounts for bullet deflection due to Earth's rotation. Relevant at distances beyond 800–1000 m.

**"Coriolis effect" toggle** — switches the correction on or off. When it is on, two fields appear (tap the pencil to edit):

- **Latitude** — geographic latitude of the firing position (−90° to +90°)
- **Azimuth** — firing direction relative to north (0–360°)
