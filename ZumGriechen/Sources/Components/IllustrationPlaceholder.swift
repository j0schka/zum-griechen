import SwiftUI

/// Placeholder for a comic-illustrated asset this design system does not
/// draw itself (the splash screen's "Grieche mit Bier" character). A dashed
/// ink frame with a label — swap for real artwork before shipping, never
/// render this as if it were final art.
struct IllustrationPlaceholder: View {
    var label: String
    var width: CGFloat = 220
    var height: CGFloat = 220

    var body: some View {
        RoundedRectangle(cornerRadius: Radius.md)
            .fill(Color.flagBlue100)
            .overlay(
                RoundedRectangle(cornerRadius: Radius.md)
                    .stroke(Color.inkOutline, style: StrokeStyle(lineWidth: Outline.width, dash: [6, 5]))
            )
            .overlay(
                Text(label)
                    .font(AppFont.fredoka(15, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(Spacing.s4)
            )
            .frame(width: width, height: height)
    }
}

#Preview {
    IllustrationPlaceholder(label: "Grieche mit Bier, comic-gezeichnet (Astérix-Stil)")
}
