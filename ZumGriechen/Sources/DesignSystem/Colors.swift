import SwiftUI
import UIKit

// Ported from tokens/colors.css — "Classic Flag Comic" v2.
// Flag blue + white do almost all the work; ink-900 is a comic ink/outline
// color, not just muted text. Dark mode inverts to a navy "blue night"
// surface; the compass face itself stays a literal white disc in both modes.

private extension UIColor {
    convenience init(hex: String) {
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        self.init(
            red: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255,
            alpha: 1
        )
    }

    convenience init(light: UIColor, dark: UIColor) {
        self.init { $0.userInterfaceStyle == .dark ? dark : light }
    }
}

enum ZGColor {
    static let flagBlue700 = UIColor(hex: "0D5EAF")
    static let flagBlue500 = UIColor(hex: "1C7ED6")
    static let flagBlue100 = UIColor(hex: "EAF4FC")
    static let white = UIColor(hex: "FFFFFF")
    static let ink900 = UIColor(hex: "14181B")
    static let ink700 = UIColor(hex: "33393D")
    static let ink500 = UIColor(hex: "647079")
    static let ink300 = UIColor(hex: "A9B3BA")
    static let line100 = UIColor(hex: "D7E3EA")
    static let gold500 = UIColor(hex: "F5B942")
    static let red600 = UIColor(hex: "D8402C")
    static let navy950 = UIColor(hex: "052142")
    static let navy900 = UIColor(hex: "0A2F57")
    static let blueBrightDark = UIColor(hex: "5CB3F0")
    static let lineOnDark = UIColor(hex: "1C4D78")
    static let alarmDark = UIColor(hex: "EF6A56")
    static let textSecondaryDark = UIColor(hex: "CFE3F2")
    static let textTertiaryDark = UIColor(hex: "8FB2CD")
}

extension Color {
    // semantic surfaces
    static let surfaceApp = Color(UIColor(light: ZGColor.white, dark: ZGColor.navy950))
    static let surfacePanel = Color(UIColor(light: ZGColor.flagBlue100, dark: ZGColor.navy900))
    static let surfaceCard = Color(UIColor(light: ZGColor.white, dark: ZGColor.navy900))

    // semantic text
    static let textPrimary = Color(UIColor(light: ZGColor.ink900, dark: ZGColor.white))
    static let textSecondary = Color(UIColor(light: ZGColor.ink700, dark: ZGColor.textSecondaryDark))
    static let textTertiary = Color(UIColor(light: ZGColor.ink500, dark: ZGColor.textTertiaryDark))
    static let textOnAccent = Color(UIColor(light: ZGColor.white, dark: ZGColor.navy950))

    // ink outline — the comic panel-line color, used on every "object"
    static let inkOutline = Color(UIColor(light: ZGColor.ink900, dark: ZGColor.white))
    static let borderSubtle = Color(UIColor(light: ZGColor.line100, dark: ZGColor.lineOnDark))

    // accents
    static let accentPrimary = Color(UIColor(light: ZGColor.flagBlue700, dark: ZGColor.blueBrightDark))
    static let accentBright = Color(UIColor(light: ZGColor.flagBlue500, dark: ZGColor.blueBrightDark))
    static let accentGold = Color(ZGColor.gold500)
    static let accentAlarm = Color(UIColor(light: ZGColor.red600, dark: ZGColor.alarmDark))

    // per-state colors
    static let stateLoading = Color.accentBright
    static let stateDenied = Color.accentAlarm
    static let stateEmpty = Color.textTertiary
    static let stateResult = Color.accentPrimary

    // hard, zero-blur "comic" shadow color
    static let hardShadow = Color(UIColor(light: ZGColor.ink900, dark: UIColor.black.withAlphaComponent(0.6)))

    // base tokens used directly by a couple of components
    static let flagBlue100 = Color(ZGColor.flagBlue100)
    static let ink300 = Color(ZGColor.ink300)
}
