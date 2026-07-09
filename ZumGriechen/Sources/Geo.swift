import CoreLocation
import Foundation

func bearing(from origin: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> Double {
    let lat1 = origin.latitude * .pi / 180
    let lon1 = origin.longitude * .pi / 180
    let lat2 = destination.latitude * .pi / 180
    let lon2 = destination.longitude * .pi / 180

    let deltaLon = lon2 - lon1
    let y = sin(deltaLon) * cos(lat2)
    let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
    let radians = atan2(y, x)
    let degrees = radians * 180 / .pi
    return (degrees + 360).truncatingRemainder(dividingBy: 360)
}
