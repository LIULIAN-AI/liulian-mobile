import SwiftUI

/// LiulianText — type renderer per ui-spec/Text.spec.md.
///
/// Always use this for any visible text in LIULIAN. Maps `Variant` to a fixed bundle of
/// (font, size, weight, lineHeight, letterSpacing, color).
public struct LiulianText: View {
    public enum Variant {
        case display
        case displayShort
        case heading
        case title
        case subtitle
        case body
        case bodyStrong
        case caption
        case monoLabel
    }

    let text: String
    let variant: Variant
    let color: Color
    let wonkU: Bool
    let alignment: TextAlignment
    let lineLimit: Int?

    public init(
        _ text: String,
        variant: Variant = .body,
        color: Color = LiulianTokens.Colors.inkCharcoal,
        wonkU: Bool = false,
        alignment: TextAlignment = .leading,
        lineLimit: Int? = nil
    ) {
        self.text = text
        self.variant = variant
        self.color = color
        self.wonkU = wonkU
        self.alignment = alignment
        self.lineLimit = lineLimit
    }

    public var body: some View {
        Text(text)
            .font(font)
            .kerning(letterSpacing)
            .lineSpacing(lineSpacingValue)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .textCase(variant == .monoLabel ? .uppercase : nil)
            .lineLimit(lineLimit)
    }

    private var font: Font {
        switch variant {
        case .display:        return LiulianFont.serif(LiulianTokens.FontSize.xl6, weight: .medium)
        case .displayShort:   return LiulianFont.serif(LiulianTokens.FontSize.xl5, weight: .medium)
        case .heading:        return LiulianFont.serif(LiulianTokens.FontSize.xl4, weight: .medium)
        case .title:          return LiulianFont.serif(LiulianTokens.FontSize.xl3, weight: .medium)
        case .subtitle:       return LiulianFont.body(LiulianTokens.FontSize.xl, weight: .medium)
        case .body:           return LiulianFont.body(LiulianTokens.FontSize.md, weight: .regular)
        case .bodyStrong:     return LiulianFont.body(LiulianTokens.FontSize.md, weight: .medium)
        case .caption:        return LiulianFont.body(LiulianTokens.FontSize.xs, weight: .regular)
        case .monoLabel:      return LiulianFont.mono(LiulianTokens.FontSize.xs, weight: .medium)
        }
    }

    private var letterSpacing: CGFloat {
        switch variant {
        case .display:        return LiulianTokens.FontSize.xl6 * -0.04
        case .displayShort:   return LiulianTokens.FontSize.xl5 * -0.035
        case .heading:        return LiulianTokens.FontSize.xl4 * -0.025
        case .title:          return LiulianTokens.FontSize.xl3 * -0.02
        case .subtitle:       return LiulianTokens.FontSize.xl  * -0.01
        case .monoLabel:      return LiulianTokens.FontSize.xs  * 0.10
        default:              return 0
        }
    }

    private var lineSpacingValue: CGFloat {
        // SwiftUI lineSpacing is additional spacing, not multiplier. Compute as (lineHeight - 1.0) * fontSize.
        let lh: CGFloat
        switch variant {
        case .display, .displayShort: lh = 0.95
        case .heading:                 lh = 1.05
        case .title:                   lh = 1.12
        case .subtitle:                lh = 1.35
        case .body, .bodyStrong:       lh = 1.55
        case .caption:                 lh = 1.45
        case .monoLabel:               lh = 1.40
        }
        let fs: CGFloat
        switch variant {
        case .display:      fs = LiulianTokens.FontSize.xl6
        case .displayShort: fs = LiulianTokens.FontSize.xl5
        case .heading:      fs = LiulianTokens.FontSize.xl4
        case .title:        fs = LiulianTokens.FontSize.xl3
        case .subtitle:     fs = LiulianTokens.FontSize.xl
        case .body, .bodyStrong: fs = LiulianTokens.FontSize.md
        case .caption, .monoLabel: fs = LiulianTokens.FontSize.xs
        }
        return max(0, (lh - 1.0) * fs)
    }
}

// MARK: - Preview

#if DEBUG
struct LiulianText_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s4) {
            LiulianText("LIULIAN", variant: .display)
            LiulianText("Forecast Canvas", variant: .heading)
            LiulianText("Aare-Bern station", variant: .title)
            LiulianText("Real-time water level monitoring across Switzerland", variant: .subtitle)
            LiulianText("Default paragraph text. Used for the bulk of UI copy in LIULIAN.", variant: .body)
            LiulianText("Emphasis within body", variant: .bodyStrong)
            LiulianText("meta · 12:34 UTC · station 2135", variant: .caption, color: LiulianTokens.Colors.inkMuted)
            LiulianText("system status", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
        }
        .padding(LiulianTokens.Spacing.s7)
        .background(LiulianTokens.Colors.canvasWarm)
    }
}
#endif
