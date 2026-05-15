import SwiftUI

/// LiulianTab — per ui-spec/Tab.spec.md.
///
/// Active indicator is a single 2pt bar that animates X between tab positions.
/// LIULIAN signature — NOT a UISegmentedControl pill, NOT a Material per-tab indicator.
public struct LiulianTabItem: Identifiable {
    public let id: String
    public let label: String
    public let disabled: Bool

    public init(id: String, label: String, disabled: Bool = false) {
        self.id = id
        self.label = label
        self.disabled = disabled
    }
}

public enum LiulianTabVariant {
    case `default`, compact
}

private struct TabFrame: Equatable {
    let id: String
    let x: CGFloat
    let width: CGFloat
}

private struct TabFramesKey: PreferenceKey {
    static var defaultValue: [TabFrame] = []
    static func reduce(value: inout [TabFrame], nextValue: () -> [TabFrame]) {
        value.append(contentsOf: nextValue())
    }
}

public struct LiulianTab: View {
    let items: [LiulianTabItem]
    let activeId: String
    let onChange: (String) -> Void
    let variant: LiulianTabVariant

    @State private var frames: [TabFrame] = []

    public init(
        items: [LiulianTabItem],
        activeId: String,
        onChange: @escaping (String) -> Void,
        variant: LiulianTabVariant = .default
    ) {
        self.items = items
        self.activeId = activeId
        self.onChange = onChange
        self.variant = variant
    }

    private var height: CGFloat {
        variant == .compact ? LiulianTokens.Control.Height.sm : LiulianTokens.Control.Height.md
    }

    public var body: some View {
        ZStack(alignment: .bottomLeading) {
            HStack(spacing: 0) {
                ForEach(items) { item in
                    Button(action: {
                        if !item.disabled { onChange(item.id) }
                    }) {
                        LiulianText(
                            item.label,
                            variant: .monoLabel,
                            color: item.id == activeId ? LiulianTokens.Colors.inkCharcoal : LiulianTokens.Colors.inkMuted
                        )
                        .padding(.horizontal, LiulianTokens.Spacing.s4)
                        .frame(height: height)
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: TabFramesKey.self,
                                    value: [TabFrame(id: item.id, x: geo.frame(in: .named("tabContainer")).minX, width: geo.size.width)]
                                )
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .opacity(item.disabled ? LiulianTokens.Opacity.disabled : 1.0)
                }
            }
            // hairline bottom
            Rectangle()
                .fill(LiulianTokens.Colors.hairline)
                .frame(height: 1)

            // active indicator
            if let active = frames.first(where: { $0.id == activeId }) {
                Rectangle()
                    .fill(LiulianTokens.Colors.unibeRed)
                    .frame(width: active.width, height: 2)
                    .offset(x: active.x)
                    .animation(
                        .timingCurve(0.16, 1.0, 0.3, 1.0, duration: LiulianTokens.Duration.fast),
                        value: activeId
                    )
            }
        }
        .frame(height: height)
        .background(LiulianTokens.Colors.canvasWarm)
        .coordinateSpace(name: "tabContainer")
        .onPreferenceChange(TabFramesKey.self) { newFrames in
            frames = newFrames
        }
    }
}

#if DEBUG
struct LiulianTab_Previews: PreviewProvider {
    struct PreviewContainer: View {
        @State var active = "forecast"
        var body: some View {
            LiulianTab(
                items: [
                    .init(id: "landing", label: "LANDING"),
                    .init(id: "forecast", label: "FORECAST"),
                    .init(id: "studio", label: "STUDIO"),
                ],
                activeId: active,
                onChange: { active = $0 }
            )
        }
    }
    static var previews: some View {
        PreviewContainer()
    }
}
#endif
