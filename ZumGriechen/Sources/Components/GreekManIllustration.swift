import SwiftUI

/// The splash screen's comic character: a Greek man in a white shirt with a
/// diagonal flag-blue sash, raising a beer mug. Astérix-flavored flat-vector
/// take on "Variante 1 — Klassiker mit Schärpe" from the illustration
/// concepts. Colors are hardcoded (not the dynamic semantic tokens) — a
/// drawn character keeps its own look regardless of app dark mode, the same
/// way the compass face stays a literal white disc in both modes.
struct GreekManIllustration: View {
    var width: CGFloat = 170

    private static let baseSize = CGSize(width: 180, height: 340)
    private let ink = Color(red: 0x14 / 255, green: 0x18 / 255, blue: 0x1B / 255)
    private let skin = Color(red: 0xE8 / 255, green: 0xB3 / 255, blue: 0x82 / 255)
    private let shirt = Color.white
    private let blue = Color(red: 0x0D / 255, green: 0x5E / 255, blue: 0xAF / 255)
    private let gold = Color(red: 0xF5 / 255, green: 0xB9 / 255, blue: 0x42 / 255)

    var body: some View {
        Canvas { context, size in
            let scale = size.width / Self.baseSize.width
            context.scaleBy(x: scale, y: scale)
            draw(&context)
        }
        .frame(width: width, height: width * Self.baseSize.height / Self.baseSize.width)
        .accessibilityHidden(true)
    }

