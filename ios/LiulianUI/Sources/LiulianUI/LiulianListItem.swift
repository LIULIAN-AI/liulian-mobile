import SwiftUI

/// LiulianListItem — per ui-spec/ListItem.spec.md.
public struct LiulianListItem: View {
    public enum Variant {
        case navigation, content, selectable, multiSelectable
    }

    let primary: String
    let secondary: String?
    let leadingIcon: String?
    let variant: Variant
    let selected: Bool
    let disabled: Bool
    let onPress: () -> Void

    public init(
        primary: String,
        secondary: String? = nil,
        leadingIcon: String? = nil,
        variant: Variant = .content,
        selected: Bool = false,
        disabled: Bool = false,
        onPress: @escaping () -> Void = {}
    ) {
        self.primary = primary
        self.secondary = secondary
        self.leadingIcon = leadingIcon
        self.variant = variant
        self.selected = selected
        self.disabled = disabled
        self.onPress = onPress
    }

    private var isInteractive: Bool {
        variant != .content
    }

    private var bg: Color {
        if selected && (variant == .selectable || variant == .multiSelectable) {
            return LiulianTokens.Colors.unibeRedTint
        }
        return .clear
    }

    public var body: some View {
        let content = HStack(spacing: LiulianTokens.Spacing.s3) {
            if let icon = leadingIcon {
                LiulianText(icon, variant: .monoLabel, color: LiulianTokens.Colors.inkMuted)
                    .frame(width: LiulianTokens.Control.IconSize.md, height: LiulianTokens.Control.IconSize.md)
            }
            VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s1) {
                LiulianText(primary, variant: .bodyStrong)
                if let secondary = secondary {
                    LiulianText(secondary, variant: .caption, color: LiulianTokens.Colors.inkMuted)
                }
            }
            Spacer()
            trailing
        }
        .padding(.horizontal, LiulianTokens.Spacing.s4)
        .padding(.vertical, LiulianTokens.Spacing.s3)
        .frame(minHeight: 48)
        .background(bg)
        .opacity(disabled ? LiulianTokens.Opacity.disabled : 1.0)

        if isInteractive {
            Button(action: { if !disabled { onPress() } }) { content }
                .buttonStyle(.plain)
                .disabled(disabled)
        } else {
            content
        }
    }

    @ViewBuilder
    private var trailing: some View {
        switch variant {
        case .navigation:
            LiulianText("›", variant: .title, color: LiulianTokens.Colors.inkFaint)
        case .selectable:
            ZStack {
                if selected {
                    Circle()
                        .fill(LiulianTokens.Colors.unibeRed)
                        .frame(width: LiulianTokens.Control.IconSize.md, height: LiulianTokens.Control.IconSize.md)
                    LiulianText("✓", variant: .caption, color: LiulianTokens.Colors.surfacePure)
                } else {
                    Circle()
                        .strokeBorder(LiulianTokens.Colors.hairlineStrong, lineWidth: 1.5)
                        .frame(width: LiulianTokens.Control.IconSize.md, height: LiulianTokens.Control.IconSize.md)
                }
            }
        case .multiSelectable:
            ZStack {
                if selected {
                    RoundedRectangle(cornerRadius: LiulianTokens.Radius.sm)
                        .fill(LiulianTokens.Colors.unibeRed)
                        .frame(width: LiulianTokens.Control.IconSize.md, height: LiulianTokens.Control.IconSize.md)
                    LiulianText("✓", variant: .caption, color: LiulianTokens.Colors.surfacePure)
                } else {
                    RoundedRectangle(cornerRadius: LiulianTokens.Radius.sm)
                        .strokeBorder(LiulianTokens.Colors.hairlineStrong, lineWidth: 1.5)
                        .frame(width: LiulianTokens.Control.IconSize.md, height: LiulianTokens.Control.IconSize.md)
                }
            }
        case .content:
            EmptyView()
        }
    }
}

#if DEBUG
struct LiulianListItem_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            LiulianListItem(primary: "aare-bern", secondary: "142 cm · forecast +6", variant: .navigation, onPress: {})
            LiulianListItem(primary: "rhein-rheinfelden", secondary: "78 cm · stable", variant: .selectable, selected: true, onPress: {})
            LiulianListItem(primary: "ticino-bellinzona", secondary: "210 cm · -3 / 24h", variant: .multiSelectable, selected: false, onPress: {})
            LiulianListItem(primary: "limmat-baden", secondary: "static, no chevron", variant: .content, onPress: {})
        }
        .padding(LiulianTokens.Spacing.s4)
        .background(LiulianTokens.Colors.canvasWarm)
    }
}
#endif
