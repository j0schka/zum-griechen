import CoreText
import SwiftUI
import UIKit

// Ported from tokens/typography.css. Fredoka ships only as a variable font
// (wght 300–700), so weights are dialed in via a CoreText variation
// attribute rather than separate static files. Bangers is a single static
// weight reserved for the splash's "YAMAS!" shout — never body copy.

enum FredokaWeight {
    case regular
    case medium
    case semibold
    case bold

    fileprivate var value: CGFloat {
        switch self {
        case .regular: return 400
        case .medium: return 500
        case .semibold: return 600
        case .bold: return 700
        }
    }
}

enum AppFont {
    static func fredoka(_ size: CGFloat, weight: FredokaWeight = .regular) -> Font {
        Font(fredokaUIFont(size: size, weight: weight))
    }

    static func bangers(_ size: CGFloat) -> Font {
        .custom("Bangers-Regular", size: size)
    }

    private static func fredokaUIFont(size: CGFloat, weight: FredokaWeight) -> UIFont {
        let base = UIFontDescriptor(name: "Fredoka-Light", size: size)
        let wghtAxisIdentifier: UInt32 = 0x77676874 // 'wght'
        let variationAttributeName = UIFontDescriptor.AttributeName(rawValue: kCTFontVariationAttribute as String)
        let varied = base.addingAttributes([
            variationAttributeName: [wghtAxisIdentifier: weight.value],
        ])
        return UIFont(descriptor: varied, size: size)
    }
}

enum TypeScale {
    static let distance: CGFloat = 112
    static let distanceSmall: CGFloat = 64
    static let unit: CGFloat = 26
    static let name: CGFloat = 20
    static let title: CGFloat = 25
    static let body: CGFloat = 17
    static let caption: CGFloat = 13
    static let shout: CGFloat = 40
}
