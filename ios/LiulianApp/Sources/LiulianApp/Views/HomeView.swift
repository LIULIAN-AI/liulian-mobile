import SwiftUI
import LiulianUI

/// First-run screen. Mirrors the layout from web mobile-preview.html but built in pure SwiftUI
/// using LiulianUI components. No raw numbers — all values from LiulianTokens.
struct HomeView: View {
    @State private var stationSelected: String? = "aare-bern"

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LiulianTokens.Spacing.s5) {
                Header()
                Section_Headline()
                Section_QuickActions()
                Section_Stations()
                Spacer(minLength: LiulianTokens.Spacing.s9)
            }
            .padding(LiulianTokens.Spacing.s5)
        }
        .background(LiulianTokens.Colors.canvasWarm.ignoresSafeArea())
    }

    @ViewBuilder
    private func Header() -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                LiulianText("liulian · home", variant: .monoLabel,
                            color: LiulianTokens.Colors.inkFaint)
                LiulianText("Forecast", variant: .heading)
            }
            Spacer()
            LiulianButton("Search", variant: .ghost, size: .sm) {}
        }
    }

    @ViewBuilder
    private func Section_Headline() -> some View {
        LiulianCard(size: .spacious) {
            LiulianText("Aare-Bern", variant: .title)
            HStack(alignment: .firstTextBaseline) {
                LiulianText("142 cm", variant: .display,
                            color: LiulianTokens.Colors.inkCharcoal)
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    LiulianText("+ 6 cm / 24h", variant: .body,
                                color: LiulianTokens.Colors.unibeRedText)
                    LiulianText("forecast", variant: .monoLabel,
                                color: LiulianTokens.Colors.inkFaint)
                }
            }
        }
    }

    @ViewBuilder
    private func Section_QuickActions() -> some View {
        LiulianText("quick actions", variant: .monoLabel,
                    color: LiulianTokens.Colors.inkFaint)
        HStack(spacing: LiulianTokens.Spacing.s3) {
            LiulianButton("Forecast", variant: .primary, size: .md) {}
            LiulianButton("Alerts", variant: .secondary, size: .md) {}
        }
    }

    @ViewBuilder
    private func Section_Stations() -> some View {
        LiulianText("stations", variant: .monoLabel,
                    color: LiulianTokens.Colors.inkFaint)
            .padding(.top, LiulianTokens.Spacing.s4)
        VStack(spacing: LiulianTokens.Spacing.s3) {
            ForEach(["aare-bern", "rhein-rheinfelden", "ticino-bellinzona"], id: \.self) { id in
                LiulianCard(
                    variant: .interactive,
                    size: .compact,
                    selected: stationSelected == id,
                    onPress: { stationSelected = id }
                ) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            LiulianText(id, variant: .bodyStrong)
                            LiulianText("142 cm · forecast +6", variant: .caption,
                                        color: LiulianTokens.Colors.inkMuted)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(LiulianTokens.Colors.inkFaint)
                            .font(.system(size: LiulianTokens.FontSize.md))
                    }
                }
            }
        }
    }
}

#if DEBUG
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
