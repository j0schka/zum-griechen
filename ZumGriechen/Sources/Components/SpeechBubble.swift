import SwiftUI

/// Classic comic speech bubble: thick ink outline, hard offset shadow,
/// pointed tail. Used for the splash screen's "YAMAS!" and any other
/// one-off exclamation — never for regular UI copy.
struct SpeechBubble: View {
    var text: String
    var tailSide: TailSide = .bottomLeft
    var shout: Bool = true

    enum TailSide { case bottomLeft, bottomRight }

    var body: some View {
        Text(text)
            .font(shout ? AppFont.bangers(TypeScale.shout) : AppFont.fredoka(TypeScale.title, weight: .bold))
            .tracking(shout ? 1 : 0)
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 28)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: Radius.md)
                    .fill(Color.surfaceCard)
                    .overlay(RoundedRectangle(cornerRadius: Radius.md).stroke(Color.inkOutline, lineWidth: Outline.widthLarge))
                    .hardShadow(6, 6)
            )
            .overlay(alignment: tailSide == .bottomLeft ? .bottomLeading : .bottomTrailing) {
                SpeechTail()
                    .frame(width: 40, height: 30)
                    .scaleEffect(x: tailSide == .bottomLeft ? 1 : -1, y: 1)
                    .offset(x: tailSide == .bottomLeft ? 20 : -20, y: 16)
            }
    }
}

private struct SpeechTail: View {
    var body: some View {
        ZStack {
            SpeechTailShape().fill(Color.surfaceCard)
            SpeechTailShape().stroke(Color.inkOutline, lineWidth: Outline.widthLarge)
        }
    }
}

private struct SpeechTailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + 2, y: rect.minY + 2))
        path.addLine(to: CGPoint(x: rect.minX + 38, y: rect.minY + 2))
        path.addLine(to: CGPoint(x: rect.minX + 6, y: rect.minY + 28))
        path.closeSubpath()
        return path
    }
}

#Preview {
    VStack(spacing: 60) {
        SpeechBubble(text: "YAMAS!")
        SpeechBubble(text: "Kurze Pause…", tailSide: .bottomRight, shout: false)
    }
}
