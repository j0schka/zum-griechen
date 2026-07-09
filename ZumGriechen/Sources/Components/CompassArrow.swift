import SwiftUI

/// The app's hero element: a bold, thick-outlined comic needle inside a
/// solid ink-ringed compass face. Rotates live with device heading.
struct CompassArrow: View {
    var heading: Double
    var size: CGFloat = 220
    var active: Bool = true

    var body: some View {
        ZStack {
            CompassFace()
                .frame(width: size, height: size)

            NeedleShape()
                .fill(active ? Color.accentPrimary : Color.ink300)
                .overlay(NeedleShape().stroke(Color.inkOutline, lineWidth: 5 * (size / 220)))
                .frame(width: size * 0.46, height: size * 0.46)
                .shadow(color: .inkOutline, radius: 0, x: 3 * (size / 220), y: 3 * (size / 220))
                .rotationEffect(.degrees(heading))
                .animation(Motion.easeNeedle, value: heading)
        }
        .frame(width: size, height: size)
    }
}

private struct CompassFace: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            let inset = size * 8 / 220 // ring radius 102 of half-size 110

            ZStack {
                Circle()
                    .fill(Color.white)
                Circle()
                    .stroke(Color.inkOutline, lineWidth: 4 * (size / 220))
                CompassTicks(onlyMajor: true)
                    .stroke(Color.inkOutline, style: StrokeStyle(lineWidth: 4 * (size / 220), lineCap: .round))
                CompassTicks(onlyMajor: false)
                    .stroke(Color.inkOutline, style: StrokeStyle(lineWidth: 2.5 * (size / 220), lineCap: .round))
            }
            .padding(inset)
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

private struct CompassTicks: Shape {
    var onlyMajor: Bool

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let scale = rect.width / 204 // ring diameter (220 - 2*8 inset)
        let center = CGPoint(x: rect.midX, y: rect.midY)

        for i in 0..<12 where (i % 3 == 0) == onlyMajor {
            let angle = Double(i) * 30 * .pi / 180
            let r1: CGFloat = 80 * scale
            let r2: CGFloat = (onlyMajor ? 66 : 74) * scale
            let x1 = center.x + r1 * CGFloat(sin(angle))
            let y1 = center.y - r1 * CGFloat(cos(angle))
            let x2 = center.x + r2 * CGFloat(sin(angle))
            let y2 = center.y - r2 * CGFloat(cos(angle))
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y2))
        }
        return path
    }
}

private struct NeedleShape: Shape {
    func path(in rect: CGRect) -> Path {
        func point(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
            CGPoint(x: rect.minX + x / 100 * rect.width, y: rect.minY + y / 100 * rect.height)
        }
        var path = Path()
        path.move(to: point(50, 4))
        path.addLine(to: point(80, 78))
        path.addLine(to: point(50, 60))
        path.addLine(to: point(20, 78))
        path.closeSubpath()
        return path
    }
}

#Preview {
    CompassArrow(heading: 42)
}
