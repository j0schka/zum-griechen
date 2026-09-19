import CoreLocation
import Foundation

@MainActor
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var heading: CLHeading?
    @Published var authorizationStatus: CLAuthorizationStatus
    /// True when Location Services are off system-wide, or access was denied.
    /// Distinct from `authorizationStatus == .denied`: with Location Services off
    /// system-wide, a never-before-asked app reports `.notDetermined` and never
    /// receives an authorization-change callback, so we must check
    /// `CLLocationManager.locationServicesEnabled()` directly to avoid hanging
    /// on the loading state forever.
    @Published var servicesDisabled = !CLLocationManager.locationServicesEnabled()

    private let manager = CLLocationManager()

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.headingFilter = 1
    }

    func start() {
        guard CLLocationManager.locationServicesEnabled() else {
            servicesDisabled = true
            return
        }
        servicesDisabled = false
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
    }

    /// Re-checks Location Services state, e.g. after the user returns from Settings.
    func refresh() {
        start()
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorizationStatus = status
            self.servicesDisabled = !CLLocationManager.locationServicesEnabled()
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
                manager.startUpdatingHeading()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let clError = error as? CLError, clError.code == .denied else { return }
        Task { @MainActor in
            self.servicesDisabled = true
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latest = locations.last else { return }
        Task { @MainActor in
            self.location = latest
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        Task { @MainActor in
            self.heading = newHeading
        }
    }
}
