# Zum Griechen

iOS-App, die nur eine Sache tut: das nächstgelegene griechische Restaurant anzeigen — als Kompasspfeil in die Richtung, darunter die Entfernung in Metern. Kein Listing, keine Karte, keine Navigation.

---

## Support

Fragen, Bugs oder Feature-Wünsche? Bitte [ein Issue auf GitHub eröffnen](https://github.com/j0schka/zum-griechen/issues) — das erreicht den Entwickler am schnellsten. Alternativ per Mail: [joschkafriedag@gmail.com](mailto:joschkafriedag@gmail.com).

---

## Stack

- SwiftUI, iOS 17+
- CoreLocation (Standort + Kompass-Heading)
- MapKit (`MKLocalSearch`) zur Restaurantsuche
- Projektstruktur via [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`project.yml`), das Xcode-Projekt selbst ist generiert

## Setup

```bash
brew install xcodegen   # falls noch nicht installiert
xcodegen generate
open ZumGriechen.xcodeproj
```

Danach in Xcode auf einem echten iPhone bauen und starten — Kompass-Heading funktioniert im Simulator nicht zuverlässig.

`ZumGriechen.xcodeproj` wird von XcodeGen erzeugt und nicht manuell gepflegt. Änderungen an Build-Settings, Info.plist-Keys etc. gehören nach `project.yml`, nicht direkt in die generierten Dateien — sonst gehen sie beim nächsten `xcodegen generate` wieder verloren.

## Projektstruktur

```
project.yml                          # XcodeGen-Projektdefinition
ZumGriechen/Sources/
  ZumGriechenApp.swift                # App-Einstieg
  ContentView.swift                   # einziger Screen: Pfeil + Distanz
  LocationManager.swift               # Standort- & Heading-Updates
  RestaurantFinder.swift              # MKLocalSearch nach "Griechisches Restaurant"
  Geo.swift                           # Peilungsberechnung (Bearing) zwischen zwei Koordinaten
  Info.plist
ZumGriechen/Resources/
  Assets.xcassets/                    # AppIcon, AccentColor
```

## Funktionsweise

1. `LocationManager` fragt Standortzugriff an und liefert laufend Position + Kompass-Heading.
2. Sobald der erste Standort-Fix da ist, sucht `RestaurantFinder` per `MKLocalSearch` im 20-km-Umkreis nach "Griechisches Restaurant" und wählt den Treffer mit der kürzesten Luftlinien-Distanz.
3. `ContentView` zeigt einen Pfeil, der sich anhand von Peilung (Ziel) minus Geräte-Heading dreht, sowie die Distanz in Metern darunter.

Zustände neben dem Ergebnis: Ladeanzeige, "Standortzugriff wird benötigt" (Berechtigung verweigert) und eine Fehlermeldung, falls kein griechisches Restaurant gefunden wurde oder die Suche fehlschlägt.

## Design

"Classic Flag Comic" Design-System aus [claude.ai/design](https://claude.ai/design) umgesetzt: Fredoka/Bangers-Fonts, Flaggenblau + Weiß, dicke Tinten-Konturen mit hartem Versatz-Schatten. Komponenten unter `ZumGriechen/Sources/Components`, Tokens unter `ZumGriechen/Sources/DesignSystem`.

## App Store

Alles zur Store-Einreichung liegt unter [`appstore/`](appstore):
- [`appstore/metadata.md`](appstore/metadata.md) — Name, Untertitel, Beschreibung, Keywords, Werbetext und alle weiteren ASC-Felder zum Copy-Pasten.
- `appstore/screenshots/` — nach Gerätegröße sortiert (6.5"/6.7" sind die von App Store Connect verlangten Pflichtgrößen).

Datenschutzerklärung: [`PRIVACY.md`](PRIVACY.md), gehostet als GitHub-Blob-URL (`github.com/j0schka/zum-griechen/blob/main/PRIVACY.md`) — dafür muss das Repo öffentlich bleiben.

Das App-Icon ist ein einzelnes 1024×1024-PNG (`ZumGriechen/Resources/Assets.xcassets/AppIcon.appiconset`, Vektorquelle unter `design/app-icon.svg`) — seit Xcode 14/iOS 17 reicht das, alle weiteren Größen generiert Xcode automatisch.
