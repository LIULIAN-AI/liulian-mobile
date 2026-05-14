import SwiftUI

/// LiulianGallery — VR baseline view. Renders all component variants × states.
/// Used for visual regression: capture this view as PNG on each platform, side-by-side diff.
public struct LiulianGallery: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s8) {
                Header()
                Section_Text()
                Section_Button()
                Section_Card()
                Spacer(minLength: LiulianTokens.Spacing.s10)
            }
            .padding(LiulianTokens.Spacing.s6)
        }
        .background(LiulianTokens.Colors.canvasWarm)
    }

    @ViewBuilder
    private func Header() -> some View {
        VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s2) {
            LiulianText("LIULIAN · iOS", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            LiulianText("Component Gallery", variant: .heading)
            LiulianText("Visual regression baseline. All variants × all states.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
    }

    @ViewBuilder
    private func Section_Text() -> some View {
        SectionTitle("LiulianText")
        VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s3) {
            LiulianText("display 96", variant: .display)
            LiulianText("displayShort 56", variant: .displayShort)
            LiulianText("heading 38", variant: .heading)
            LiulianText("title 28", variant: .title)
            LiulianText("subtitle 18", variant: .subtitle)
            LiulianText("body 13.5 — default paragraph", variant: .body)
            LiulianText("bodyStrong 13.5/500", variant: .bodyStrong)
            LiulianText("caption 10.5 muted", variant: .caption, color: LiulianTokens.Colors.inkMuted)
            LiulianText("monoLabel 10.5 uppercase", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
        }
    }

    @ViewBuilder
    private func Section_Button() -> some View {
        SectionTitle("LiulianButton")

        LiulianText("variants", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
        HStack(spacing: LiulianTokens.Spacing.s3) {
            LiulianButton("Primary", variant: .primary) {}
            LiulianButton("Secondary", variant: .secondary) {}
            LiulianButton("Ghost", variant: .ghost) {}
            LiulianButton("Danger", variant: .danger) {}
        }

        LiulianText("sizes", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            .padding(.top, LiulianTokens.Spacing.s3)
        HStack(alignment: .center, spacing: LiulianTokens.Spacing.s3) {
            LiulianButton("Small", size: .sm) {}
            LiulianButton("Medium", size: .md) {}
            LiulianButton("Large", size: .lg) {}
        }

        LiulianText("states", variant: .monoLabel, color: LiulianTokens.Colors.inkFaint)
            .padding(.top, LiulianTokens.Spacing.s3)
        HStack(spacing: LiulianTokens.Spacing.s3) {
            LiulianButton("Loading", loading: true) {}
            LiulianButton("Disabled", disabled: true) {}
        }
    }

    @ViewBuilder
    private func Section_Card() -> some View {
        SectionTitle("LiulianCard")

        LiulianCard(size: .compact) {
            LiulianText("Compact card", variant: .title)
            LiulianText("Padding s4 (16). Use for dense lists.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
        LiulianCard {
            LiulianText("Default card", variant: .title)
            LiulianText("Padding s6 (24). Standard surface for content.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
        LiulianCard(size: .spacious) {
            LiulianText("Spacious card", variant: .title)
            LiulianText("Padding s7 (32). Hero / featured surfaces.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
        LiulianCard(variant: .interactive, onPress: {}) {
            LiulianText("Interactive card", variant: .title)
            LiulianText("Hover lifts -2px with shadow.raise. Press scales 0.99.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
        LiulianCard(selected: true) {
            LiulianText("Selected card", variant: .title)
            LiulianText("Border becomes 2px UniBe red.",
                        variant: .body, color: LiulianTokens.Colors.inkMuted)
        }
    }

    @ViewBuilder
    private func SectionTitle(_ title: String) -> some View {
        LiulianText(title, variant: .title)
            .padding(.top, LiulianTokens.Spacing.s4)
    }
}

#if DEBUG
struct LiulianGallery_Previews: PreviewProvider {
    static var previews: some View {
        LiulianGallery()
    }
}
#endif
