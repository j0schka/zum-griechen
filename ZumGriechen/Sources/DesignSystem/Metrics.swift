import SwiftUI

// Ported from tokens/spacing.css, radii.css and motion.css.

enum Spacing {
    static let s1: CGFloat = 4
    static let s2: CGFloat = 8
    static let s3: CGFloat = 12
    static let s4: CGFloat = 16
    static let s5: CGFloat = 24
    static let s6: CGFloat = 32
    static let s7: CGFloat = 48
    static let s8: CGFloat = 64
    static let s9: CGFloat = 96
}

enum Radius {
    static let sm: CGFloat = 12
    static let md: CGFloat = 24
    static let pill: CGFloat = 999
}

enum Outline {
    static let width: CGFloat = 3
    static let widthLarge: CGFloat = 4
}

enum Motion {
    static let easeNeedle = Animation.timingCurve(0.34, 1.2, 0.4, 1, duration: 0.26)
    static let easePop = Animation.timingCurve(0.34, 1.56, 0.64, 1, duration: 0.45)
    static let stateFade = Animation.easeInOut(duration: 0.35)
}

extension View {
    /// The comic "hard" shadow — zero blur, offset only, never soft/ambient.
    func hardShadow(_ x: CGFloat = 4, _ y: CGFloat = 4) -> some View {
        shadow(color: .hardShadow, radius: 0, x: x, y: y)
    }
}
