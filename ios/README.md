# LIULIAN iOS app

SwiftUI + Swift Package Manager. Min iOS 16.0.

## Layout

```
ios/
├── LiulianUI/                  ← Swift Package (the UI library — open & build standalone)
│   ├── Package.swift
│   ├── Sources/LiulianUI/
│   │   ├── Tokens.swift        ← auto-generated, do not edit (synced from liulian-design-system)
│   │   ├── LiulianFont.swift   ← font registration + Fraunces / Switzer / JBMono helpers
│   │   ├── LiulianText.swift   ← Text component
│   │   ├── LiulianButton.swift ← Button component
│   │   ├── LiulianCard.swift   ← Card component
│   │   └── LiulianGallery.swift ← internal gallery view (used by App's GalleryView)
│   └── Tests/LiulianUITests/
└── LiulianApp/                 ← app target source — wrap in Xcode app project
    ├── Info.plist
    ├── Sources/LiulianApp/
    │   ├── LiulianAppMain.swift  ← @main entry
    │   └── Views/
    │       ├── HomeView.swift
    │       └── GalleryView.swift
    └── Resources/Fonts/         ← downloaded by shared/scripts/fetch-fonts.sh (gitignored)
```

## Setup, first time

1. Run `bash ../shared/scripts/fetch-fonts.sh` to download Fraunces / Switzer / JetBrains Mono into `LiulianApp/Resources/Fonts/`.
2. Run `bash ../shared/scripts/sync-tokens.sh` to populate `LiulianUI/Sources/LiulianUI/Tokens.swift`.
3. **Open `LiulianUI/Package.swift` in Xcode** — Xcode opens it as a Swift Package. You can build the library, run tests, and use SwiftUI previews on `LiulianGallery`.
4. **Create an Xcode iOS App project** named `LiulianApp` pointing at the `LiulianApp/Sources/LiulianApp/` directory:
   - File → New → Project → iOS → App
   - Interface: SwiftUI · Language: Swift · Bundle ID: `ai.liulian.app`
   - Add `LiulianUI` as Local Package Dependency: File → Add Package Dependencies → Add Local… → select `ios/LiulianUI/`
   - Drag `Info.plist` and `Resources/Fonts/` into the Xcode project; mark "Copy if needed"
   - Set `LiulianAppMain.swift` as the @main entry (delete the auto-generated `ContentView.swift`)
5. Build & run on iOS Simulator (iPhone 15 Pro recommended for VR baseline).

## Pixel-parity discipline

- **Never use raw numbers in styling**. Always reference `LiulianTokens.Spacing.s4` not `16.0`.
- **Don't use UIKit's `UIButton`, `UISwitch`, etc.**. We render via SwiftUI primitives + custom rendering to achieve cross-platform parity.
- **Disable system highlights**. Default SwiftUI `Button` has `.buttonStyle(.borderedProminent)` etc. — we override with `.buttonStyle(.plain)` and render our own press / focus states.

## Visual regression

In Xcode, open `LiulianUI/Sources/LiulianUI/LiulianGallery.swift`, use the SwiftUI Preview (⌥⌘P). Right-click preview canvas → "Export Preview Image…" → save as `shared/refs/ios-Gallery.png`. Compare against the other platforms via `shared/scripts/vr-diff.sh`.
