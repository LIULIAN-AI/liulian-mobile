import SwiftUI

/// Font helpers for LIULIAN. Wraps the three embedded font families (Fraunces, Switzer, JetBrains Mono)
/// and exposes a SwiftUI `.font(.liulianText(...))` modifier.
///
/// Per ui-spec/Text.spec.md, this is the ONLY way text should be styled in LiulianUI.
///
/// IMPORTANT: This relies on fonts being registered via Info.plist's `UIAppFonts` entries.
/// If fonts are missing, SwiftUI silently falls back to system fonts — pixel parity will be lost.
/// Run `bash ../shared/scripts/fetch-fonts.sh` to install fonts.
public enum LiulianFont {
    /// Resolve a font family name + size into a SwiftUI Font.
    public static func custom(_ family: String, size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom(family, size: size).weight(weight)
    }

    public static func display(_ size: CGFloat = LiulianTokens.FontSize.xl6) -> Font {
        custom(LiulianTokens.Fonts.display, size: size, weight: .medium)
    }

    public static func serif(_ size: CGFloat, weight: Font.Weight = .medium) -> Font {
        custom(LiulianTokens.Fonts.display, size: size, weight: weight)
    }

    public static func body(_ size: CGFloat = LiulianTokens.FontSize.md, weight: Font.Weight = .regular) -> Font {
        custom(LiulianTokens.Fonts.body, size: size, weight: weight)
    }

    public static func mono(_ size: CGFloat = LiulianTokens.FontSize.xs, weight: Font.Weight = .medium) -> Font {
        custom(LiulianTokens.Fonts.mono, size: size, weight: weight)
    }
}
