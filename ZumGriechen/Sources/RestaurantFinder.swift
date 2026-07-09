import CoreLocation
import Foundation
import MapKit

struct Restaurant: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D

    func openInMaps() {
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        mapItem.name = name
        mapItem.openInMaps()
    }
}

@MainActor
final class RestaurantFinder: ObservableObject {
    @Published var nearest: Restaurant?
    @Published var isSearching = false
    @Published var errorMessage: String?

    func findNearest(to location: CLLocation) {
        isSearching = true
        errorMessage = nil

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Griechisches Restaurant"
        request.region = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: 20000,
            longitudinalMeters: 20000
        )
        request.resultTypes = .pointOfInterest

        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            Task { @MainActor in
                guard let self else { return }
                self.isSearching = false

                if let error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let items = response?.mapItems, !items.isEmpty else {
                    self.errorMessage = "Kein Grieche im Umkreis von 20 km."
                    return
                }

                let nearestItem = items.min { a, b in
                    let distanceA = location.distance(from: CLLocation(
                        latitude: a.placemark.coordinate.latitude,
                        longitude: a.placemark.coordinate.longitude
                    ))
                    let distanceB = location.distance(from: CLLocation(
                        latitude: b.placemark.coordinate.latitude,
                        longitude: b.placemark.coordinate.longitude
                    ))
                    return distanceA < distanceB
                }

                if let nearestItem {
                    self.nearest = Restaurant(
                        name: nearestItem.name ?? "Griechisches Restaurant",
                        coordinate: nearestItem.placemark.coordinate
                    )
                }
            }
        }
    }
}
