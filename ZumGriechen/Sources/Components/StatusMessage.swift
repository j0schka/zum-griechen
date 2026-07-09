import SwiftUI

enum StatusVariant {
    case loading
    case denied
    case empty

    var color: Color {
        switch self {
        case .loading: return .stateLoading
        case .denied: return .stateDenied
        case .empty: return .stateEmpty
        }
    }
}

/// Full-screen status content for the app's non-result states: loading,
/// permission denied, nothing found. Always icon + title + body, drawn like
/// a little comic prop, never bare text.
struct StatusMessage: View {
    var variant: StatusVariant
    var title: String
    var message: String
    var actionLabel: String? = nil
    var action: () -> Void = {}

    var body: some View {
        VStack(spacing: Spacing.s4) {
            ZStack {
                Circle()
                    .fill(Color.surfaceCard)
                Circle()
                    .stroke(Color.inkOutline, lineWidth: Outline.width)
                icon
            }
            .frame(width: 76, height: 76)
            .hardShadow()

            Text(title)
                .font(AppFont.fredoka(TypeScale.title, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)

            Text(message)
                .font(AppFont.fredoka(TypeScale.body, weight: .medium))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            if let actionLabel {
                Button(action: action) {
                    Text(actionLabel)
                        .font(AppFont.fredoka(16, weight: .bold))
                        .foregroundStyle(Color.textOnAccent)
                        .padding(.horizontal, 26)
                        .padding(.vertical, 12)
                }
                .buttonStyle(ComicPillButtonStyle())
                .padding(.top, Spacing.s2)
            }
        }
        .frame(maxWidth: 320)
    }

    @ViewBuilder
    private var icon: some View {
        switch variant {
        case .loading:
            ProgressView()
                .tint(variant.color)
        case .denied:
            Image(systemName: "location.slash.fill")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(variant.color)
        case .empty:
            Image(systemName: "magnifyingglass")
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(variant.color)
        }
    }
}

private struct ComicPillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Capsule().fill(configuration.isPressed ? Color.accentPrimary.opacity(0.85) : Color.accentPrimary)
            )
            .overlay(Capsule().stroke(Color.inkOutline, lineWidth: Outline.width))
            .hardShadow(3, 3)
    }
}

#Preview {
    VStack(spacing: 40) {
        StatusMessage(variant: .loading, title: "Suche läuft", message: "Wir orten das nächste griechische Restaurant.")
        StatusMessage(variant: .denied, title: "Standortzugriff benötigt", message: "Ohne Standort keine Richtung.", actionLabel: "Einstellungen öffnen")
        StatusMessage(variant: .empty, title: "Nichts gefunden", message: "Kein Grieche im Umkreis von 20 km.")
    }
}
