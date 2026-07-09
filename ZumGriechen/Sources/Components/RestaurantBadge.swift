import SwiftUI

/// Optional, quiet pill naming the restaurant the compass is pointing at.
/// The app's promise is direction + distance, not a listing, so this stays
/// secondary in hierarchy even though it's drawn in the same comic style.
struct RestaurantBadge: View {
    var name: String?

    var body: some View {
        if let name {
            Text(name)
                .font(AppFont.fredoka(TypeScale.name, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
                .background(Capsule().fill(Color.surfaceCard))
                .overlay(Capsule().stroke(Color.inkOutline, lineWidth: Outline.width))
                .hardShadow(3, 3)
        }
    }
}

#Preview {
    RestaurantBadge(name: "Taverna Poseidon")
}
