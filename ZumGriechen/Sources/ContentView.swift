import CoreLocation
import SwiftUI
import UIKit

private enum AppScreenState {
    case splash
    case loading
    case denied
    case empty(message: String)
    case result
}

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var restaurantFinder = RestaurantFinder()
    @State private var showSplash = true

    private var screenState: AppScreenState {
        if showSplash { return .splash }
        if locationManager.authorizationStatus == .denied || locationManager.authorizationStatus == .restricted {
            return .denied
        }
        if let message = restaurantFinder.errorMessage {
            return .empty(message: message)
        }
        if restaurantFinder.nearest != nil, locationManager.location != nil {
            return .result
        }
        return .loading
    }

    var body: some View {
        AppBackground(tint: isTintedState) {
            content
        }
        .animation(Motion.stateFade, value: stateIdentifier)
        .onAppear {
            locationManager.start()
            Task {
                try? await Task.sleep(nanoseconds: 1_400_000_000)
                showSplash = false
            }
        }
        .onChange(of: locationManager.location?.timestamp) { _, _ in
            if restaurantFinder.nearest == nil, let location = locationManager.location {
                restaurantFinder.findNearest(to: location)
            }
        }
    }

    private var isTintedState: Bool {
        switch screenState {
        case .splash, .result: return true
        default: return false
        }
    }

    private var stateIdentifier: String {
        switch screenState {
        case .splash: return "splash"
        case .loading: return "loading"
        case .denied: return "denied"
        case .empty: return "empty"
        case .result: return "result"
        }
    }

    @ViewBuilder
    private var content: some View {
        switch screenState {
        case .splash:
            VStack(spacing: Spacing.s6) {
                GreekManIllustration()
                SpeechBubble(text: "YAMAS!")
            }
            .transition(.opacity)

        case .loading:
            StatusMessage(
                variant: .loading,
                title: "Suche läuft",
                message: "Wir orten das nächste griechische Restaurant."
            )
            .transition(.opacity)

        case .denied:
            StatusMessage(
                variant: .denied,
                title: "Standortzugriff benötigt",
                message: "Ohne Standort keine Richtung.",
                actionLabel: "Einstellungen öffnen"
            ) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .transition(.opacity)

        case .empty(let message):
            StatusMessage(
                variant: .empty,
                title: "Nichts gefunden",
                message: message
            )
            .transition(.opacity)

        case .result:
            if let restaurant = restaurantFinder.nearest, let location = locationManager.location {
                let targetBearing = bearing(from: location.coordinate, to: restaurant.coordinate)
                let heading = locationManager.heading?.trueHeading ?? 0
                let rotation = targetBearing - heading
                let distance = location.distance(from: CLLocation(
                    latitude: restaurant.coordinate.latitude,
                    longitude: restaurant.coordinate.longitude
                ))

                VStack(spacing: Spacing.s7) {
                    Button {
                        restaurant.openInMaps()
                    } label: {
                        CompassArrow(heading: rotation, size: 220)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("In Karten öffnen")
                    .accessibilityHint("Öffnet \(restaurant.name) in Karten")

                    VStack(spacing: Spacing.s5) {
                        DistanceReadout(meters: distance)
                        Button {
                            restaurant.openInMaps()
                        } label: {
                            RestaurantBadge(name: restaurant.name)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("In Karten öffnen")
                        .accessibilityHint("Öffnet \(restaurant.name) in Karten")
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
