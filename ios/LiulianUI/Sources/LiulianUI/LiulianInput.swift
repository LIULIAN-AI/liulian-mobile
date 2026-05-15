import SwiftUI

/// LiulianInput — per ui-spec/Input.spec.md.
public struct LiulianInput: View {
    public enum Variant {
        case text, password, search, number, textarea
    }
    public enum Size {
        case sm, md
    }

    @Binding var value: String
    let variant: Variant
    let size: Size
    let label: String?
    let placeholder: String?
    let helpText: String?
    let errorText: String?
    let disabled: Bool
    let readonly: Bool

    @FocusState private var isFocused: Bool

    public init(
        value: Binding<String>,
        variant: Variant = .text,
        size: Size = .md,
        label: String? = nil,
        placeholder: String? = nil,
        helpText: String? = nil,
        errorText: String? = nil,
        disabled: Bool = false,
        readonly: Bool = false
    ) {
        self._value = value
        self.variant = variant
        self.size = size
        self.label = label
        self.placeholder = placeholder
        self.helpText = helpText
        self.errorText = errorText
        self.disabled = disabled
        self.readonly = readonly
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s2) {
            if let label = label {
                LiulianText(label, variant: .bodyStrong, color: LiulianTokens.Colors.inkCharcoal)
            }
            inputField
            if let errorText = errorText {
                LiulianText(errorText, variant: .caption, color: LiulianTokens.Colors.unibeRedText)
            } else if let helpText = helpText {
                LiulianText(helpText, variant: .caption, color: LiulianTokens.Colors.inkMuted)
            }
        }
    }

    private var inputField: some View {
        let bg = (disabled || readonly) ? LiulianTokens.Colors.surfaceShade : LiulianTokens.Colors.surfacePure
        let borderColor: Color = {
            if errorText != nil { return LiulianTokens.Colors.unibeRedText }
            if isFocused { return LiulianTokens.Colors.unibeRed }
            return LiulianTokens.Colors.hairline
        }()
        let height: CGFloat = {
            if variant == .textarea { return 80 }
            return size == .sm ? LiulianTokens.Control.Height.sm : LiulianTokens.Control.Height.md
        }()

        return Group {
            if variant == .textarea {
                TextEditor(text: $value)
                    .focused($isFocused)
                    .disabled(disabled)
                    .frame(height: height)
                    .padding(.horizontal, LiulianTokens.Spacing.s3)
                    .padding(.vertical, LiulianTokens.Spacing.s2)
                    .scrollContentBackground(.hidden)
            } else if variant == .password {
                SecureField(placeholder ?? "", text: $value)
                    .focused($isFocused)
                    .disabled(disabled)
                    .frame(height: height)
                    .padding(.horizontal, LiulianTokens.Spacing.s3)
            } else {
                TextField(placeholder ?? "", text: $value)
                    .focused($isFocused)
                    .disabled(disabled || readonly)
                    .keyboardType(variant == .number ? .numberPad : .default)
                    .frame(height: height)
                    .padding(.horizontal, LiulianTokens.Spacing.s3)
            }
        }
        .font(LiulianFont.body(LiulianTokens.FontSize.md))
        .foregroundColor(LiulianTokens.Colors.inkCharcoal)
        .accentColor(LiulianTokens.Colors.unibeRed)
        .background(bg)
        .overlay(
            RoundedRectangle(cornerRadius: LiulianTokens.Radius.sm)
                .strokeBorder(borderColor, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: LiulianTokens.Radius.sm))
        .opacity(disabled ? LiulianTokens.Opacity.disabled : 1.0)
    }
}

#if DEBUG
struct LiulianInput_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @State var text1 = ""
        @State var text2 = "abc"
        @State var text3 = "read-only"
        @State var text4 = "disabled"

        var body: some View {
            VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s4) {
                LiulianInput(value: $text1, label: "Station", placeholder: "e.g. aare-bern")
                LiulianInput(value: $text2, label: "Validated", errorText: "Must start with a letter")
                LiulianInput(value: $text3, label: "Readonly", readonly: true)
                LiulianInput(value: $text4, label: "Disabled", disabled: true)
            }
            .padding(LiulianTokens.Spacing.s6)
            .background(LiulianTokens.Colors.canvasWarm)
        }
    }
    static var previews: some View {
        PreviewContainer()
    }
}
#endif
