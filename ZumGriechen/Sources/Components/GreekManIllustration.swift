import SwiftUI

/// The splash screen's comic character: a Greek man in a tunic with a
/// diagonal flag-blue sash, raising a beer mug. Astérix/Obélix-flavored —
/// a proper torso silhouette (not a rounded-rect blob), a defined nose,
/// curled mustache tips, blush cheeks and gripping fists, not just line
/// caps. Colors are hardcoded (not the dynamic semantic tokens) — a drawn
/// character keeps its own look regardless of app dark mode, the same way
/// the compass face stays a literal white disc in both modes.
struct GreekManIllustration: View {
    var width: CGFloat = 170

    private static let baseSize = CGSize(width: 180, height: 340)
    private let ink = Color(red: 0x14 / 255, green: 0x18 / 255, blue: 0x1B / 255)
    private let skin = Color(red: 0xE8 / 255, green: 0xB3 / 255, blue: 0x82 / 255)
    private let tunic = Color.white
    private let blue = Color(red: 0x0D / 255, green: 0x5E / 255, blue: 0xAF / 255)
    private let gold = Color(red: 0xF5 / 255, green: 0xB9 / 255, blue: 0x42 / 255)
    private let blush = Color(red: 0xE0 / 255, green: 0x86 / 255, blue: 0x74 / 255)
    private let hair = Color(red: 0x2A / 255, green: 0x1E / 255, blue: 0x16 / 255)

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
        drawShadowAndLegs(&context)
        drawArms(&context)
        drawTorso(&context)
        drawMug(&context)
        drawHands(&context)
        drawHeadAndFace(&context)
        drawHair(&context)
    }

    private func drawShadowAndLegs(_ context: inout GraphicsContext) {
        context.fill(Path(ellipseIn: CGRect(x: 40, y: 329, width: 100, height: 18)), with: .color(ink.opacity(0.15)))

        for legX: CGFloat in [58, 96] {
            let leg = Path(roundedRect: CGRect(x: legX, y: 235, width: 26, height: 75), cornerRadius: 13)
            context.fill(leg, with: .color(blue))
            context.stroke(leg, with: .color(ink), lineWidth: 3)
        }
        for footCX: CGFloat in [71, 125] {
            let foot = Path(ellipseIn: CGRect(x: footCX - 17, y: 303, width: 34, height: 17))
            context.fill(foot, with: .color(ink))
            var strap = Path()
            strap.move(to: CGPoint(x: footCX - 11, y: 303))
            strap.addLine(to: CGPoint(x: footCX + 11, y: 303))
            context.stroke(strap, with: .color(skin), style: StrokeStyle(lineWidth: 2, lineCap: .round))
        }
    }

    private func drawArms(_ context: inout GraphicsContext) {
        var leftArm = Path()
        leftArm.move(to: CGPoint(x: 48, y: 168))
        leftArm.addQuadCurve(to: CGPoint(x: 40, y: 222), control: CGPoint(x: 28, y: 192))
        context.stroke(leftArm, with: .color(ink), style: StrokeStyle(lineWidth: 26, lineCap: .round))
        context.stroke(leftArm, with: .color(skin), style: StrokeStyle(lineWidth: 20, lineCap: .round))

        var rightArm = Path()
        rightArm.move(to: CGPoint(x: 132, y: 168))
        rightArm.addQuadCurve(to: CGPoint(x: 148, y: 104), control: CGPoint(x: 156, y: 140))
        context.stroke(rightArm, with: .color(ink), style: StrokeStyle(lineWidth: 26, lineCap: .round))
        context.stroke(rightArm, with: .color(skin), style: StrokeStyle(lineWidth: 20, lineCap: .round))
    }

    private func drawTorso(_ context: inout GraphicsContext) {
        // shoulders -> waist -> flared hem, mirrored, with a neckline dip on top
        var torso = Path()
        torso.move(to: CGPoint(x: 44, y: 158))
        torso.addQuadCurve(to: CGPoint(x: 54, y: 204), control: CGPoint(x: 36, y: 182))
        torso.addQuadCurve(to: CGPoint(x: 36, y: 252), control: CGPoint(x: 46, y: 228))
        torso.addLine(to: CGPoint(x: 144, y: 252))
        torso.addQuadCurve(to: CGPoint(x: 126, y: 204), control: CGPoint(x: 134, y: 228))
        torso.addQuadCurve(to: CGPoint(x: 136, y: 158), control: CGPoint(x: 144, y: 182))
        torso.addQuadCurve(to: CGPoint(x: 90, y: 148), control: CGPoint(x: 115, y: 152))
        torso.addQuadCurve(to: CGPoint(x: 44, y: 158), control: CGPoint(x: 65, y: 152))
        torso.closeSubpath()
        context.fill(torso, with: .color(tunic))
        context.stroke(torso, with: .color(ink), lineWidth: 3)

        var sash = Path()
        sash.move(to: CGPoint(x: 56, y: 158))
        sash.addLine(to: CGPoint(x: 100, y: 248))
        sash.addLine(to: CGPoint(x: 114, y: 248))
        sash.addLine(to: CGPoint(x: 70, y: 158))
        sash.closeSubpath()
        context.fill(sash, with: .color(blue))
        context.stroke(sash, with: .color(ink), lineWidth: 2)

        var belt = Path()
        belt.move(to: CGPoint(x: 54, y: 206))
        belt.addQuadCurve(to: CGPoint(x: 126, y: 206), control: CGPoint(x: 90, y: 212))
        context.stroke(belt, with: .color(ink), style: StrokeStyle(lineWidth: 3, lineCap: .round))
        let buckle = Path(roundedRect: CGRect(x: 84, y: 202, width: 12, height: 10), cornerRadius: 2)
        context.fill(buckle, with: .color(gold))
        context.stroke(buckle, with: .color(ink), lineWidth: 2)
    }

    private func drawMug(_ context: inout GraphicsContext) {
        let mug = Path(roundedRect: CGRect(x: 131, y: 64, width: 34, height: 46), cornerRadius: 4)
        context.fill(mug, with: .color(gold))
        context.stroke(mug, with: .color(ink), lineWidth: 3)
        let foam = Path(ellipseIn: CGRect(x: 129, y: 54, width: 38, height: 20))
        context.fill(foam, with: .color(.white))
        context.stroke(foam, with: .color(ink), lineWidth: 2)
        var handle = Path()
        handle.move(to: CGPoint(x: 165, y: 74))
        handle.addQuadCurve(to: CGPoint(x: 165, y: 98), control: CGPoint(x: 180, y: 80))
        context.stroke(handle, with: .color(ink), lineWidth: 4)
    }

    private func drawHands(_ context: inout GraphicsContext) {
        let leftFist = Path(ellipseIn: CGRect(x: 27, y: 211, width: 26, height: 22))
        context.fill(leftFist, with: .color(skin))
        context.stroke(leftFist, with: .color(ink), lineWidth: 3)

        let rightFist = Path(ellipseIn: CGRect(x: 133, y: 92, width: 30, height: 24))
        context.fill(rightFist, with: .color(skin))
        context.stroke(rightFist, with: .color(ink), lineWidth: 3)
        for knuckleX: CGFloat in [141, 149, 157] {
            var knuckle = Path()
            knuckle.move(to: CGPoint(x: knuckleX, y: 96))
            knuckle.addQuadCurve(to: CGPoint(x: knuckleX, y: 104), control: CGPoint(x: knuckleX + 2, y: 100))
            context.stroke(knuckle, with: .color(ink), style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
        }
    }

    private func drawHeadAndFace(_ context: inout GraphicsContext) {
        // neck
        var neck = Path()
        neck.move(to: CGPoint(x: 78, y: 136))
        neck.addLine(to: CGPoint(x: 102, y: 136))
        neck.addLine(to: CGPoint(x: 98, y: 156))
        neck.addLine(to: CGPoint(x: 82, y: 156))
        neck.closeSubpath()
        context.fill(neck, with: .color(skin))

        // head
        let head = Path(ellipseIn: CGRect(x: 52, y: 64, width: 76, height: 80))
        context.fill(head, with: .color(skin))
        context.stroke(head, with: .color(ink), lineWidth: 3)

        for earCX: CGFloat in [53, 127] {
            let ear = Path(ellipseIn: CGRect(x: earCX - 8, y: 96, width: 16, height: 18))
            context.fill(ear, with: .color(skin))
            context.stroke(ear, with: .color(ink), lineWidth: 2)
        }

        // cheeks
        for cheekCX: CGFloat in [66, 114] {
            context.fill(Path(ellipseIn: CGRect(x: cheekCX - 9, y: 106, width: 18, height: 12)), with: .color(blush.opacity(0.45)))
        }

        // eyes (white + pupil)
        for eyeCX: CGFloat in [74, 106] {
            let white = Path(ellipseIn: CGRect(x: eyeCX - 7, y: 90, width: 14, height: 14))
            context.fill(white, with: .color(.white))
            context.stroke(white, with: .color(ink), lineWidth: 1.5)
            context.fill(Path(ellipseIn: CGRect(x: eyeCX - 3, y: 93, width: 7, height: 7)), with: .color(ink))
        }

        // eyebrows, raised and joyful
        var leftBrow = Path()
        leftBrow.move(to: CGPoint(x: 62, y: 82))
        leftBrow.addQuadCurve(to: CGPoint(x: 86, y: 84), control: CGPoint(x: 74, y: 74))
        context.stroke(leftBrow, with: .color(ink), style: StrokeStyle(lineWidth: 4, lineCap: .round))

        var rightBrow = Path()
        rightBrow.move(to: CGPoint(x: 94, y: 84))
        rightBrow.addQuadCurve(to: CGPoint(x: 118, y: 82), control: CGPoint(x: 106, y: 74))
        context.stroke(rightBrow, with: .color(ink), style: StrokeStyle(lineWidth: 4, lineCap: .round))

        // nose
        let nose = Path(ellipseIn: CGRect(x: 84, y: 108, width: 12, height: 16))
        context.fill(nose, with: .color(skin))
        context.stroke(nose, with: .color(ink), lineWidth: 2)

        // mustache with curled tips
        var mustache = Path()
        mustache.move(to: CGPoint(x: 50, y: 128))
        mustache.addQuadCurve(to: CGPoint(x: 90, y: 126), control: CGPoint(x: 70, y: 110))
        mustache.addQuadCurve(to: CGPoint(x: 130, y: 128), control: CGPoint(x: 110, y: 110))
        mustache.addQuadCurve(to: CGPoint(x: 90, y: 132), control: CGPoint(x: 112, y: 140))
        mustache.addQuadCurve(to: CGPoint(x: 50, y: 128), control: CGPoint(x: 68, y: 140))
        mustache.closeSubpath()
        context.fill(mustache, with: .color(ink))
        context.stroke(Path(ellipseIn: CGRect(x: 43, y: 121, width: 10, height: 10)), with: .color(ink), lineWidth: 2)
        context.stroke(Path(ellipseIn: CGRect(x: 127, y: 121, width: 10, height: 10)), with: .color(ink), lineWidth: 2)

        // open, cheering mouth
        let mouth = Path(ellipseIn: CGRect(x: 82, y: 138, width: 16, height: 10))
        context.fill(mouth, with: .color(ink))
        context.fill(Path(CGRect(x: 84, y: 138, width: 12, height: 3)), with: .color(.white))
    }

    private func drawHair(_ context: inout GraphicsContext) {
        var hairPath = Path()
        hairPath.move(to: CGPoint(x: 52, y: 96))
        hairPath.addQuadCurve(to: CGPoint(x: 58, y: 66), control: CGPoint(x: 45, y: 80))
        hairPath.addQuadCurve(to: CGPoint(x: 90, y: 56), control: CGPoint(x: 70, y: 52))
        hairPath.addQuadCurve(to: CGPoint(x: 122, y: 66), control: CGPoint(x: 110, y: 52))
        hairPath.addQuadCurve(to: CGPoint(x: 128, y: 96), control: CGPoint(x: 135, y: 80))
        hairPath.addQuadCurve(to: CGPoint(x: 112, y: 86), control: CGPoint(x: 122, y: 94))
        hairPath.addQuadCurve(to: CGPoint(x: 96, y: 96), control: CGPoint(x: 104, y: 80))
        hairPath.addQuadCurve(to: CGPoint(x: 80, y: 84), control: CGPoint(x: 88, y: 96))
        hairPath.addQuadCurve(to: CGPoint(x: 64, y: 94), control: CGPoint(x: 72, y: 78))
        hairPath.addQuadCurve(to: CGPoint(x: 52, y: 96), control: CGPoint(x: 58, y: 88))
        hairPath.closeSubpath()
        context.fill(hairPath, with: .color(hair))
        context.stroke(hairPath, with: .color(ink), lineWidth: 2)
    }
}

#Preview {
    GreekManIllustration()
}
