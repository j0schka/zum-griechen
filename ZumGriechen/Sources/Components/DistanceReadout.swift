import SwiftUI

/// The hero number: distance to the nearest restaurant, in meters (auto
/// switches to km past 1000m). VoiceOver gets a single combined label
/// ("340 Meter entfernt") rather than two fragments.
struct DistanceReadout: View {
    var meters: Double?
    var size: Size = .large

    enum Size { case large, small }

    private var formatted: (value: String, unit: String) {
        guard let meters else { return ("—", "") }
        if meters >= 1000 {
            return (String(format: "%.1f", meters / 1000), "km")
        }
        return ("\(Int(meters.rounded()))", "m")
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: Spacing.s2) {
            Text(formatted.value)
                .font(AppFont.fredoka(size == .large ? TypeScale.distance : TypeScale.distanceSmall, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .shadow(color: .flagBlue100, radius: 0, x: 4, y: 4)

            if !formatted.unit.isEmpty {
                Text(formatted.unit)
                    .font(AppFont.fredoka(TypeScale.unit, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(meters != nil ? "\(Int((meters ?? 0).rounded())) Meter entfernt" : "Entfernung unbekannt")
    }
}

#Preview {
    VStack(spacing: 40) {
        DistanceReadout(meters: 340)
        DistanceReadout(meters: 1830)
        DistanceReadout(meters: nil)
    }
}
