# Zum Griechen

iOS-App, die nur eine Sache tut: das nächstgelegene griechische Restaurant anzeigen — als Kompasspfeil in die Richtung, darunter die Entfernung in Metern. Kein Listing, keine Karte, keine Navigation.

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

Store-Metadaten (Name, Untertitel, Beschreibung, Keywords) liegen als Klartext unter `fastlane/metadata/de-DE/` — dem Standardformat von `fastlane deliver`, auch ohne dass das Projekt aktuell fastlane nutzt. Das App-Icon ist ein einzelnes 1024×1024-PNG (`ZumGriechen/Resources/Assets.xcassets/AppIcon.appiconset`, Vektorquelle unter `design/app-icon.svg`) — seit Xcode 14/iOS 17 reicht das, alle weiteren Größen generiert Xcode automatisch.
