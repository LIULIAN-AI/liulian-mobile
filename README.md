# liulian-mobile

Three native mobile apps + shared LiulianUI library, one per platform.

```
liulian-mobile/
├── ios/           — Swift + SwiftUI         (open with Xcode)
├── android/       — Kotlin + Jetpack Compose (open with Android Studio)
├── harmony/       — ArkTS + ArkUI            (open with DevEco Studio)
└── shared/        — tokens, refs, scripts
```

## Why three native codebases (not Flutter / RN)

Three hard constraints make this the only viable choice:

1. **HarmonyOS NEXT support** — first-class, not via community fork
2. **Best-in-class performance and resource use** — pure native AOT, no VM, no JS bridge
3. **Pixel-level consistency** — solved internally via `ui-spec` contract + visual regression discipline, NOT by sharing a render engine

See `../liulian-python/docs/strategy/PLATFORM_BLUEPRINT.md` for full rationale.

## Build, on the platform that matches your IDE

| Platform | OS to develop on | IDE | Build |
|---|---|---|---|
| iOS | macOS | Xcode 15.4+ | `cd ios/LiulianApp && open Package.swift` then ⌘R |
| Android | Linux/macOS/Win | Android Studio Iguana+ | `cd android && ./gradlew :app:installDebug` |
| HarmonyOS | Win/macOS/Linux (beta) | DevEco Studio 5.0+ | open `harmony/` in DevEco, click ▶ |

Each platform's `README.md` has full setup steps.

## Common workflow

```bash
# 1. Build tokens (in liulian-design-system)
cd ../liulian-design-system && node scripts/build.mjs

# 2. Sync tokens into each platform
bash shared/scripts/sync-tokens.sh

# 3. (Once per dev setup) download embedded fonts
bash shared/scripts/fetch-fonts.sh

# 4. Open each platform in its IDE and ⌘R / ▶
```

## The LiulianUI library per platform

Each platform has its own `LiulianUI` module:

- `ios/LiulianUI/`     — Swift Package
- `android/liulian-ui/` — Gradle module
- `harmony/liulian_ui/` — HAR (HarmonyOS Archive) module

All three implement the same components specified in `../liulian-design-system/ui-spec/*.spec.md`:

- `LiulianButton`
- `LiulianCard`
- `LiulianText`
- `LiulianInput`  (v0 stub; full impl in next sprint)
- `LiulianTab`    (v0 stub)
- `LiulianListItem` (v0 stub)

Each app target includes a `GalleryView` page rendering all variants × states for VR comparison.

## Visual regression

```bash
# Take screenshots of GalleryView on each platform
bash shared/scripts/vr-capture.sh        # opens each emulator/sim/device

# Generate 4-grid comparison (web from liulian-web + 3 native)
bash shared/scripts/vr-diff.sh           # produces shared/refs/<component>-4grid.png
```

See `../liulian-design-system/VR_TESTING.md` for full workflow.

## Status

| Component | iOS | Android | HarmonyOS | Spec |
|---|---|---|---|---|
| Button | ✅ v0 | ✅ v0 | ✅ v0 | done |
| Card | ✅ v0 | ✅ v0 | ✅ v0 | done |
| Text | ✅ v0 | ✅ v0 | ✅ v0 | done |
| Input | 🟡 stub | 🟡 stub | 🟡 stub | done |
| Tab | 🟡 stub | 🟡 stub | 🟡 stub | done |
| ListItem | 🟡 stub | 🟡 stub | 🟡 stub | done |
| Gallery view | ✅ | ✅ | ✅ | — |
| Home screen | ✅ skeleton | ✅ skeleton | ✅ skeleton | — |
| Forecast screen | ⏳ | ⏳ | ⏳ | — |
| Alerts screen | ⏳ | ⏳ | ⏳ | — |

v0 = compiles, renders Button/Card/Text with correct tokens; missing some states & a11y wiring.
🟡 stub = file exists with placeholder, not implemented yet.

## License

MIT (matches liulian-python).
