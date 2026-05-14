import SwiftUI

/// LiulianButton — per ui-spec/Button.spec.md.
///
/// Renders via SwiftUI primitives, NOT system UIButton. Disables default highlights,
/// renders own press scale + focus ring. Touch target padded to platform minimum.
public struct LiulianButton: View {
    public enum Variant {
        case primary
        case secondary
        case ghost
        case danger
    }

    public enum Size {
        case sm
        case md
        case lg
    }

    let label: String
    let variant: Variant
    let size: Size
    let loading: Bool
    let disabled: Bool
    let onPress: () -> Void

    @State private var isPressed: Bool = false
    @State private var isHovered: Bool = false
    @FocusState private var isFocused: Bool

    public init(
        _ label: String,
        variant: Variant = .primary,
        size: Size = .md,
        loading: Bool = false,
        disabled: Bool = false,
        onPress: @escaping () -> Void
    ) {
        self.label = label
        self.variant = variant
        self.size = size
        self.loading = loading
        self.disabled = disabled
        self.onPress = onPress
    }

    public var body: some View {
        Button(action: { if !loading && !disabled { onPress() } }) {
            HStack(spacing: LiulianTokens.Control.IconGap.value) {
                if loading {
                    // Simple rotating circle as our spinner — matches design-system motion token.
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(foregroundColor)
                        .scaleEffect(0.8)
                } else {
                    LiulianText(label, variant: textVariant, color: foregroundColor)
                }
            }
            .frame(height: height)
            .padding(.horizontal, paddingX)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: LiulianTokens.Radius.md))
            .overlay(borderOverlay)
            .scaleEffect(isPressed ? LiulianTokens.Control.ScaleActive.value : 1.0)
            .offset(y: isHovered && !isPressed ? -1 : 0)
            .opacity(disabled ? LiulianTokens.Opacity.disabled : 1.0)
            // Focus ring (always visible when focused, per spec)
            .overlay(
                RoundedRectangle(cornerRadius: LiulianTokens.Radius.md)
                    .strokeBorder(
                        isFocused ? LiulianTokens.Colors.unibeRed : Color.clear,
                        lineWidth: LiulianTokens.Focus.ringWidth
                    )
                    .padding(-(LiulianTokens.Focus.ringOffset))
            )
            .animation(
                .timingCurve(0.16, 1.0, 0.3, 1.0, duration: LiulianTokens.Duration.fast),
                value: isHovered
            )
            .animation(
                .timingCurve(0.22, 1.0, 0.36, 1.0, duration: LiulianTokens.Duration.instant),
                value: isPressed
            )
        }
        .buttonStyle(.plain)
        .focused($isFocused)
        .disabled(disabled || loading)
        .accessibilityLabel(Text(label))
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(loading ? Text("Loading") : Text(""))
        // Ensure tappable area meets platform min target
        .frame(minHeight: LiulianTokens.Touch.minTargetIos)
        .contentShape(Rectangle())
        .onLongPressGesture(
            minimumDuration: .infinity,
            maximumDistance: .infinity,
            perform: {},
            onPressingChanged: { pressing in isPressed = pressing }
        )
#if os(macOS)
        .onHover { hovering in isHovered = hovering }
#endif
    }

    // MARK: - Style resolution

    private var height: CGFloat {
        switch size {
        case .sm: return LiulianTokens.Control.Height.sm
        case .md: return LiulianTokens.Control.Height.md
        case .lg: return LiulianTokens.Control.Height.lg
        }
    }

    private var paddingX: CGFloat {
        switch size {
        case .sm: return LiulianTokens.Control.PaddingX.sm
        case .md: return LiulianTokens.Control.PaddingX.md
        case .lg: return LiulianTokens.Control.PaddingX.lg
        }
    }

    private var textVariant: LiulianText.Variant {
        switch size {
        case .sm: return .caption
        case .md: return .body
        case .lg: return .subtitle
        }
    }

    private var backgroundColor: Color {
        let base: Color
        switch variant {
        case .primary: base = LiulianTokens.Colors.unibeRed
        case .secondary: base = LiulianTokens.Colors.surfacePure
        case .ghost:    base = Color.clear
        case .danger:   base = LiulianTokens.Colors.unibeRedDeep
        }
        if isPressed { return base.opacity(0.95) }
        if isHovered {
            switch variant {
            case .primary: return LiulianTokens.Colors.unibeRedDeep
            case .secondary: return LiulianTokens.Colors.canvasWarm
            case .ghost:   return LiulianTokens.Colors.canvasWarm
            case .danger:  return LiulianTokens.Colors.unibeRedDeep
            }
        }
        return base
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary, .danger: return LiulianTokens.Colors.surfacePure
        case .secondary:        return LiulianTokens.Colors.inkCharcoal
        case .ghost:            return LiulianTokens.Colors.inkMuted
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if variant == .secondary {
            RoundedRectangle(cornerRadius: LiulianTokens.Radius.md)
                .strokeBorder(
                    isHovered ? LiulianTokens.Colors.hairlineStrong : LiulianTokens.Colors.hairline,
                    lineWidth: 1
                )
        }
    }
}

// MARK: - Preview

#if DEBUG
struct LiulianButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s4) {
            LiulianText("Variants", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Primary", variant: .primary) {}
                LiulianButton("Secondary", variant: .secondary) {}
                LiulianButton("Ghost", variant: .ghost) {}
                LiulianButton("Danger", variant: .danger) {}
            }

            LiulianText("Sizes", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Small", size: .sm) {}
                LiulianButton("Medium", size: .md) {}
                LiulianButton("Large", size: .lg) {}
            }

            LiulianText("States", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            HStack(spacing: LiulianTokens.Spacing.s3) {
                LiulianButton("Loading", loading: true) {}
                LiulianButton("Disabled", disabled: true) {}
            }
        }
        .padding(LiulianTokens.Spacing.s7)
        .background(LiulianTokens.Colors.canvasWarm)
    }
}
#endif