    private func draw(_ context: inout GraphicsContext) {
        // ground shadow
        context.fill(Path(ellipseIn: CGRect(x: 40, y: 329, width: 100, height: 18)), with: .color(ink.opacity(0.15)))

        // legs + feet
        for legX: CGFloat in [58, 96] {
            let leg = Path(roundedRect: CGRect(x: legX, y: 235, width: 26, height: 75), cornerRadius: 13)
            context.fill(leg, with: .color(blue))
            context.stroke(leg, with: .color(ink), lineWidth: 3)
        }
        for footCX: CGFloat in [71, 125] {
            context.fill(Path(ellipseIn: CGRect(x: footCX - 16, y: 304, width: 32, height: 16)), with: .color(ink))
        }

        // left arm (down at side)
        var leftArm = Path()
        leftArm.move(to: CGPoint(x: 48, y: 165))
        leftArm.addQuadCurve(to: CGPoint(x: 40, y: 222), control: CGPoint(x: 30, y: 190))
        context.stroke(leftArm, with: .color(ink), style: StrokeStyle(lineWidth: 26, lineCap: .round))
        context.stroke(leftArm, with: .color(skin), style: StrokeStyle(lineWidth: 20, lineCap: .round))

        // torso + sash
        let torso = Path(roundedRect: CGRect(x: 38, y: 150, width: 104, height: 100), cornerRadius: 32)
        context.fill(torso, with: .color(shirt))
        context.stroke(torso, with: .color(ink), lineWidth: 3)

        var sash = Path()
        sash.move(to: CGPoint(x: 50, y: 150))
        sash.addLine(to: CGPoint(x: 94, y: 250))
        sash.addLine(to: CGPoint(x: 108, y: 250))
        sash.addLine(to: CGPoint(x: 64, y: 150))
        sash.closeSubpath()
        context.fill(sash, with: .color(blue))
        context.stroke(sash, with: .color(ink), lineWidth: 2)

        // right arm (raised, holding the mug)
        var rightArm = Path()
        rightArm.move(to: CGPoint(x: 132, y: 165))
        rightArm.addQuadCurve(to: CGPoint(x: 150, y: 98), control: CGPoint(x: 152, y: 140))
        context.stroke(rightArm, with: .color(ink), style: StrokeStyle(lineWidth: 26, lineCap: .round))
        context.stroke(rightArm, with: .color(skin), style: StrokeStyle(lineWidth: 20, lineCap: .round))

        // beer mug
        let mug = Path(roundedRect: CGRect(x: 133, y: 66, width: 34, height: 46), cornerRadius: 4)
        context.fill(mug, with: .color(gold))
        context.stroke(mug, with: .color(ink), lineWidth: 3)
        let foam = Path(ellipseIn: CGRect(x: 131, y: 56, width: 38, height: 20))
        context.fill(foam, with: .color(.white))
        context.stroke(foam, with: .color(ink), lineWidth: 2)
        var handle = Path()
        handle.move(to: CGPoint(x: 167, y: 76))
        handle.addQuadCurve(to: CGPoint(x: 167, y: 100), control: CGPoint(x: 182, y: 82))
        context.stroke(handle, with: .color(ink), lineWidth: 4)

        // neck
        context.fill(Path(CGRect(x: 78, y: 132, width: 24, height: 20)), with: .color(skin))

        // hair tufts
        var leftHair = Path()
        leftHair.move(to: CGPoint(x: 56, y: 70))
        leftHair.addQuadCurve(to: CGPoint(x: 54, y: 110), control: CGPoint(x: 40, y: 86))
        leftHair.addQuadCurve(to: CGPoint(x: 68, y: 88), control: CGPoint(x: 60, y: 92))
        leftHair.closeSubpath()
        context.fill(leftHair, with: .color(ink))

        var rightHair = Path()
        rightHair.move(to: CGPoint(x: 124, y: 70))
        rightHair.addQuadCurve(to: CGPoint(x: 126, y: 110), control: CGPoint(x: 140, y: 86))
        rightHair.addQuadCurve(to: CGPoint(x: 112, y: 88), control: CGPoint(x: 120, y: 92))
        rightHair.closeSubpath()
        context.fill(rightHair, with: .color(ink))

        // head + ears
        let head = Path(ellipseIn: CGRect(x: 54, y: 72, width: 72, height: 72))
        context.fill(head, with: .color(skin))
        context.stroke(head, with: .color(ink), lineWidth: 3)
        for earCX: CGFloat in [54, 126] {
            let ear = Path(ellipseIn: CGRect(x: earCX - 8, y: 102, width: 16, height: 16))
            context.fill(ear, with: .color(skin))
            context.stroke(ear, with: .color(ink), lineWidth: 2)
        }

        // eyes
        for eyeCX: CGFloat in [76, 104] {
            context.fill(Path(ellipseIn: CGRect(x: eyeCX - 3, y: 99, width: 6, height: 6)), with: .color(ink))
        }

        // eyebrows
        var leftBrow = Path()
        leftBrow.move(to: CGPoint(x: 68, y: 92))
        leftBrow.addQuadCurve(to: CGPoint(x: 84, y: 92), control: CGPoint(x: 76, y: 88))
        context.stroke(leftBrow, with: .color(ink), style: StrokeStyle(lineWidth: 3, lineCap: .round))

        var rightBrow = Path()
        rightBrow.move(to: CGPoint(x: 96, y: 92))
        rightBrow.addQuadCurve(to: CGPoint(x: 112, y: 92), control: CGPoint(x: 104, y: 88))
        context.stroke(rightBrow, with: .color(ink), style: StrokeStyle(lineWidth: 3, lineCap: .round))

        // mustache
        var mustache = Path()
        mustache.move(to: CGPoint(x: 55, y: 114))
        mustache.addQuadCurve(to: CGPoint(x: 90, y: 112), control: CGPoint(x: 70, y: 100))
        mustache.addQuadCurve(to: CGPoint(x: 125, y: 114), control: CGPoint(x: 110, y: 100))
        mustache.addQuadCurve(to: CGPoint(x: 90, y: 116), control: CGPoint(x: 110, y: 122))
        mustache.addQuadCurve(to: CGPoint(x: 55, y: 114), control: CGPoint(x: 70, y: 122))
        mustache.closeSubpath()
        context.fill(mustache, with: .color(ink))

        // mouth
        var mouth = Path()
        mouth.move(to: CGPoint(x: 75, y: 128))
        mouth.addQuadCurve(to: CGPoint(x: 105, y: 128), control: CGPoint(x: 90, y: 136))
        context.stroke(mouth, with: .color(ink), style: StrokeStyle(lineWidth: 3, lineCap: .round))
    }
}

#Preview {
    GreekManIllustration()
}
