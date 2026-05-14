import SwiftUI

/// LiulianCard — per ui-spec/Card.spec.md.
///
/// Surface container with hairline border, three padding sizes, optional header / footer slots,
/// and optional interactive variant (tappable with hover lift + shadow).
public struct LiulianCard<Header: View, Content: View, Footer: View>: View {
    public enum Variant {
        case `static`
        case interactive
    }

    public enum Size {
        case compact
        case `default`
        case spacious
    }

    let variant: Variant
    let size: Size
    let selected: Bool
    let disabled: Bool
    let onPress: (() -> Void)?
    let header: () -> Header
    let content: () -> Content
    let footer: () -> Footer

    @State private var isHovered: Bool = false
    @State private var isPressed: Bool = false
    @FocusState private var isFocused: Bool

    public init(
        variant: Variant = .static,
        size: Size = .default,
        selected: Bool = false,
        disabled: Bool = false,
        onPress: (() -> Void)? = nil,
        @ViewBuilder header: @escaping () -> Header = { EmptyView() },
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer = { EmptyView() }
    ) {
        self.variant = variant
        self.size = size
        self.selected = selected
        self.disabled = disabled
        self.onPress = onPress
        self.header = header
        self.content = content
        self.footer = footer
    }

    public var body: some View {
        let inner = VStack(alignment: .leading, spacing: gap) {
            if !(header() is EmptyView) {
                header()
                Divider().background(LiulianTokens.Colors.hairline)
            }
            content()
            if !(footer() is EmptyView) {
                Divider().background(LiulianTokens.Colors.hairline)
                footer()
            }
        }
        .padding(padding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LiulianTokens.Colors.surfacePure)
        .clipShape(RoundedRectangle(cornerRadius: LiulianTokens.Radius.md))
        .overlay(
            RoundedRectangle(cornerRadius: LiulianTokens.Radius.md)
                .strokeBorder(borderColor, lineWidth: borderWidth)
        )
        .offset(y: isHovered && !isPressed ? -2 : 0)
        .scaleEffect(isPressed ? 0.99 : 1.0)
        .shadow(
            color: isHovered ? Color.black.opacity(0.04) : Color.clear,
            radius: 8, x: 0, y: 2
        )
        .opacity(disabled ? LiulianTokens.Opacity.disabled : 1.0)
        .overlay(
            RoundedRectangle(cornerRadius: LiulianTokens.Radius.md)
                .strokeBorder(
                    isFocused ? LiulianTokens.Colors.unibeRed : Color.clear,
                    lineWidth: LiulianTokens.Focus.ringWidth
                )
                .padding(-(LiulianTokens.Focus.ringOffset))
        )
        .animation(
            .timingCurve(0.16, 1.0, 0.3, 1.0, duration: LiulianTokens.Duration.medium),
            value: isHovered
        )

        if variant == .interactive, let onPress = onPress {
            Button(action: { if !disabled { onPress() } }) { inner }
                .buttonStyle(.plain)
                .focused($isFocused)
                .disabled(disabled)
                .onLongPressGesture(
                    minimumDuration: .infinity,
                    maximumDistance: .infinity,
                    perform: {},
                    onPressingChanged: { pressing in isPressed = pressing }
                )
#if os(macOS)
                .onHover { hovering in isHovered = hovering }
#endif
        } else {
            inner
        }
    }

    private var padding: CGFloat {
        switch size {
        case .compact:  return LiulianTokens.Spacing.s4
        case .default:  return LiulianTokens.Spacing.s6
        case .spacious: return LiulianTokens.Spacing.s7
        }
    }

    private var gap: CGFloat {
        switch size {
        case .compact:  return LiulianTokens.Spacing.s3
        case .default:  return LiulianTokens.Spacing.s4
        case .spacious: return LiulianTokens.Spacing.s5
        }
    }

    private var borderColor: Color {
        if selected { return LiulianTokens.Colors.unibeRed }
        if isHovered { return LiulianTokens.Colors.hairlineStrong }
        return LiulianTokens.Colors.hairline
    }

    private var borderWidth: CGFloat {
        selected ? 2 : 1
    }
}

// MARK: - Preview

#if DEBUG
struct LiulianCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: LiulianTokens.Spacing.s4) {
            LiulianCard {
                LiulianText("Aare-Bern", variant: .title)
                LiulianText("Water level 142 cm · 24h forecast +6 cm", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }

            LiulianCard(variant: .interactive, onPress: {}) {
                LiulianText("Forecast canvas", variant: .title)
                LiulianText("Tap to view the full forecast workspace.", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }

            LiulianCard(selected: true) {
                LiulianText("Selected station", variant: .title)
                LiulianText("Border thickens, color shifts to UniBe red.", variant: .body, color: LiulianTokens.Colors.inkMuted)
            }
        }
        .padding(LiulianTokens.Spacing.s6)
        .background(LiulianTokens.Colors.canvasWarm)
    }
}
#endif
