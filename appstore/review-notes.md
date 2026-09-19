# Notes for App Review — resubmission

## Guideline 5.1.5 — Location Services

### Root cause

The app requests location access to point a compass at the nearest Greek
restaurant. When Location Services are disabled system-wide and the app has
never asked for authorization before, `CLLocationManager.authorizationStatus`
reports `.notDetermined` (not `.denied`), and no authorization-change
callback ever fires. The app previously only handled the `.denied`/
`.restricted` states, so it stayed on the loading screen indefinitely in
this scenario.

### What changed in this build

- `LocationManager` now checks `CLLocationManager.locationServicesEnabled()`
  directly and exposes a dedicated `servicesDisabled` state, and also
  handles `didFailWithError`.
- The app shows a clear "Ortungsdienste deaktiviert" screen with a button to
  open Settings, instead of hanging on the loading spinner.
- The app re-checks this state when returning to the foreground, so the UI
  updates automatically after the user re-enables Location Services.

## Guideline 1.5 — Support URL

The Support URL (`https://github.com/j0schka/zum-griechen`) previously
landed on a developer-facing technical README with no visible support info.
The README now leads with a "Support" section linking to GitHub Issues
(`https://github.com/j0schka/zum-griechen/issues`) and a contact email, for
questions and bug reports. The Support URL field itself doesn't need to
change.
