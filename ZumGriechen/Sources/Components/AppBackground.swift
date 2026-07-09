import SwiftUI

/// Full-bleed halftone-dot background used as the root wrapper behind every
/// screen state. Flat white (or the pale flag-blue panel tint) with a faint
/// comic-print dot texture — never a gradient wash.
struct AppBackground<Content: View>: View {
    var tint: Bool = false
    @ViewBuilder var content: () -> Content

    var body: some View {
        ZStack {
            (tint ? Color.surfacePanel : Color.surfaceApp)
                .ignoresSafeArea()
            HalftoneDots()
                .ignoresSafeArea()
            VStack {
                Spacer(minLength: 0)
                content()
                Spacer(minLength: 0)
            }
            .padding(Spacing.s5)
        }
    }
}

private struct HalftoneDots: View {
    private let spacing: CGFloat = 16
    private let radius: CGFloat = 1

    var body: some View {
        Canvas { context, size in
            let dotColor = Color.inkOutline.opacity(0.06)
            var y: CGFloat = -4
            while y < size.height + spacing {
                var x: CGFloat = -4
                while x < size.width + spacing {
                    let rect = CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)
                    context.fill(Path(ellipseIn: rect), with: .color(dotColor))
                    x += spacing
                }
                y += spacing
            }
        }
    }
}
